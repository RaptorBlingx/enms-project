#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys, argparse, json, base64, os, re
from PIL import Image
import struct
import collections

# --- SELF-CONTAINED QOI DECODER (from dev script) ---
def decode_qoi(data):
    if len(data) < 14 or data[0:4] != b'qoif':
        raise ValueError("Invalid QOI data")
    width = struct.unpack('>I', data[4:8])[0]
    height = struct.unpack('>I', data[8:12])[0]
    channels = data[12]
    pixels = []
    index = 14
    px_r, px_g, px_b, px_a = 0, 0, 0, 255
    array = [(0, 0, 0, 0)] * 64
    run_length = 0
    px_count = width * height
    while len(pixels) < px_count:
        if run_length > 0:
            run_length -= 1
        else:
            if index >= len(data) - 1 and len(pixels) < px_count - 1:
                while len(pixels) < px_count:
                    pixels.append((px_r, px_g, px_b, px_a))
                break
            b1 = data[index]
            index += 1
            if b1 == 0xfe:
                px_r, px_g, px_b = data[index], data[index+1], data[index+2]
                index += 3
            elif b1 == 0xff:
                px_r, px_g, px_b, px_a = data[index], data[index+1], data[index+2], data[index+3]
                index += 4
            elif (b1 & 0xc0) == 0x00:
                px_r, px_g, px_b, px_a = array[b1]
            elif (b1 & 0xc0) == 0x40:
                px_r = (px_r + ((b1 >> 4) & 0x03) - 2) & 0xff
                px_g = (px_g + ((b1 >> 2) & 0x03) - 2) & 0xff
                px_b = (px_b + (b1 & 0x03) - 2) & 0xff
            elif (b1 & 0xc0) == 0x80:
                b2 = data[index]
                index += 1
                vg = (b1 & 0x3f) - 32
                px_r = (px_r + vg - 8 + (b2 >> 4)) & 0xff
                px_g = (px_g + vg) & 0xff
                px_b = (px_b + vg - 8 + (b2 & 0x0f)) & 0xff
            elif (b1 & 0xc0) == 0xc0:
                run_length = (b1 & 0x3f)
        pixels.append((px_r, px_g, px_b, px_a))
        hash_idx = (px_r * 3 + px_g * 5 + px_b * 7 + px_a * 11) % 64
        array[hash_idx] = (px_r, px_g, px_b, px_a)
    mode = 'RGBA' if channels == 4 else 'RGB'
    img = Image.new(mode, (width, height))
    img.putdata([p[:channels] for p in pixels])
    return img

# --- FINAL, INTELLIGENT, AND UNIVERSAL THUMBNAIL EXTRACTION (from dev script) ---
def extract_thumbnail(content, out_dir, jobid):
    B64_RE = re.compile(r'[^A-Za-z0-9+/=]')

    # Define regex for both formats
    qoi_pattern = re.compile(r'; thumbnail_QOI begin (\d+)x(\d+) \d+\n((?:; [A-Za-z0-9+/=]+\n)+); thumbnail_QOI end')
    png_re = re.compile(r'^\s*;?\s*thumbnail\s+begin.*?thumbnail\s+end', re.I | re.S | re.M)

    # First, try the intelligent QOI parsing
    qoi_matches = qoi_pattern.findall(content)

    if qoi_matches:
        sys.stderr.write(f"DEBUG: Found {len(qoi_matches)} QOI thumbnails. Analyzing for best quality...\n")
        largest_thumbnail_data = None
        max_area = -1

        for match in qoi_matches:
            width, height, base64_data = int(match[0]), int(match[1]), match[2]
            area = width * height
            if area > max_area:
                max_area = area
                largest_thumbnail_data = base64_data

        if largest_thumbnail_data:
            try:
                base64_clean = largest_thumbnail_data.replace('; ', '').replace('\n', '')
                qoi_data = base64.b64decode(base64_clean)
                img = decode_qoi(qoi_data)

                os.makedirs(out_dir, exist_ok=True)
                fn = f"{jobid}.png"
                fp = os.path.join(out_dir, fn)
                img.save(fp, 'PNG')

                sys.stderr.write(f"DEBUG: TRUE PNG thumbnail of size {img.width}x{img.height} written to {fp}\n")
                return f"/gcode_previews/{fn}"
            except Exception as e:
                sys.stderr.write(f"CRITICAL: QOI thumbnail processing failed. Error: {e}\n")
                return None

    # If QOI parsing fails or finds nothing, fall back to standard PNG
    png_match = png_re.search(content)
    if png_match:
        sys.stderr.write("DEBUG: No QOI found. Falling back to standard PNG thumbnail...\n")
        try:
            block = png_match.group(0)
            block = re.sub(r'(?is)^.*?thumbnail\s+begin[^\n\r;]*[;\n\r\s]+', '', block, 1)
            block = re.sub(r'(?is)thumbnail\s+end.*$', '', block, 1)
            b64_clean = B64_RE.sub('', block)

            missing_padding = len(b64_clean) % 4
            if missing_padding:
                b64_clean += '=' * (4 - missing_padding)

            decoded_bytes = base64.b64decode(b64_clean, validate=True)

            os.makedirs(out_dir, exist_ok=True)
            fn = f"{jobid}.png"
            fp = os.path.join(out_dir, fn)
            with open(fp, 'wb') as f:
                f.write(decoded_bytes)

            sys.stderr.write(f"DEBUG: Standard PNG thumbnail written to {fp}\n")
            return f"/gcode_previews/{fn}"
        except Exception as e:
            sys.stderr.write(f"CRITICAL: Standard PNG thumbnail processing failed. Error: {e}\n")
            return None

    sys.stderr.write("DEBUG: No thumbnails of any type found.\n")
    return None

# --- METADATA PARSING (from dev script) ---
def parse_duration_to_seconds(duration_str):
    if not duration_str: return None
    seconds = 0
    try:
        matches = re.findall(r'(\d+)\s*(d|h|m|s)', duration_str)
        for value, unit in matches:
            value = int(value)
            if unit == 'd': seconds += value * 86400
            elif unit == 'h': seconds += value * 3600
            elif unit == 'm': seconds += value * 60
            elif unit == 's': seconds += value
        return seconds if seconds > 0 else None
    except Exception:
        return None

def parse_slicer_metadata(gcode_content):
    raw_metadata = {}
    pattern = re.compile(r'^\s*;\s*([^=]+?)\s*=\s*(.*)')
    for line in gcode_content.split('\n'):
        match = pattern.match(line)
        if match:
            key = match.group(1).strip()
            raw_metadata[key] = match.group(2).strip()

    processed_data = {}
    duration_str = raw_metadata.get("estimated printing time (normal mode)")
    processed_data["duration_seconds"] = parse_duration_to_seconds(duration_str)
    try:
        filament_g_str = raw_metadata.get("filament used [g]")
        processed_data["filament_used_g"] = float(filament_g_str) if filament_g_str else None
    except (ValueError, TypeError):
        processed_data["filament_used_g"] = None
    try:
        nozzle_str = raw_metadata.get("nozzle_diameter")
        processed_data["nozzle_diameter"] = float(nozzle_str) if nozzle_str else None
    except (ValueError, TypeError):
        processed_data["nozzle_diameter"] = None
    try:
        filament_dia_str = raw_metadata.get("filament_diameter")
        processed_data["filament_diameter"] = float(filament_dia_str) if filament_dia_str else None
    except (ValueError, TypeError):
        processed_data["filament_diameter"] = None
    return processed_data

# --- PER-PART ANALYSIS (from original script, preserved) ---
OBJECT_START_RE = re.compile(r'; printing object (.*?)')
OBJECT_END_RE = re.compile(r'; stop printing object (.*?)')
G1_COMMAND_RE = re.compile(r'^G1 .*?X([\d\.]+) .*?Y([\d\.]+) .*?Z([\d\.]+)')

def analyze_per_part_volume(gcode_content):
    """
    Analyzes G-code to find the bounding box and volume for each part,
    then calculates the percentage of total volume for each part.
    """
    try:
        parts_data = collections.defaultdict(lambda: {'min_x': float('inf'), 'max_x': float('-inf'),
                                                      'min_y': float('inf'), 'max_y': float('-inf'),
                                                      'min_z': float('inf'), 'max_z': float('-inf')})
        current_part = None
        
        for line in gcode_content.split('\n'):
            start_match = OBJECT_START_RE.match(line)
            if start_match:
                current_part = start_match.group(1).strip()
                continue

            if current_part and OBJECT_END_RE.match(line):
                current_part = None
                continue

            if current_part:
                g1_match = G1_COMMAND_RE.match(line)
                if g1_match:
                    x, y, z = map(float, g1_match.groups())
                    parts_data[current_part]['min_x'] = min(parts_data[current_part]['min_x'], x)
                    parts_data[current_part]['max_x'] = max(parts_data[current_part]['max_x'], x)
                    parts_data[current_part]['min_y'] = min(parts_data[current_part]['min_y'], y)
                    parts_data[current_part]['max_y'] = max(parts_data[current_part]['max_y'], y)
                    parts_data[current_part]['min_z'] = min(parts_data[current_part]['min_z'], z)
                    parts_data[current_part]['max_z'] = max(parts_data[current_part]['max_z'], z)

        if not parts_data:
            return None

        part_volumes = []
        total_volume = 0
        for name, data in parts_data.items():
            width = data['max_x'] - data['min_x']
            depth = data['max_y'] - data['min_y']
            height = data['max_z'] - data['min_z']
            volume = width * depth * height if width > 0 and depth > 0 and height > 0 else 0
            part_volumes.append({'name': name, 'volume': volume})
            total_volume += volume
            
        if total_volume == 0:
            return None

        final_parts_list = []
        for part in part_volumes:
            percentage = round(part['volume'] / total_volume, 4)
            final_parts_list.append({'name': part['name'], 'energy_percentage': percentage})

        return {
            "total_bounding_box_volume": total_volume,
            "parts": final_parts_list
        }

    except Exception as e:
        sys.stderr.write(f"DEBUG: Per-part analysis failed: {e}\n")
        return None

# --- MAIN FUNCTION (MERGED) ---
def main():
    pa = argparse.ArgumentParser()
    pa.add_argument('--file', required=True)
    pa.add_argument('--jobid', required=True)
    args = pa.parse_args()

    # Initialize the output dictionary
    out = {
        "thumbnail_url": None,
        "parsed_data": None,
        "per_part_analysis": None
    }

    try:
        with open(args.file, 'r', encoding='utf-8', errors='ignore') as f:
            txt = f.read()
        
        # 1. Call the new, universal thumbnail function with the CORRECT path
        out['thumbnail_url'] = extract_thumbnail(
            txt, "/app/gcode_previews", args.jobid
        )

        # 2. Call the new Prusa-specific metadata parser
        out['parsed_data'] = parse_slicer_metadata(txt)

        # 3. Call the original per-part analysis function
        out['per_part_analysis'] = analyze_per_part_volume(txt)

    except Exception as e:
        sys.stderr.write(f"ERROR: An exception occurred in main: {e}\n")
        print(json.dumps({"error": str(e)}))
        sys.exit(1)

    print(json.dumps(out))

if __name__ == '__main__':
    main()

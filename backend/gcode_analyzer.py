#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys, argparse, json, base64, os, re
import collections

# --- REGEX DEFINITIONS ---
# This is from your working script
BLOCK_RE = re.compile(
    r'thumbnail\s+begin.*?thumbnail\s+end',
    re.I | re.S
)
# This is from your working script
B64_RE = re.compile(r'[^A-Za-z0-9+/=]')

# --- NEW REGEX FOR PART ANALYSIS ---
OBJECT_START_RE = re.compile(r'; printing object (.*?)')
OBJECT_END_RE = re.compile(r'; stop printing object (.*?)')
G1_COMMAND_RE = re.compile(r'^G1 .*?X([\d\.]+) .*?Y([\d\.]+) .*?Z([\d\.]+)')


def extract_thumbnail(content, out_dir, jobid):
    # This is your working thumbnail function. It is preserved exactly.
    m = BLOCK_RE.search(content)
    if not m:
        sys.stderr.write("DEBUG: No thumbnail block found.\n")
        return None

    block = m.group(0)
    # Remove everything up to (and including) the first newline or semicolon after “begin”
    block = re.sub(r'(?is)^.*?thumbnail\s+begin[^\n\r;]*[;\n\r\s]+', '', block, 1)
    # Remove everything from “thumbnail end” to the end
    block = re.sub(r'(?is)thumbnail\s+end.*$', '', block, 1)

    # Purge non‑Base64 chars and decode
    b64_clean = B64_RE.sub('', block)
    try:
        img = base64.b64decode(b64_clean, validate=True)
    except Exception as e:
        sys.stderr.write(f"DEBUG: Base64 decode failed: {e}\n")
        return None

    os.makedirs(out_dir, exist_ok=True)
    fn = f"{jobid}.png"
    fp = os.path.join(out_dir, fn)
    with open(fp, 'wb') as f:
        f.write(img)

    sys.stderr.write(f"DEBUG: Thumbnail written to {fp}\n")
    return f"/gcode_previews/{fn}"


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


def main():
    pa = argparse.ArgumentParser()
    pa.add_argument('--file', required=True)
    pa.add_argument('--jobid', required=True)
    args = pa.parse_args()

    out = {"thumbnail_url": None, "per_part_analysis": None}
    try:
        with open(args.file, 'r', encoding='utf-8', errors='ignore') as f:
            txt = f.read()
        
        # Call your existing thumbnail function
        out['thumbnail_url'] = extract_thumbnail(
            txt, "/var/www/html/gcode_previews", args.jobid
        )

        # Call the new per-part analysis function
        out['per_part_analysis'] = analyze_per_part_volume(txt)

    except Exception as e:
        print(json.dumps({"error": str(e)}))
        sys.exit(1)

    print(json.dumps(out))

if __name__ == '__main__':
    main()

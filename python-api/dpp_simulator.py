#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# dpp_simulator.py
# External script to handle DPP data generation and simulation state.
import sys
import requests
import json
import os
import sys
import time
import traceback
from datetime import datetime, timedelta, timezone
import psycopg2
import psycopg2.extras
import numpy as np
import re
# No dependency on Node-RED specific objects (node, flow, etc.)
from datetime import datetime, timedelta, timezone


# --- Configuration ---
ACTIVE_POWER_THRESHOLD = 5.0
DATA_FRESHNESS_THRESHOLD_MINUTES = 15

PLANT_TYPES = ["generic_plant", "corn", "sunflower", "tomato"]

# --- Helper function for plant stage ---
PLANT_THRESHOLDS = [0.01, 0.018, 0.021, 0.022, 0.024, 0.027, 0.030, 0.04, 0.045, 0.05, 0.06, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.5, 3.0]

def get_plant_stage(kwh):
    kwh_val = kwh if isinstance(kwh, (int, float)) else float('-inf')
    if kwh_val < PLANT_THRESHOLDS[0]: return 1
    for i in range(len(PLANT_THRESHOLDS) - 1, -1, -1):
        if kwh_val >= PLANT_THRESHOLDS[i]: return min(i + 2, 19)
    return 1


def clean_filename(filename):
    """
    Truncates long filenames to a more display-friendly length.
    e.g., "long_filename_example.gcode" becomes "long_...le.gcode"
    """
    if filename and len(filename) > 30:
        return f"{filename[:15]}...{filename[-15:]}"
    return filename # Return the original name if it's not too long


# --- SIMULATED SMART TIPS ---
TIP_RULES = [
    # --- LEVEL 5: CRITICAL ALERTS (No changes needed, these are great) ---
    {
        "id": "PRINTER_OFFLINE",
        "priority": 50,
        "conditions": lambda p: p.get("currentStatus") == "Offline",
        "tip_template": "Action Required: '{friendlyName}' is offline. Please check its power and network connection."
    },
    {
        "id": "PRINTER_ERROR",
        "priority": 50,
        "conditions": lambda p: p.get("currentStatus") == "Error",
        "tip_template": "Action Required: Error on '{friendlyName}'. Please check the printer's display for details."
    },

    # --- LEVEL 4: PRINT SUCCESS & RISK MITIGATION (Existing specific tips) ---
    # These will only trigger if the data exists, which is what we want.
    {
        "id": "FIRST_LAYER_CRITICAL",
        "priority": 30,
        "conditions": lambda p: p.get("currentStatus") == "Printing" and 0 < p.get("jobProgressPercent", 0) < 5,
        "tip_template": "Tip for Success: The first layer is critical for '{jobFilename}'. Good adhesion prevents failed prints!"
    },
    # This is a data-hungry tip. It will only show if bed dimensions and gcode analysis are available.
    {
        "id": "SMALL_BED_OCCUPANCY_SUGGESTION",
        "priority": 17,
        "conditions": lambda p: (
            p.get("job_details", {}).get("object_dimensions_mm") and p.get("bedWidth") and p.get("bedDepth") and
            p["bedWidth"] > 0 and p["bedDepth"] > 0 and
            ( (p["job_details"]["object_dimensions_mm"]["x"] * p["job_details"]["object_dimensions_mm"]["y"]) / (p["bedWidth"] * p["bedDepth"]) < 0.15 )
        ),
        "tip_template": "Efficiency Tip: This is a small part. To save energy on heating, consider printing multiple small items together in one batch."
    },

    # --- LEVEL 3: EFFICIENCY & COST SAVING (No changes needed) ---
    {
        "id": "HIGH_IDLE_CONSUMPTION",
        "priority": 20,
        "conditions": lambda p: (
            p.get("currentStatus") == "Idle" and
            p.get("kwhLast24h", 0) > 0.5
        ),
        "tip_template": "Energy Tip: '{friendlyName}' is idle but has used {kwhLast24h:.2f} kWh today. Please power it down if not in use."
    },
    {
        "id": "MATERIAL_CHOICE_ENERGY",
        "priority": 15,
        "conditions": lambda p: p.get("currentStatus") == "Printing" and p.get("currentMaterial") in ["PETG", "ABS", "ASA", "PC"],
        "tip_template": "Material Info: For prototypes, PLA often uses less energy due to lower temperature needs than {currentMaterial}."
    },

    # --- LEVEL 2: NEW ROBUST, GENERAL-PURPOSE TIPS (THE HYBRID PART) ---
    # This is the new section that provides useful fallbacks.
    {
        "id": "GENERAL_PRINTING_INFO",
        "priority": 12, # Higher than "near completion" but lower than specific efficiency tips.
        "conditions": lambda p: p.get("currentStatus") == "Printing" and p.get("jobFilename"),
        "tip_template": "Heads up: '{jobFilename}' is currently printing. Monitor its progress to ensure a successful outcome."
    },
    {
        "id": "PRINT_NEAR_COMPLETION",
        "priority": 10,
        "conditions": lambda p: p.get("currentStatus") == "Printing" and p.get("jobProgressPercent", 0) > 95,
        "tip_template": "Almost there! '{jobFilename}' is nearly finished. Get ready to free up the printer for the next user."
    },
    {
        "id": "HEATING_INFO",
        "priority": 5,
        "conditions": lambda p: p.get("currentStatus") == "Heating",
        "tip_template": "'{friendlyName}' is heating up for a {currentMaterial} print. Pre-heating efficiently prevents print start issues."
    },
    {
        "id": "COOLING_INFO",
        "priority": 4,
        "conditions": lambda p: p.get("currentStatus") == "Cooling",
        "tip_template": "Print finished! Now cooling down. Please remove the part once the bed is cool to the touch."
    },


    # --- LEVEL 1: DEFAULT (Lowest Priority Fallback) ---
    {
        "id": "DEFAULT_IDLE",
        "priority": 1,
        "conditions": lambda p: p.get("currentStatus") == "Idle",
        "tip_template": "'{friendlyName}' is idle and ready for its next print job. Perfect time to slice your next creation!"
    },
    {
        # A final catch-all for any other operational state (e.g., "Operational", "Active (Other)")
        "id": "DEFAULT_OPERATIONAL",
        "priority": 0,
        "conditions": lambda p: True, # This will always match if nothing else does
        "tip_template": "Keeping your printer well-maintained ensures great results and energy efficiency."
    }
]


def parse_gcode_metadata(gcode_content):
    """
    Parses slicer metadata from comments throughout a G-code file,
    understanding multiple formats (e.g., 'key: value' and 'key = value').
    """
    metadata = {}
    # Pattern for "key: value" format (from OrcaSlicer header)
    pattern_colon = re.compile(r';\s*([^:]+):\s*(.*)')
    # Pattern for "key = value" format (from standard footers)
    pattern_equals = re.compile(r';\s*([^=]+?)\s*=\s*(.*)')

    lines = gcode_content.split('\n')

    # Process the entire file to find all possible metadata
    for line in lines:
        # First, try to match the colon format
        match = pattern_colon.match(line)
        if match:
            key = match.group(1).strip()
            value = match.group(2).strip()
            metadata[key] = value
            continue # Move to the next line after a successful match

        # If colon format didn't match, try the equals format
        match_equals = pattern_equals.match(line)
        if match_equals:
            key = match_equals.group(1).strip()
            value = match_equals.group(2).strip()
            metadata[key] = value

    # --- Normalize the extracted data into a structured format ---
    job_details = {}

    # Extract layer height (could be in either format)
    if 'layer_height' in metadata:
        try:
            job_details['layer_height_mm'] = float(metadata['layer_height'])
        except ValueError:
            pass # Ignore if value is not a valid float

    # Extract filament usage
    if 'filament used [g]' in metadata:
        try:
            job_details['estimated_material_g'] = float(metadata['filament used [g]'])
        except ValueError:
            pass

    # Extract object dimensions (prioritize the full 'model_size' if it exists)
    if 'model_size' in metadata:
        try:
            dims = metadata['model_size'].split(',')
            job_details['object_dimensions_mm'] = {'x': float(dims[0]), 'y': float(dims[1]), 'z': float(dims[2])}
        except (ValueError, IndexError):
            job_details['object_dimensions_mm'] = None
    elif 'max_z_height' in metadata:
        # Fallback for header-only data: we only have the Z dimension
        try:
            job_details['object_dimensions_mm'] = {'x': 0, 'y': 0, 'z': float(metadata['max_z_height'])}
        except ValueError:
            pass

    print(f"DEBUG: Parsed metadata into job_details: {job_details}", file=sys.stderr)
    return job_details



def evaluate_tips(printer_data):
    """
    Evaluates all tip rules against the printer_data and returns the text
    of the highest-priority applicable tip.
    """
    applicable_tips = []
    # Ensure printer_data is not None, which can happen in edge cases
    if printer_data is None:
        printer_data = {}

    for rule in TIP_RULES:
        try:
            # Check if the conditions for the rule are met
            if rule["conditions"](printer_data):
                # Prepare a copy of printer_data for safe formatting
                # This prevents errors if a tip refers to a nested key that might not exist
                format_data = printer_data.copy()
                format_data["job_details"] = printer_data.get("job_details", {})

                applicable_tips.append({
                    "priority": rule["priority"],
                    "text": rule["tip_template"].format(**format_data)
                })
        except Exception:
            # Silently ignore tips that fail to format. This prevents a single
            # bad tip from crashing the whole process. A warning could be logged here.
            pass

    # If any tips were found, sort them by priority (highest first) and return the best one
    if applicable_tips:
        applicable_tips.sort(key=lambda x: x["priority"], reverse=True)
        return applicable_tips[0]["text"]

    # If no specific tips match, return a generic, helpful message
    return "Monitor print settings for optimal energy and material use."


# --- Main Execution ---
def get_live_dpp_data():
    """
    Connects to the database, fetches all printer data, processes it,
    and returns a dictionary containing the final printer list and global history.
    """
    final_dpp_data = []
    global_history_list = []
    conn = None
    cur = None

    # This is the complete query for fetching all printer and job data.
    query_all_printers = """
    SELECT
        d.device_id, d.friendly_name, d.device_model, d.printer_size_category,
        d.gcode_preview_host, d.gcode_preview_api_key, d.bed_width, d.bed_depth,
        ps.state_text,
        ps.is_operational,
        ps.is_printing,
        ps.is_busy,
        ps.nozzle_temp_actual,
        ps.nozzle_temp_target,
        ps.bed_temp_actual,
        ps.bed_temp_target,
        ps.material,
        ps.filename,
        ps.progress_percent,
        ps.time_left_seconds,
        ps.timestamp AS ps_timestamp,
        COALESCE((
            SELECT (MAX(energy_total_wh) - MIN(energy_total_wh)) / 1000.0
            FROM energy_data
            WHERE device_id = d.device_id AND timestamp >= NOW() - INTERVAL '24 hours'
        ), 0) AS kwh_last_24h,
        pj.gcode_analysis_data,
        pj.session_energy_wh,
        pj.start_energy_wh,
        ed.current_total_wh,
        lj.session_energy_wh AS last_completed_job_kwh,
        lj.duration_seconds AS last_job_duration_seconds,
        lj.filament_used_g AS last_job_filament_g,
        lj.thumbnail_url AS last_job_thumbnail_url,
        lj.per_part_analysis AS last_job_per_part_analysis,
        hist.history_data
    FROM devices d
    LEFT JOIN LATERAL (
        SELECT * FROM printer_status
        WHERE device_id = d.device_id ORDER BY timestamp DESC LIMIT 1
    ) ps ON true
    LEFT JOIN LATERAL (
        SELECT * FROM print_jobs
        WHERE device_id = d.device_id AND filename = ps.filename
        ORDER BY start_time DESC NULLS LAST LIMIT 1
    ) pj ON (ps.filename IS NOT NULL)
    LEFT JOIN LATERAL (
        SELECT energy_total_wh AS current_total_wh FROM energy_data
        WHERE device_id = d.device_id ORDER BY timestamp DESC LIMIT 1
    ) ed ON true
    LEFT JOIN LATERAL (
        SELECT session_energy_wh, duration_seconds, filament_used_g, thumbnail_url, per_part_analysis
        FROM print_jobs
        WHERE device_id = d.device_id AND status = 'done' AND session_energy_wh IS NOT NULL
        ORDER BY start_time DESC NULLS LAST
        LIMIT 1
    ) lj ON true
    LEFT JOIN LATERAL (
        SELECT json_agg(h) AS history_data FROM (
            SELECT filename, session_energy_wh, end_time, thumbnail_url, per_part_analysis
            FROM print_jobs
            WHERE device_id = d.device_id AND status = 'done' AND session_energy_wh IS NOT NULL
            ORDER BY start_time DESC NULLS LAST
            LIMIT 5
        ) h
    ) hist ON true
    WHERE d.device_id != 'environment'
    ORDER BY d.friendly_name;
    """

    query_global_history = """
    SELECT
        d.friendly_name,
        pj.filename,
        pj.session_energy_wh,
        pj.end_time,
        pj.thumbnail_url,
	pj.dpp_pdf_url
    FROM
        print_jobs pj
    JOIN
        devices d ON pj.device_id = d.device_id
    WHERE
        pj.status = 'done'
        AND pj.session_energy_wh IS NOT NULL
        AND pj.session_energy_wh > 0
    ORDER BY
        pj.end_time DESC NULLS LAST
    LIMIT 50;
    """

    try:
        conn = psycopg2.connect(
            dbname="reg_ml", user="reg_ml", password="raptorblingx",
            host="postgres", port="5432"
        )
        cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        cur.execute(query_all_printers)
        all_printers = cur.fetchall()

        cur.execute(query_global_history)
        history_results = cur.fetchall()

        for row in history_results:
            global_history_list.append({
                "printerName": row['friendly_name'],
                "filename": clean_filename(row['filename']),
                "kwh": float(row['session_energy_wh']) / 1000.0 if row['session_energy_wh'] is not None else 0.0,
                "completedAt": row['end_time'].isoformat() if row['end_time'] else None,
                "thumbnailUrl": row['thumbnail_url'],
		"pdfUrl": row['dpp_pdf_url']
            })

        for i, row in enumerate(all_printers):
            try:
                status_text = (row.get('state_text') or 'Offline').capitalize()
                if status_text.lower() in ['operational', 'completed', 'ready']:
                    status_text = 'Idle'

                is_printing = status_text.lower() in ['printing', 'heating']

                device_output = {
                    "deviceId": row['device_id'],
                    "friendlyName": row.get('friendly_name', row['device_id']),
                    "model": row.get('device_model', 'Unknown Model'),
                    "sizeCategory": row.get('printer_size_category', 'Standard'),
                    "plant_type": PLANT_TYPES[i % len(PLANT_TYPES)],
                    "kwhLast24h": float(row['kwh_last_24h'] or 0),
                    "lastJobKwh": float(row.get('last_completed_job_kwh') or 0) / 1000.0,
                    "printTimeSeconds": float(row.get('last_job_duration_seconds') or 0),
                    "lastJobFilamentGrams": float(row.get('last_job_filament_g') or 0),
                    "bedWidth": row.get('bed_width'),
                    "bedDepth": row.get('bed_depth'),
                    'currentStatus': status_text,
                    'isPrintingNow': is_printing,
                    'currentNozzleTemp': float(row.get('nozzle_temp_actual') or 0),
                    'targetNozzleTemp': float(row.get('nozzle_temp_target') or 0),
                    'currentBedTemp': float(row.get('bed_temp_actual') or 0),
                    'targetBedTemp': float(row.get('bed_temp_target') or 0),
                    'currentMaterial': row.get('material') or "Unknown",
                    'jobFilename': clean_filename(row.get('filename')) if is_printing else None,
                    'jobProgressPercent': float(row.get('progress_percent') or 0) if is_printing else 0,
                    'jobTimeLeftSeconds': float(row.get('time_left_seconds') or 0) if is_printing else 0,
                    'jobKwhConsumed': (
                        (float(row['current_total_wh']) - float(row['start_energy_wh'])) / 1000.0
                    ) if is_printing and row.get('current_total_wh') is not None and row.get('start_energy_wh') is not None else 0.0,
                    "gcodePath": f"{row['gcode_preview_host']}/downloads/files/local/{row['filename']}" if row.get('filename') and row.get('gcode_preview_host') else None,
                    "gcode_preview_api_key": row.get('gcode_preview_api_key'),
                    "job_details": row.get('gcode_analysis_data') if isinstance(row.get('gcode_analysis_data'), dict) else {},
                    "detailed_analysis_data": {},
                    "history": [dict(job, filename=clean_filename(job.get('filename'))) for job in (row.get('history_data') or []) if isinstance(job, dict)]
                }

                energy_for_plant = device_output['jobKwhConsumed'] if is_printing else device_output['kwhLast24h']
                device_output['plantStage'] = get_plant_stage(energy_for_plant)

                device_output['tipText'] = evaluate_tips(device_output)
                final_dpp_data.append(device_output)

            except Exception as e_loop:
                device_id_for_error = row.get('device_id', 'Unknown Device')
                print(f"WARNING: Skipping device '{device_id_for_error}' due to processing error: {e_loop}", file=sys.stderr)
                continue

        final_dpp_data_sorted = sorted(final_dpp_data, key=lambda x: x.get('friendlyName', x.get('deviceId', '')))

        return {
            "printers": final_dpp_data_sorted,
            "globalHistory": global_history_list
        }

    except Exception as e_main:
        print(f"FATAL ERROR during get_live_dpp_data: {e_main}", file=sys.stderr)
        traceback.print_exc()
        return {"error": "Failed to fetch data from the database."}

    finally:
        if cur: cur.close()
        if conn: conn.close()

# Keep a simple main function for direct testing of the script if ever needed
def main():
    """
    This function is for command-line testing of the get_live_dpp_data function.
    It is not used by the Flask API.
    """
    print("--- Running in test mode ---", file=sys.stderr)
    data = get_live_dpp_data()
    print(json.dumps(data, indent=4)) # Pretty-print for readability

if __name__ == "__main__":
    main()

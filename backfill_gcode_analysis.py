#!/usr/bin/env python3
"""
Backfill gcode_analysis_data for existing DEMO jobs
"""
import psycopg2
import json

DB_HOST = 'localhost'
DB_PORT = 5434
DB_NAME = 'reg_ml_demo'
DB_USER = 'reg_ml_demo'
DB_PASSWORD = 'reg_ml_demo'

gcode_profiles = {
    'benchy': {'infill': 20, 'layers': 240, 'height': 0.2},
    'calibration_cube': {'infill': 15, 'layers': 100, 'height': 0.2},
    'demo_model': {'infill': 18, 'layers': 150, 'height': 0.2},
    'test_print': {'infill': 20, 'layers': 120, 'height': 0.2},
    'prototype_v2': {'infill': 25, 'layers': 180, 'height': 0.2},
    'functional_part': {'infill': 30, 'layers': 200, 'height': 0.15},
    'bracket_mount': {'infill': 35, 'layers': 140, 'height': 0.2},
    'enclosure_part': {'infill': 22, 'layers': 280, 'height': 0.15},
    'temperature_tower': {'infill': 15, 'layers': 320, 'height': 0.2},
}

printer_sizes = {
    'Ender3Pro': 0.6,
    'PrusaMK4': 1.0,
    'Voron24': 1.4,
    'Ultimaker': 0.8,
    'Prusa': 1.0,
    'Bambu': 1.1,
}

def get_size_multiplier(device_id):
    for key in printer_sizes:
        if key in device_id:
            return printer_sizes[key]
    return 1.0

try:
    conn = psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    cursor = conn.cursor()
    
    # Get all DEMO jobs without gcode_analysis_data
    cursor.execute("""
        SELECT job_id, device_id, filename, duration_seconds
        FROM print_jobs
        WHERE device_id LIKE 'DEMO%' 
        AND status = 'completed'
        AND gcode_analysis_data IS NULL
    """)
    
    jobs = cursor.fetchall()
    print(f"Found {len(jobs)} jobs to backfill")
    
    for job_id, device_id, filename, duration_seconds in jobs:
        filename_key = filename.replace('.gcode', '') if filename else 'test_print'
        profile = gcode_profiles.get(filename_key, {'infill': 20, 'layers': 200, 'height': 0.2})
        
        size_multiplier = get_size_multiplier(device_id)
        
        gcode_analysis = {
            'object_name': filename_key.replace('_', ' ').title() if filename_key else 'Test Print',
            'infill_density_percent': profile['infill'],
            'layer_height_mm': profile['height'],
            'total_layers': profile['layers'],
            'dimensions_x': int(60 * size_multiplier),
            'dimensions_y': int(70 * size_multiplier),
            'dimensions_z': int(40 * size_multiplier),
            'estimated_time_seconds': duration_seconds if duration_seconds else 1800
        }
        
        cursor.execute("""
            UPDATE print_jobs
            SET gcode_analysis_data = %s
            WHERE job_id = %s
        """, (json.dumps(gcode_analysis), job_id))
        
    conn.commit()
    print(f"✓ Successfully backfilled {len(jobs)} jobs")
    
except Exception as e:
    print(f"Error: {e}")
finally:
    if conn:
        conn.close()

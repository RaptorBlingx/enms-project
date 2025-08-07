#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# dpp_simulator.py
# External script to handle DPP data generation and simulation state.
import sys
import argparse
import requests
import json
import os
import sys
import time
import copy
import traceback
from datetime import datetime, timedelta, timezone
import psycopg2
import psycopg2.extras
import numpy as np
import re
# No dependency on Node-RED specific objects (node, flow, etc.)
from datetime import datetime, timedelta, timezone


# --- Configuration ---
# Path to store the persistent simulation state
STATE_FILE_PATH = os.path.join(os.path.dirname(__file__), 'simulation_state.json') # Store state file in same dir as script
ACTIVE_POWER_THRESHOLD = 5.0
DATA_FRESHNESS_THRESHOLD_MINUTES = 15

PLANT_TYPES = ["generic_plant", "corn", "sunflower", "tomato"]


# --- Database Credentials (Only needed for LIVE mode fallback) ---
# DB_NAME = "reg_ml"
# DB_USER = "reg_ml"
# DB_PASS = "raptorblingx" # Be cautious storing passwords in scripts
# DB_HOST = "postrges"
# DB_PORT = "5432"

# --- SimplyPrint API Credentials ---
# SIMPLYPRINT_API_KEY = "9993840f-c7f5-430f-b272-bebc45ed8ac8" # Your real key
# SIMPLYPRINT_COMPANY_ID = "37411"

# --- SimplyPrint API Credentials ---
# SIMPLYPRINT_API_KEY = "a012f5a8-4046-4fb5-98fe-a95d977fa3c5"
# SIMPLYPRINT_COMPANY_ID = "17378"

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


# --- MOCK DATA AND DYNAMIC SIMULATION LOGIC (NO CHANGES) ---
# ... (All the MOCK_SCENARIOS, DYNAMIC_SCENARIOS_PARAMS, TIP_RULES, update_simulation_state, etc. code remains here, unchanged)
# --- MOCK DATA DEFINITIONS (Static Scenarios) ---
MOCK_SCENARIOS = {
    "mk4_printing_pla": [
        {
            "deviceId": "PrusaMK4-1",
            "friendlyName": "Prusa MK4 1 (Sim: Printing)",
            "model": "PrusaMK4",
            "sizeCategory": "Standard",
            "currentStatus": "Printing",
            "currentMaterial": "PLA",
            "kwhLast24h": 1.234,
            "jobFilename": "big_benchy.gcode",
            "jobProgressPercent": 65,
            "jobTimeLeftSeconds": 3600,
            "jobKwhConsumed": 0.75,
            "currentNozzleTemp": 215,
            "targetNozzleTemp": 215,
            "currentBedTemp": 60,
            "targetBedTemp": 60,
            "job_details": {
                "infill_density_percent": 20,
                "layer_height_mm": 0.2,
                "supports_enabled": False,
                "nozzle_diameter_mm": 0.4,
                "object_name": "Benchy (Large)",
                "object_dimensions_mm": {"x": 120, "y": 62, "z": 96},
                "estimated_material_g": 55.8,
                "slicer_profile_name": "Prusament PLA Quality 0.2mm"
            },
            "plant_type": "generic_plant",
            "detailed_analysis_data": {
                "type": "current_job_focus",
                "energy_heating_kwh": 0.035,
                "energy_printing_kwh": 0.180, # Current printing energy for this job
                "projected_total_job_kwh": 0.260, # Projected based on 0.75 consumed at 65%
                "material_cost_eur": round((55.8 / 1000) * 25, 2), # 1.40
                "slicer_recap": {
                    "infill_percent": 20,
                    "layer_height_mm": 0.2,
                    "supports_used": "No",
                    "print_speed_avg_mm_s": 60
                },
                "efficiency_suggestion": "For a Benchy, 20% infill is standard. Consider 15% for non-display pieces to save material."
            }
        },
        {
            "deviceId": "PrusaMK4-2",
            "friendlyName": "Prusa MK4 2",
            "model": "PrusaMK4",
            "sizeCategory": "Standard",
            "currentStatus": "Idle",
            "currentMaterial": "ASA",
            "kwhLast24h": 0.075,
            "currentNozzleTemp": 28,
            "targetNozzleTemp": 0,
            "currentBedTemp": 25,
            "targetBedTemp": 0,
            "idle_time_since_last_job_minutes": 90,
            "plant_type": "generic_plant",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.6, 0.4, 0.9, 0.3, 0.7, 0.5, 0.075],
                "total_prints_last_7d": 12,
                "total_energy_last_7d_kwh": 3.55,
                "most_used_material_last_7d": "ASA",
                "common_tip_theme": "High temperature material usage noted. Ensure good ventilation.",
                "green_contribution_metric": "Maintained low idle power successfully."
            }
        },
        {
            "deviceId": "PrusaMK4-3",
            "friendlyName": "Prusa MK4 3",
            "model": "PrusaMK4",
            "sizeCategory": "Standard",
            "currentStatus": "Cooling",
            "currentMaterial": "PLA",
            "kwhLast24h": 0.550,
            "jobKwhConsumed": 0.280, # Energy for the job that just finished
            "currentNozzleTemp": 45,
            "targetNozzleTemp": 0,
            "currentBedTemp": 30,
            "targetBedTemp": 0,
            "plant_type": "generic_plant",
            "job_details": { # Job details of the *completed* print
                "infill_density_percent": 15,
                "layer_height_mm": 0.2,
                "supports_enabled": False,
                "nozzle_diameter_mm": 0.4,
                "object_name": "Calibration Cube",
                "object_dimensions_mm": {"x": 20, "y": 20, "z": 20},
                "estimated_material_g": 5.2,
                "slicer_profile_name": "Draft PLA 0.2mm"
            },
            "detailed_analysis_data": {
                "type": "current_job_focus",
                "energy_heating_kwh": 0.030,
                "energy_printing_kwh": 0.250,
                "projected_total_job_kwh": 0.280, # Actual, as it's completed
                "material_cost_eur": round((5.2 / 1000) * 25, 2), # 0.13
                "slicer_recap": {
                    "infill_percent": 15,
                    "layer_height_mm": 0.2,
                    "supports_used": "No",
                    "print_speed_avg_mm_s": 70
                },
                "efficiency_suggestion": "Job completed efficiently. Consider batching small prints."
            }
        },
        {
            "deviceId": "PrusaMini-1",
            "friendlyName": "Prusa Mini 1",
            "model": "PrusaMini",
            "sizeCategory": "Mini",
            "currentStatus": "Offline",
            "currentMaterial": "Unknown",
            "kwhLast24h": 0.005,
            "plant_type": "corn",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.1, 0.05, 0.0, 0.0, 0.0, 0.02, 0.005],
                "total_prints_last_7d": 2,
                "total_energy_last_7d_kwh": 0.18,
                "most_used_material_last_7d": "PLA",
                "common_tip_theme": "Printer frequently offline. Check connections if usage is planned.",
                "green_contribution_metric": "Minimal energy footprint due to low activity."
            }
        },
        {
            "deviceId": "PrusaMini-2",
            "friendlyName": "Prusa Mini 2",
            "model": "PrusaMini",
            "sizeCategory": "Mini",
            "currentStatus": "Idle",
            "currentMaterial": "PLA",
            "kwhLast24h": 0.020,
            "currentNozzleTemp": 30,
            "targetNozzleTemp": 0,
            "currentBedTemp": 28,
            "targetBedTemp": 0,
            "idle_time_since_last_job_minutes": 15,
            "plant_type": "corn",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.3, 0.25, 0.4, 0.35, 0.2, 0.3, 0.020],
                "total_prints_last_7d": 15,
                "total_energy_last_7d_kwh": 2.0,
                "most_used_material_last_7d": "PLA",
                "common_tip_theme": "Frequent small prints. Good uptime.",
                "green_contribution_metric": "High utilization for its size category."
            }
        },
        {
            "deviceId": "PrusaXL-1",
            "friendlyName": "Prusa XL 1",
            "model": "PrusaXL",
            "sizeCategory": "XL",
            "currentStatus": "Idle",
            "currentMaterial": "PETG",
            "kwhLast24h": 0.100,
            "currentNozzleTemp": 35,
            "targetNozzleTemp": 0,
            "currentBedTemp": 30,
            "targetBedTemp": 0,
            "idle_time_since_last_job_minutes": 300,
            "plant_type": "generic_plant",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [1.2, 1.5, 0.8, 1.1, 1.4, 0.9, 0.100],
                "total_prints_last_7d": 8, # Fewer, larger prints
                "total_energy_last_7d_kwh": 7.0,
                "most_used_material_last_7d": "PETG",
                "common_tip_theme": "Long idle periods noted. Power down if not in use for extended times.",
                "green_contribution_metric": "Utilized for large prototype productions."
            }
        }
    ],
    "xl_idle_high_energy": [
        {
            "deviceId": "PrusaXL-1",
            "friendlyName": "Prusa XL 1 (Sim: Idle High)",
            "model": "PrusaXL",
            "sizeCategory": "XL",
            "currentStatus": "Idle",
            "currentMaterial": "PETG",
            "kwhLast24h": 0.870,
            "currentNozzleTemp": 40,
            "targetNozzleTemp": 0,
            "currentBedTemp": 35,
            "targetBedTemp": 0,
            "idle_time_since_last_job_minutes": 180,
            "plant_type": "generic_plant",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.5, 0.6, 0.7, 0.9, 0.8, 0.75, 0.870],
                "total_prints_last_7d": 3,
                "total_energy_last_7d_kwh": 5.12,
                "most_used_material_last_7d": "PETG",
                "common_tip_theme": "High idle energy consumption is a persistent theme.",
                "green_contribution_metric": "Consider shorter standby times or manual power-off."
            }
        },
        {
            "deviceId": "PrusaMK4-1",
            "friendlyName": "Prusa MK4 1",
            "model": "PrusaMK4",
            "sizeCategory": "Standard",
            "currentStatus": "Idle",
            "currentMaterial": "PLA",
            "kwhLast24h": 0.050,
            "currentNozzleTemp": 28,
            "targetNozzleTemp": 0,
            "currentBedTemp": 25,
            "targetBedTemp": 0,
            "idle_time_since_last_job_minutes": 30,
            "plant_type": "generic_plant",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.4, 0.3, 0.5, 0.2, 0.6, 0.3, 0.050],
                "total_prints_last_7d": 10,
                "total_energy_last_7d_kwh": 2.35,
                "most_used_material_last_7d": "PLA",
                "common_tip_theme": "Consistent performer with good energy management.",
                "green_contribution_metric": "Efficiently prints educational models."
            }
        },
        {
            "deviceId": "PrusaMK4-2",
            "friendlyName": "Prusa MK4 2",
            "model": "PrusaMK4",
            "sizeCategory": "Standard",
            "currentStatus": "Idle",
            "currentMaterial": "ASA",
            "kwhLast24h": 0.040,
            "currentNozzleTemp": 30,
            "targetNozzleTemp": 0,
            "currentBedTemp": 26,
            "targetBedTemp": 0,
            "idle_time_since_last_job_minutes": 70,
            "plant_type": "generic_plant",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.2, 0.1, 0.3, 0.15, 0.25, 0.1, 0.040],
                "total_prints_last_7d": 7,
                "total_energy_last_7d_kwh": 1.14,
                "most_used_material_last_7d": "ASA",
                "common_tip_theme": "Low idle consumption. Good job!",
                "green_contribution_metric": "Specialized in durable ASA parts with minimal waste."
            }
        },
        {
            "deviceId": "PrusaMK4-3",
            "friendlyName": "Prusa MK4 3",
            "model": "PrusaMK4",
            "sizeCategory": "Standard",
            "currentStatus": "Offline",
            "currentMaterial": "PLA",
            "kwhLast24h": 0.010,
            "plant_type": "generic_plant",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.0, 0.0, 0.0, 0.0, 0.1, 0.05, 0.010],
                "total_prints_last_7d": 1,
                "total_energy_last_7d_kwh": 0.16,
                "most_used_material_last_7d": "PLA",
                "common_tip_theme": "Infrequently used. Verify if it's needed or can be decommissioned.",
                "green_contribution_metric": "Lowest energy user in the farm currently."
            }
        },
        {
            "deviceId": "PrusaMini-1",
            "friendlyName": "Prusa Mini 1",
            "model": "PrusaMini",
            "sizeCategory": "Mini",
            "currentStatus": "Offline",
            "currentMaterial": "Unknown",
            "kwhLast24h": 0.005,
            "plant_type": "corn",
            "detailed_analysis_data": { # Copied from other Mini offline
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.05, 0.02, 0.0, 0.0, 0.01, 0.03, 0.005],
                "total_prints_last_7d": 3,
                "total_energy_last_7d_kwh": 0.115,
                "most_used_material_last_7d": "PLA",
                "common_tip_theme": "Often offline. Check power or network if active use is intended.",
                "green_contribution_metric": "Currently in deep sleep, saving maximum energy."
            }
        },
        {
            "deviceId": "PrusaMini-2",
            "friendlyName": "Prusa Mini 2",
            "model": "PrusaMini",
            "sizeCategory": "Mini",
            "currentStatus": "Idle",
            "currentMaterial": "PLA",
            "kwhLast24h": 0.015,
            "currentNozzleTemp": 27,
            "targetNozzleTemp": 0,
            "currentBedTemp": 24,
            "targetBedTemp": 0,
            "idle_time_since_last_job_minutes": 20,
            "plant_type": "corn",
            "detailed_analysis_data": { # Copied from other Mini idle
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.2, 0.22, 0.18, 0.25, 0.15, 0.19, 0.015],
                "total_prints_last_7d": 22, # Active mini!
                "total_energy_last_7d_kwh": 1.205,
                "most_used_material_last_7d": "PLA",
                "common_tip_theme": "Highly active, focus on quick turnovers between prints.",
                "green_contribution_metric": "Workhorse for small parts, very efficient."
            }
        }
    ],
    "mini_offline": [
        {
            "deviceId": "PrusaMini-1",
            "friendlyName": "Prusa Mini 1 (Sim: Offline)",
            "model": "PrusaMini",
            "sizeCategory": "Mini",
            "currentStatus": "Offline",
            "currentMaterial": "Unknown",
            "kwhLast24h": 0.001,
            "plant_type": "corn",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.01, 0.0, 0.0, 0.02, 0.0, 0.0, 0.001],
                "total_prints_last_7d": 0,
                "total_energy_last_7d_kwh": 0.031,
                "most_used_material_last_7d": "N/A",
                "common_tip_theme": "Remains offline. Check power supply and network.",
                "green_contribution_metric": "Zero emission hero (when off)."
            }
        },
        {
            "deviceId": "PrusaMini-2",
            "friendlyName": "Prusa Mini 2 (Sim: Offline)",
            "model": "PrusaMini",
            "sizeCategory": "Mini",
            "currentStatus": "Offline",
            "currentMaterial": "PLA",
            "kwhLast24h": 0.002,
            "plant_type": "corn",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.03, 0.01, 0.0, 0.0, 0.02, 0.01, 0.002],
                "total_prints_last_7d": 1,
                "total_energy_last_7d_kwh": 0.072,
                "most_used_material_last_7d": "PLA",
                "common_tip_theme": "Offline status needs investigation for optimal use.",
                "green_contribution_metric": "Minimal environmental impact in current state."
            }
        },
        {
            "deviceId": "PrusaMK4-1",
            "friendlyName": "Prusa MK4 1",
            "model": "PrusaMK4",
            "sizeCategory": "Standard",
            "currentStatus": "Idle",
            "currentMaterial": "PLA",
            "kwhLast24h": 0.050,
            "currentNozzleTemp": 29,
            "targetNozzleTemp": 0,
            "currentBedTemp": 26,
            "targetBedTemp": 0,
            "idle_time_since_last_job_minutes": 60,
            "plant_type": "generic_plant",
            "detailed_analysis_data": { # Copied from other MK4 Idle
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.4, 0.3, 0.5, 0.2, 0.6, 0.3, 0.050],
                "total_prints_last_7d": 10,
                "total_energy_last_7d_kwh": 2.35,
                "most_used_material_last_7d": "PLA",
                "common_tip_theme": "Reliable PLA printer. Keep it busy!",
                "green_contribution_metric": "Printed 10 student projects last week."
            }
        },
        {
            "deviceId": "PrusaMK4-2",
            "friendlyName": "Prusa MK4 2",
            "model": "PrusaMK4",
            "sizeCategory": "Standard",
            "currentStatus": "Printing",
            "currentMaterial": "PETG",
            "kwhLast24h": 0.780,
            "jobFilename": "petg_vase.gcode",
            "jobProgressPercent": 30,
            "jobTimeLeftSeconds": 7200,
            "jobKwhConsumed": 0.25, # Energy for this job so far
            "currentNozzleTemp": 245,
            "targetNozzleTemp": 245,
            "currentBedTemp": 80,
            "targetBedTemp": 80,
            "job_details": {
                "infill_density_percent": 0,
                "layer_height_mm": 0.25,
                "supports_enabled": False,
                "nozzle_diameter_mm": 0.4,
                "object_name": "Spiral Vase",
                "object_dimensions_mm": {"x": 80, "y": 80, "z": 150},
                "estimated_material_g": 75.0,
                "slicer_profile_name": "PETG Vase Mode 0.25mm"
            },
            "plant_type": "generic_plant",
            "detailed_analysis_data": {
                "type": "current_job_focus",
                "energy_heating_kwh": 0.050,
                "energy_printing_kwh": 0.200, # Matches jobKwhConsumed - heating
                "projected_total_job_kwh": round(0.25 / 0.30, 2), # 0.83
                "material_cost_eur": round((75.0 / 1000) * 25, 2), # 1.88
                "slicer_recap": {
                    "infill_percent": 0,
                    "layer_height_mm": 0.25,
                    "supports_used": "No",
                    "print_speed_avg_mm_s": 45 # Vases often print slower
                },
                "efficiency_suggestion": "Vase mode is great for aesthetics. Ensure bed adhesion for tall prints."
            }
        },
        {
            "deviceId": "PrusaMK4-3",
            "friendlyName": "Prusa MK4 3",
            "model": "PrusaMK4",
            "sizeCategory": "Standard",
            "currentStatus": "Idle",
            "currentMaterial": "PLA",
            "kwhLast24h": 0.060,
            "currentNozzleTemp": 31,
            "targetNozzleTemp": 0,
            "currentBedTemp": 27,
            "targetBedTemp": 0,
            "idle_time_since_last_job_minutes": 10,
            "plant_type": "generic_plant",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.5, 0.45, 0.6, 0.35, 0.55, 0.4, 0.060],
                "total_prints_last_7d": 11,
                "total_energy_last_7d_kwh": 2.91,
                "most_used_material_last_7d": "PLA",
                "common_tip_theme": "Active printer, good job on maintaining low idle time.",
                "green_contribution_metric": "This printer is a community favorite for shared projects."
            }
        },
        {
            "deviceId": "PrusaXL-1",
            "friendlyName": "Prusa XL 1",
            "model": "PrusaXL",
            "sizeCategory": "XL",
            "currentStatus": "Idle",
            "currentMaterial": "ASA",
            "kwhLast24h": 0.120,
            "currentNozzleTemp": 38,
            "targetNozzleTemp": 0,
            "currentBedTemp": 32,
            "targetBedTemp": 0,
            "idle_time_since_last_job_minutes": 240,
            "plant_type": "generic_plant",
            "detailed_analysis_data": { # Copied from other XL Idle
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [1.0, 1.2, 0.7, 0.9, 1.1, 0.8, 0.120],
                "total_prints_last_7d": 6,
                "total_energy_last_7d_kwh": 5.82,
                "most_used_material_last_7d": "ASA",
                "common_tip_theme": "Focus on large batch prints to maximize XL efficiency.",
                "green_contribution_metric": "Printed large housing components for a research project."
            }
        }
    ],
    "mk4_heating_petg": [
        {
            "deviceId": "PrusaMK4-2",
            "friendlyName": "Prusa MK4 2 (Sim: Heating)",
            "model": "PrusaMK4",
            "sizeCategory": "Standard",
            "currentStatus": "Heating",
            "currentMaterial": "PETG",
            "kwhLast24h": 0.150, # Includes this heating cycle's start
            "jobFilename": "petg_functional_part.gcode",
            "currentNozzleTemp": 150,
            "targetNozzleTemp": 250,
            "currentBedTemp": 60,
            "targetBedTemp": 85,
            "plant_type": "generic_plant",
            "job_details": { # Assume these are known when job is initiated
                "infill_density_percent": 30,
                "layer_height_mm": 0.2,
                "supports_enabled": True,
                "nozzle_diameter_mm": 0.4,
                "object_name": "Functional Bracket",
                "object_dimensions_mm": {"x": 50, "y": 70, "z": 30},
                "estimated_material_g": 45.0,
                "slicer_profile_name": "PETG Standard 0.2mm"
            },
            "detailed_analysis_data": {
                "type": "current_job_focus",
                "energy_heating_kwh": 0.020, # Current heating energy for this job
                "energy_printing_kwh": 0.0, # Not printing yet
                "projected_total_job_kwh": 0.350, # Mock projection for the upcoming job
                "material_cost_eur": round((45.0 / 1000) * 25, 2), # 1.13
                "slicer_recap": {
                    "infill_percent": 30,
                    "layer_height_mm": 0.2,
                    "supports_used": "Yes",
                    "print_speed_avg_mm_s": 50
                },
                "efficiency_suggestion": "Heating for PETG. Ensure enclosure if available for better layer adhesion."
            }
        },
        {
            "deviceId": "PrusaMK4-1",
            "friendlyName": "Prusa MK4 1",
            "model": "PrusaMK4",
            "sizeCategory": "Standard",
            "currentStatus": "Idle",
            "currentMaterial": "PLA",
            "kwhLast24h": 0.030,
            "currentNozzleTemp": 28,
            "targetNozzleTemp": 0,
            "currentBedTemp": 25,
            "targetBedTemp": 0,
            "idle_time_since_last_job_minutes": 25,
            "plant_type": "generic_plant",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.2, 0.25, 0.15, 0.3, 0.22, 0.18, 0.030],
                "total_prints_last_7d": 9,
                "total_energy_last_7d_kwh": 1.33,
                "most_used_material_last_7d": "PLA",
                "common_tip_theme": "Good balance of activity and idle efficiency.",
                "green_contribution_metric": "Champion of quick PLA prototypes."
            }
        },
        {
            "deviceId": "PrusaMK4-3",
            "friendlyName": "Prusa MK4 3",
            "model": "PrusaMK4",
            "sizeCategory": "Standard",
            "currentStatus": "Offline",
            "currentMaterial": "Unknown",
            "kwhLast24h": 0.000,
            "plant_type": "generic_plant",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.000],
                "total_prints_last_7d": 0,
                "total_energy_last_7d_kwh": 0.0,
                "most_used_material_last_7d": "N/A",
                "common_tip_theme": "Consistently offline. Potential hardware issue or powered down.",
                "green_contribution_metric": "Effectively zero energy consumption."
            }
        },
        {
            "deviceId": "PrusaMini-1",
            "friendlyName": "Prusa Mini 1",
            "model": "PrusaMini",
            "sizeCategory": "Mini",
            "currentStatus": "Idle",
            "currentMaterial": "PLA",
            "kwhLast24h": 0.025,
            "currentNozzleTemp": 27,
            "targetNozzleTemp": 0,
            "currentBedTemp": 24,
            "targetBedTemp": 0,
            "idle_time_since_last_job_minutes": 12,
            "plant_type": "corn",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.15, 0.2, 0.18, 0.22, 0.16, 0.19, 0.025],
                "total_prints_last_7d": 18,
                "total_energy_last_7d_kwh": 1.125,
                "most_used_material_last_7d": "PLA",
                "common_tip_theme": "Keep this Mini printing! It's efficient.",
                "green_contribution_metric": "Prints small learning aids for local schools."
            }
        },
        {
            "deviceId": "PrusaMini-2",
            "friendlyName": "Prusa Mini 2",
            "model": "PrusaMini",
            "sizeCategory": "Mini",
            "currentStatus": "Idle",
            "currentMaterial": "PLA",
            "kwhLast24h": 0.022,
            "currentNozzleTemp": 29,
            "targetNozzleTemp": 0,
            "currentBedTemp": 25,
            "targetBedTemp": 0,
            "idle_time_since_last_job_minutes": 7,
            "plant_type": "corn",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.18, 0.15, 0.20, 0.17, 0.21, 0.16, 0.022],
                "total_prints_last_7d": 20,
                "total_energy_last_7d_kwh": 1.092,
                "most_used_material_last_7d": "PLA",
                "common_tip_theme": "Excellent uptime and energy per print.",
                "green_contribution_metric": "Fastest production of keychains for events."
            }
        },
        {
            "deviceId": "PrusaXL-1",
            "friendlyName": "Prusa XL 1",
            "model": "PrusaXL",
            "sizeCategory": "XL",
            "currentStatus": "Cooling",
            "currentMaterial": "ASA",
            "kwhLast24h": 1.500, # Includes the job it just finished
            "jobKwhConsumed": 1.200, # Energy for the job that just finished
            "currentNozzleTemp": 60,
            "targetNozzleTemp": 0,
            "currentBedTemp": 40,
            "targetBedTemp": 0,
            "plant_type": "generic_plant",
            "job_details": { # Job details of the *completed* print
                "infill_density_percent": 25,
                "layer_height_mm": 0.25,
                "supports_enabled": True,
                "nozzle_diameter_mm": 0.6, # Assume XL uses 0.6 nozzle
                "object_name": "Large Enclosure Part",
                "object_dimensions_mm": {"x": 200, "y": 150, "z": 100},
                "estimated_material_g": 350.0,
                "slicer_profile_name": "ASA Strong Parts 0.25mm"
            },
            "detailed_analysis_data": {
                "type": "current_job_focus",
                "energy_heating_kwh": 0.150,
                "energy_printing_kwh": 1.050,
                "projected_total_job_kwh": 1.200, # Actual
                "material_cost_eur": round((350.0 / 1000) * 25, 2), # 8.75
                "slicer_recap": {
                    "infill_percent": 25,
                    "layer_height_mm": 0.25,
                    "supports_used": "Yes",
                    "print_speed_avg_mm_s": 55
                },
                "efficiency_suggestion": "Large ASA print completed. Check for warping and remove supports carefully."
            }
        }
    ],
    "mk4_error": [
        {
            "deviceId": "PrusaMK4-3",
            "friendlyName": "Prusa MK4 3 (Sim: Error)",
            "model": "PrusaMK4",
            "sizeCategory": "Standard",
            "currentStatus": "Error",
            "currentMaterial": "PLA",
            "kwhLast24h": 0.020,
            "currentNozzleTemp": 35,
            "targetNozzleTemp": 0,
            "currentBedTemp": 30,
            "targetBedTemp": 0,
            "plant_type": "generic_plant",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.3, 0.2, 0.0, 0.0, 0.1, 0.05, 0.020], # Error might stop activity
                "total_prints_last_7d": 4,
                "total_energy_last_7d_kwh": 0.67,
                "most_used_material_last_7d": "PLA",
                "common_tip_theme": "Error state needs immediate attention to prevent further issues.",
                "green_contribution_metric": "Printer paused, preventing potential waste from failed prints."
            }
        },
        {
            "deviceId": "PrusaMK4-1",
            "friendlyName": "Prusa MK4 1",
            "model": "PrusaMK4",
            "sizeCategory": "Standard",
            "currentStatus": "Printing",
            "currentMaterial": "PETG",
            "kwhLast24h": 2.100, # High usage due to long print
            "jobFilename": "long_petg_print.gcode",
            "jobProgressPercent": 85,
            "jobTimeLeftSeconds": 1800,
            "jobKwhConsumed": 1.8, # Energy for this job so far
            "currentNozzleTemp": 250,
            "targetNozzleTemp": 250,
            "currentBedTemp": 85,
            "targetBedTemp": 85,
            "job_details": {
                "infill_density_percent": 40,
                "layer_height_mm": 0.2,
                "supports_enabled": True,
                "nozzle_diameter_mm": 0.4,
                "object_name": "Large Functional Part",
                "object_dimensions_mm": {"x": 150, "y": 100, "z": 75},
                "estimated_material_g": 220.5,
                "slicer_profile_name": "PETG Strong 0.2mm 40% Infill"
            },
            "plant_type": "generic_plant",
            "detailed_analysis_data": {
                "type": "current_job_focus",
                "energy_heating_kwh": 0.080,
                "energy_printing_kwh": 1.720, # jobKwhConsumed - heating
                "projected_total_job_kwh": round(1.8 / 0.85, 2), # 2.12
                "material_cost_eur": round((220.5 / 1000) * 25, 2), # 5.51
                "slicer_recap": {
                    "infill_percent": 40,
                    "layer_height_mm": 0.2,
                    "supports_used": "Yes",
                    "print_speed_avg_mm_s": 50
                },
                "efficiency_suggestion": "High infill for strength. Consider adaptive infill if applicable to save PETG."
            }
        },
        {
            "deviceId": "PrusaMK4-2",
            "friendlyName": "Prusa MK4 2",
            "model": "PrusaMK4",
            "sizeCategory": "Standard",
            "currentStatus": "Idle",
            "currentMaterial": "ASA",
            "kwhLast24h": 0.080,
            "currentNozzleTemp": 32,
            "targetNozzleTemp": 0,
            "currentBedTemp": 28,
            "targetBedTemp": 0,
            "idle_time_since_last_job_minutes": 45,
            "plant_type": "generic_plant",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.7, 0.5, 0.6, 0.4, 0.8, 0.55, 0.080],
                "total_prints_last_7d": 14,
                "total_energy_last_7d_kwh": 3.63,
                "most_used_material_last_7d": "ASA",
                "common_tip_theme": "Good job keeping this ASA printer active and efficient.",
                "green_contribution_metric": "Produces custom enclosures for electronics projects."
            }
        },
        {
            "deviceId": "PrusaMini-1",
            "friendlyName": "Prusa Mini 1",
            "model": "PrusaMini",
            "sizeCategory": "Mini",
            "currentStatus": "Idle",
            "currentMaterial": "PLA",
            "kwhLast24h": 0.015,
            "currentNozzleTemp": 28,
            "targetNozzleTemp": 0,
            "currentBedTemp": 25,
            "targetBedTemp": 0,
            "idle_time_since_last_job_minutes": 30,
            "plant_type": "corn",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.1, 0.12, 0.08, 0.15, 0.09, 0.11, 0.015],
                "total_prints_last_7d": 25, # Busy Mini
                "total_energy_last_7d_kwh": 0.665,
                "most_used_material_last_7d": "PLA",
                "common_tip_theme": "Excellent for rapid prototyping small PLA parts.",
                "green_contribution_metric": "Highest print count this week!"
            }
        },
        {
            "deviceId": "PrusaMini-2",
            "friendlyName": "Prusa Mini 2",
            "model": "PrusaMini",
            "sizeCategory": "Mini",
            "currentStatus": "Offline",
            "currentMaterial": "Unknown",
            "kwhLast24h": 0.003,
            "plant_type": "corn",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.02, 0.01, 0.0, 0.0, 0.01, 0.005, 0.003],
                "total_prints_last_7d": 2,
                "total_energy_last_7d_kwh": 0.048,
                "most_used_material_last_7d": "PLA",
                "common_tip_theme": "Currently offline. Plan maintenance if needed for upcoming jobs.",
                "green_contribution_metric": "Low power state contributing to overall farm efficiency."
            }
        },
        {
            "deviceId": "PrusaXL-1",
            "friendlyName": "Prusa XL 1",
            "model": "PrusaXL",
            "sizeCategory": "XL",
            "currentStatus": "Idle",
            "currentMaterial": "PLA",
            "kwhLast24h": 0.090,
            "currentNozzleTemp": 36,
            "targetNozzleTemp": 0,
            "currentBedTemp": 31,
            "targetBedTemp": 0,
            "idle_time_since_last_job_minutes": 210,
            "plant_type": "generic_plant",
            "detailed_analysis_data": {
                "type": "recent_performance_focus",
                "energy_trend_last_7d_kwh": [0.8, 0.9, 0.6, 1.0, 0.7, 0.5, 0.090],
                "total_prints_last_7d": 5,
                "total_energy_last_7d_kwh": 4.59,
                "most_used_material_last_7d": "PLA", # Switched to PLA for some XL jobs
                "common_tip_theme": "Consider if smaller printers could handle some PLA jobs to free up XL.",
                "green_contribution_metric": "Completed large architectural model print this month."
            }
        }
    ]
}
# The loop that adds default fields and tipText will process this MOCK_SCENARIOS data later.
# Add default fields to static mocks if they are missing
for scenario_data in MOCK_SCENARIOS.values():
    for device_data in scenario_data:
        device_data.setdefault("plantStage", get_plant_stage(device_data.get("kwhLast24h")))
        device_data.setdefault("currentNozzleTemp", None)
        device_data.setdefault("targetNozzleTemp", None)
        device_data.setdefault("currentBedTemp", None)
        device_data.setdefault("targetBedTemp", None)
        device_data.setdefault("jobFilename", None)
        device_data.setdefault("jobProgressPercent", 0)
        device_data.setdefault("jobTimeLeftSeconds", 0)
        device_data.setdefault("jobKwhConsumed", 0.0)
        device_data.setdefault("isPrintingNow", device_data.get("currentStatus") in ["Heating", "Printing", "Active (Other)"])


# --- DYNAMIC SIMULATION PARAMETERS ---
DYNAMIC_SCENARIOS_PARAMS = {
    "dynamic_mk4_printing_pla": {
        "simulated_device_id": "PrusaMK4-1",
        "initial_state": {
            "friendlyName": "Prusa MK4 1 (Dynamic Sim)", "model": "PrusaMK4", "sizeCategory": "Standard",
            "currentStatus": "Heating", "currentMaterial": "PLA", "kwhLast24h": 0.02, # Start with a little previous energy
            "plantStage": 1, # Initial plant stage
            "tipText": "Simulation initializing...", # Initial tip
            "currentNozzleTemp": 25, "targetNozzleTemp": 215, # Slightly lower PLA target
            "currentBedTemp": 25, "targetBedTemp": 60,
            "jobFilename": "dynamic_widget_v3.gcode", # New filename
            "jobProgressPercent": 0, "jobTimeLeftSeconds": None, "jobKwhConsumed": 0.0,
            "simulation_phase": "Heating",
            "job_estimated_total_time_seconds": 600, # Longer print (10 minutes)
            "job_estimated_filament_grams": 15.0, # Estimate filament needed
            "job_filament_used_grams": 0.0, # Track filament used
            "mock_power_heating": 230.0, # Slightly lower heating power
            "mock_power_printing": 75.0,  # Slightly lower printing power
            "heating_duration_seconds": 75, # Slightly longer heating
            "plant_type": "generic_plant" # <<< ADDED
        },
        "background_devices": [
            {"deviceId": "PrusaMK4-2", "friendlyName": "Prusa MK4 2", "model": "PrusaMK4", "sizeCategory": "Standard", "currentStatus": "Idle", "currentMaterial": "ASA", "kwhLast24h": 0.075, "tipText": "MK4-2 is idle.", "plant_type": "generic_plant"}, # <<< ADDED
            {"deviceId": "PrusaMK4-3", "friendlyName": "Prusa MK4 3", "model": "PrusaMK4", "sizeCategory": "Standard", "currentStatus": "Offline", "currentMaterial": "Unknown", "kwhLast24h": 0.010, "tipText": "MK4-3 is offline.", "plant_type": "generic_plant"}, # <<< ADDED
            {"deviceId": "PrusaMini-1", "friendlyName": "Prusa Mini 1", "model": "PrusaMini", "sizeCategory": "Mini", "currentStatus": "Offline", "currentMaterial": "Unknown", "kwhLast24h": 0.005, "tipText": "Mini-1 offline.", "plant_type": "corn"},      # <<< ADDED
            {"deviceId": "PrusaMini-2", "friendlyName": "Prusa Mini 2", "model": "PrusaMini", "sizeCategory": "Mini", "currentStatus": "Idle", "currentMaterial": "PLA", "kwhLast24h": 0.020, "tipText": "Mini-2 is idle.", "plant_type": "corn"}, # <<< ADDED
            {"deviceId": "PrusaXL-1", "friendlyName": "Prusa XL 1", "model": "PrusaXL", "sizeCategory": "XL", "currentStatus": "Idle", "currentMaterial": "PETG", "kwhLast24h": 0.100, "tipText": "XL is idle.", "plant_type": "generic_plant"} # <<< ADDED
        ]
    },
     "dynamic_xl_heating_petg": {
        "simulated_device_id": "PrusaXL-1",
        "initial_state": {
            "friendlyName": "Prusa XL 1 (Dynamic Sim)", "model": "PrusaXL", "sizeCategory": "XL",
            "currentStatus": "Heating", "currentMaterial": "PETG", "kwhLast24h": 0.1, "plantStage": get_plant_stage(0.1),
            "tipText": "XL heating up for PETG!", "currentNozzleTemp": 30, "targetNozzleTemp": 255,
            "currentBedTemp": 30, "targetBedTemp": 85, "jobFilename": "dynamic_large_part.gcode",
            "jobProgressPercent": 0, "jobTimeLeftSeconds": None, "jobKwhConsumed": 0.0,
            "simulation_phase": "Heating", "job_estimated_total_time_seconds": 1200,
            "mock_power_heating": 400.0, "mock_power_printing": 150.0, "heating_duration_seconds": 120,
            "plant_type": "generic_plant" # <<< ADDED
        },
         "background_devices": [
            {"deviceId": "PrusaMK4-1", "friendlyName": "Prusa MK4 1", "model": "PrusaMK4", "sizeCategory": "Standard", "currentStatus": "Idle", "currentMaterial": "PLA", "kwhLast24h": 0.050, "tipText": "MK4-1 idle.", "plant_type": "generic_plant"}, # <<< ADDED
            {"deviceId": "PrusaMK4-2", "friendlyName": "Prusa MK4 2", "model": "PrusaMK4", "sizeCategory": "Standard", "currentStatus": "Idle", "currentMaterial": "ASA", "kwhLast24h": 0.040, "tipText": "MK4-2 idle.", "plant_type": "generic_plant"}, # <<< ADDED
            {"deviceId": "PrusaMK4-3", "friendlyName": "Prusa MK4 3", "model": "PrusaMK4", "sizeCategory": "Standard", "currentStatus": "Idle", "currentMaterial": "PLA", "kwhLast24h": 0.060, "tipText": "MK4-3 idle.", "plant_type": "generic_plant"}, # <<< ADDED
            {"deviceId": "PrusaMini-1", "friendlyName": "Prusa Mini 1", "model": "PrusaMini", "sizeCategory": "Mini", "currentStatus": "Offline", "currentMaterial": "Unknown", "kwhLast24h": 0.005, "tipText": "Mini-1 offline.", "plant_type": "corn"}, # <<< ADDED
            {"deviceId": "PrusaMini-2", "friendlyName": "Prusa Mini 2", "model": "PrusaMini", "sizeCategory": "Mini", "currentStatus": "Idle", "currentMaterial": "PLA", "kwhLast24h": 0.015, "tipText": "Mini-2 idle.", "plant_type": "corn"} # <<< ADDED
        ]
    }
}
# Add default fields to dynamic scenario background devices
for scenario_params in DYNAMIC_SCENARIOS_PARAMS.values():
    for device_data in scenario_params.get("background_devices", []):
        device_data.setdefault("plantStage", get_plant_stage(device_data.get("kwhLast24h")))
        device_data.setdefault("currentNozzleTemp", None)
        device_data.setdefault("targetNozzleTemp", None)
        device_data.setdefault("currentBedTemp", None)
        device_data.setdefault("targetBedTemp", None)
        device_data.setdefault("jobFilename", None)
        device_data.setdefault("jobProgressPercent", 0)
        device_data.setdefault("jobTimeLeftSeconds", 0)
        device_data.setdefault("jobKwhConsumed", 0.0)
        device_data.setdefault("isPrintingNow", device_data.get("currentStatus") in ["Heating", "Printing", "Active (Other)"])


# --- SIMULATED SMART TIPS ---
# In dpp_simulator.py

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

# You do NOT need to change the evaluate_tips function itself.
# Its logic of picking the highest priority tip is exactly what we need.

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


# --- END OF ADVANCED SMART TIPS ENGINE ---
def update_simulation_state(current_state, elapsed_seconds):
    current_state.setdefault("job_estimated_filament_grams", 10.0) # Add default if missing
    current_state.setdefault("job_filament_used_grams", 0.0) # Add default if missing

    current_state.setdefault("simulation_phase", "Idle")
    current_state.setdefault("jobProgressPercent", 0.0); current_state.setdefault("jobTimeLeftSeconds", 0.0); current_state.setdefault("jobKwhConsumed", 0.0); current_state.setdefault("currentNozzleTemp", 25.0); current_state.setdefault("currentBedTemp", 25.0); current_state.setdefault("targetNozzleTemp", 0.0); current_state.setdefault("targetBedTemp", 0.0); current_state.setdefault("kwhLast24h", 0.0); current_state.setdefault("plantStage", 1); current_state.setdefault("job_estimated_total_time_seconds", 300); current_state.setdefault("heating_duration_seconds", 60); current_state.setdefault("mock_power_heating", 250.0); current_state.setdefault("mock_power_printing", 80.0)
    phase = current_state["simulation_phase"]
    # Basic logging to stderr for debugging via Node-RED exec node
    # print(f"Sim Phase: {phase}, Elapsed: {elapsed_seconds:.2f}s", file=sys.stderr)
    if phase == "Heating":
        heating_duration = current_state["heating_duration_seconds"]; nozzle_start = current_state.get("initialNozzleTemp", current_state["currentNozzleTemp"]); bed_start = current_state.get("initialBedTemp", current_state["currentBedTemp"]); nozzle_target = current_state["targetNozzleTemp"]; bed_target = current_state["targetBedTemp"]; mock_power = current_state["mock_power_heating"]
        time_in_heating = time.time() - current_state.get("start_time_unix_phase", current_state.get("start_time_unix", time.time())); heating_progress_ratio = min(time_in_heating / heating_duration, 1.0)
        current_state["currentNozzleTemp"] = nozzle_start + (nozzle_target - nozzle_start) * heating_progress_ratio; current_state["currentBedTemp"] = bed_start + (bed_target - bed_start) * heating_progress_ratio
        if heating_progress_ratio >= 1.0: current_state["currentNozzleTemp"] = nozzle_target; current_state["currentBedTemp"] = bed_target
        kwh_added = (mock_power * elapsed_seconds) / (3600 * 1000); current_state["jobKwhConsumed"] += kwh_added; current_state["kwhLast24h"] += kwh_added; current_state["plantStage"] = get_plant_stage(current_state["kwhLast24h"])
        temps_reached = current_state["currentNozzleTemp"] >= (nozzle_target * 0.99 if nozzle_target > 0 else 0) and current_state["currentBedTemp"] >= (bed_target * 0.99 if bed_target > 0 else 0)
        if heating_progress_ratio >= 1.0 and temps_reached: current_state["simulation_phase"] = "Printing"; current_state["start_time_unix_phase"] = time.time(); current_state["currentStatus"] = "Printing"; current_state["jobProgressPercent"] = 0; current_state["jobTimeLeftSeconds"] = current_state["job_estimated_total_time_seconds"]
    elif phase == "Printing":
        total_time = current_state["job_estimated_total_time_seconds"]; mock_power = current_state["mock_power_printing"]
        time_in_printing = time.time() - current_state.get("start_time_unix_phase", current_state.get("start_time_unix", time.time())); new_progress_percent = min((time_in_printing / total_time) * 100.0, 100.0); current_state["jobProgressPercent"] = new_progress_percent
        time_left = max(0, total_time - time_in_printing); current_state["jobTimeLeftSeconds"] = time_left
            # --- ADD FILAMENT CALCULATION ---
        total_filament = current_state.get("job_estimated_filament_grams", 10.0) # Use default if missing
        filament_used = (new_progress_percent / 100.0) * total_filament
        current_state["job_filament_used_grams"] = filament_used
        # --- END FILAMENT CALCULATION ---

        kwh_added = (mock_power * elapsed_seconds) / (3600 * 1000); current_state["jobKwhConsumed"] += kwh_added; current_state["kwhLast24h"] += kwh_added; current_state["plantStage"] = get_plant_stage(current_state["kwhLast24h"])
        if new_progress_percent >= 100.0: current_state["jobProgressPercent"] = 100; current_state["jobTimeLeftSeconds"] = 0; current_state["simulation_phase"] = "Cooling"; current_state["start_time_unix_phase"] = time.time(); current_state["currentStatus"] = "Cooling"
    elif phase == "Cooling":
        cooling_duration = 60; nozzle_start = current_state.get("initialNozzleTemp", current_state["currentNozzleTemp"]); bed_start = current_state.get("initialBedTemp", current_state["currentBedTemp"]); room_temp = 25.0; mock_power = 10.0
        time_in_cooling = time.time() - current_state.get("start_time_unix_phase", current_state.get("start_time_unix", time.time())); cooling_progress_ratio = min(time_in_cooling / cooling_duration, 1.0)
        current_state["currentNozzleTemp"] = nozzle_start - (nozzle_start - room_temp) * cooling_progress_ratio; current_state["currentBedTemp"] = bed_start - (bed_start - room_temp) * cooling_progress_ratio
        current_state["targetNozzleTemp"] = 0.0; current_state["targetBedTemp"] = 0.0; current_state["currentNozzleTemp"] = max(current_state["currentNozzleTemp"], room_temp); current_state["currentBedTemp"] = max(current_state["currentBedTemp"], room_temp)
        kwh_added = (mock_power * elapsed_seconds) / (3600 * 1000); current_state["kwhLast24h"] += kwh_added; current_state["plantStage"] = get_plant_stage(current_state["kwhLast24h"])
        if cooling_progress_ratio >= 1.0: current_state["currentNozzleTemp"] = room_temp; current_state["currentBedTemp"] = room_temp; current_state["simulation_phase"] = "Completed"; current_state["currentStatus"] = "Completed"
    elif phase == "Completed":
        current_state["simulation_phase"] = "Idle"; current_state["currentStatus"] = "Idle"; current_state["jobFilename"] = "--"; current_state["jobProgressPercent"] = 0; current_state["jobTimeLeftSeconds"] = 0; current_state["jobKwhConsumed"] = 0.0; current_state["currentNozzleTemp"] = 25; current_state["currentBedTemp"] = 25; current_state["targetNozzleTemp"] = 0; current_state["targetBedTemp"] = 0
    elif phase == "Idle":
        mock_power = 5.0; kwh_added = (mock_power * elapsed_seconds) / (3600 * 1000); current_state["kwhLast24h"] += kwh_added; current_state["plantStage"] = get_plant_stage(current_state["kwhLast24h"])
        current_state["currentNozzleTemp"] = 25; current_state["currentBedTemp"] = 25; current_state["targetNozzleTemp"] = 0; current_state["targetBedTemp"] = 0; current_state["jobFilename"] = "--"; current_state["jobProgressPercent"] = 0; current_state["jobTimeLeftSeconds"] = 0; current_state["jobKwhConsumed"] = 0.0

    current_state["tipText"] = evaluate_tips(current_state)
    current_state["last_update_time"] = time.time()
    # DEBUG print statement added as per request
    print(f"DEBUG DYNAMIC SIM: kwhLast24h={current_state['kwhLast24h']:.4f}, plantStage={current_state['plantStage']}", file=sys.stderr)
    return current_state

# --- State Loading/Saving ---
def load_simulation_state():
    if os.path.exists(STATE_FILE_PATH):
        try:
            with open(STATE_FILE_PATH, 'r') as f:
                state = json.load(f)
                if isinstance(state, dict): return state
                else: print(f"Warning: State file content is not a dictionary. Resetting state.", file=sys.stderr); return None
        except json.JSONDecodeError: print(f"Warning: State file '{STATE_FILE_PATH}' contains invalid JSON. Resetting state.", file=sys.stderr); return None
        except Exception as e: print(f"Error loading state file '{STATE_FILE_PATH}': {e}", file=sys.stderr); return None
    return None

def save_simulation_state(state):
    try:
        os.makedirs(os.path.dirname(STATE_FILE_PATH), exist_ok=True)
        with open(STATE_FILE_PATH, 'w') as f: json.dump(state, f, indent=4)
    except Exception as e: print(f"Error saving state file '{STATE_FILE_PATH}': {e}", file=sys.stderr)

def clear_simulation_state():
     if os.path.exists(STATE_FILE_PATH):
         try: os.remove(STATE_FILE_PATH)
         except Exception as e: print(f"Error removing state file '{STATE_FILE_PATH}': {e}", file=sys.stderr)

# --- Main Execution ---
# --- Main Execution ---
# --- Main Execution ---
# ====================================================================
# REPLACE THE OLD main() FUNCTION AND if __name__ BLOCK WITH THIS ENTIRE BLOCK
# ====================================================================

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
        pj.thumbnail_url
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
                "thumbnailUrl": row['thumbnail_url']
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

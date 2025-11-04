#!/usr/bin/env python3
"""
DPP Data Enricher - Creates sophisticated, realistic mock data for DPP cards
Generates complete job details, energy calculations, print history
"""

import random
import json
from datetime import datetime, timedelta
import psycopg2
import psycopg2.extras

class DPPDataEnricher:
    """Enriches printer data with realistic job details and calculations"""
    
    # Realistic gcode patterns
    GCODE_PROFILES = {
        'benchy': {'infill': 20, 'layers': 240, 'height': 0.2, 'time_est': 1800},
        'calibration_cube': {'infill': 15, 'layers': 100, 'height': 0.2, 'time_est': 600},
        'functional_part': {'infill': 30, 'layers': 180, 'height': 0.2, 'time_est': 2400},
        'prototype': {'infill': 25, 'layers': 300, 'height': 0.15, 'time_est': 3600},
        'bracket': {'infill': 40, 'layers': 120, 'height': 0.2, 'time_est': 1200},
        'enclosure': {'infill': 20, 'layers': 400, 'height': 0.2, 'time_est': 4800},
        'temperature_tower': {'infill': 10, 'layers': 200, 'height': 0.2, 'time_est': 1500},
        'vase_mode': {'infill': 0, 'layers': 250, 'height': 0.2, 'time_est': 900},
    }
    
    # Printer power profiles (watts)
    POWER_PROFILES = {
        'Mini': {'idle': 5, 'printing': 75, 'heating': 90},
        'Standard': {'idle': 8, 'printing': 140, 'heating': 180},
        'Large': {'idle': 12, 'printing': 240, 'heating': 300}
    }
    
    def __init__(self):
        self.last_jobs_cache = {}
    
    def get_printer_category(self, device_id):
        """Determine printer size category"""
        if 'Mini' in device_id:
            return 'Mini'
        elif 'XL' in device_id or 'Voron' in device_id:
            return 'Large'
        else:
            return 'Standard'
    
    def get_gcode_profile(self, filename):
        """Extract gcode profile from filename"""
        if not filename:
            return None
        
        filename_lower = filename.lower()
        for key in self.GCODE_PROFILES:
            if key in filename_lower:
                profile = self.GCODE_PROFILES[key].copy()
                # Add some randomness
                profile['infill'] += random.randint(-5, 5)
                profile['infill'] = max(0, min(100, profile['infill']))
                profile['layers'] += random.randint(-20, 20)
                profile['time_est'] = int(profile['time_est'] * random.uniform(0.9, 1.2))
                return profile
        
        # Default profile for unknown patterns
        return {
            'infill': random.randint(15, 30),
            'layers': random.randint(100, 300),
            'height': 0.2,
            'time_est': random.randint(1200, 3600)
        }
    
    def calculate_dimensions(self, printer_category, filename):
        """Generate realistic object dimensions based on printer size"""
        if printer_category == 'Mini':
            base_size = random.randint(30, 120)
        elif printer_category == 'Large':
            base_size = random.randint(100, 280)
        else:
            base_size = random.randint(50, 200)
        
        # Generate proportional dimensions
        x = base_size
        y = int(base_size * random.uniform(0.7, 1.3))
        z = int(base_size * random.uniform(0.3, 0.8))
        
        return {'x': x, 'y': y, 'z': z}
    
    def calculate_energy_for_job(self, printer_category, duration_seconds, progress_percent=100):
        """Calculate energy consumption based on printer type and duration"""
        power_profile = self.POWER_PROFILES[printer_category]
        
        # Average power during print (watts)
        avg_power = power_profile['printing']
        
        # Energy = Power * Time (in hours)
        hours = (duration_seconds / 3600.0) * (progress_percent / 100.0)
        energy_wh = avg_power * hours
        energy_kwh = energy_wh / 1000.0
        
        return {
            'energy_wh': round(energy_wh, 1),
            'energy_kwh': round(energy_kwh, 4),
            'avg_power': avg_power
        }
    
    def calculate_filament_usage(self, printer_category, duration_seconds, infill_percent):
        """Calculate filament usage based on print parameters"""
        # Base filament rate (grams per hour)
        if printer_category == 'Mini':
            base_rate = 8
        elif printer_category == 'Large':
            base_rate = 25
        else:
            base_rate = 15
        
        # Adjust for infill
        infill_multiplier = 0.5 + (infill_percent / 100.0) * 0.5
        
        hours = duration_seconds / 3600.0
        filament_g = base_rate * hours * infill_multiplier
        
        return round(filament_g, 2)
    
    def enrich_current_job(self, printer_data, device_id):
        """Add complete current job details"""
        status = printer_data.get('currentStatus')
        progress = printer_data.get('jobProgressPercent', 0)
        filename = printer_data.get('jobFilename')
        
        if status not in ['Printing', 'Heating'] or not filename:
            return printer_data
        
        printer_category = self.get_printer_category(device_id)
        gcode_profile = self.get_gcode_profile(filename)
        
        if not gcode_profile:
            return printer_data
        
        # Calculate estimated time
        total_time = gcode_profile['time_est']
        elapsed_time = int(total_time * (progress / 100.0))
        time_left = total_time - elapsed_time
        
        # Calculate dimensions
        dimensions = self.calculate_dimensions(printer_category, filename)
        
        # Calculate current energy
        energy = self.calculate_energy_for_job(printer_category, elapsed_time, progress)
        
        # Calculate filament used so far
        filament_used = self.calculate_filament_usage(
            printer_category, 
            elapsed_time, 
            gcode_profile['infill']
        )
        
        # Add enriched data
        printer_data['job_details'] = {
            'filename': filename,
            'infill_percent': gcode_profile['infill'],
            'layer_height_mm': gcode_profile['height'],
            'total_layers': gcode_profile['layers'],
            'current_layer': int(gcode_profile['layers'] * (progress / 100.0)),
            'dimensions_x': dimensions['x'],
            'dimensions_y': dimensions['y'],
            'dimensions_z': dimensions['z'],
            'time_left_seconds': time_left,
            'time_left_minutes': int(time_left / 60),
            'elapsed_seconds': elapsed_time,
            'elapsed_minutes': int(elapsed_time / 60)
        }
        
        printer_data['jobKwhConsumed'] = energy['energy_kwh']
        printer_data['jobTimeLeftSeconds'] = time_left
        printer_data['printTimeSeconds'] = elapsed_time
        
        return printer_data
    
    def enrich_last_job(self, printer_data, device_id, conn):
        """Keep last job info static - already populated from DB query"""
        # Last job info is already populated from the main SQL query in dpp_simulator
        # We don't override it here to keep it static during active prints
        # It only updates when a new job completes and gets inserted into print_jobs table
        return printer_data
    
    def get_recent_history(self, device_id, conn, limit=5):
        """Get recent job history for a printer"""
        try:
            cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
            
            cursor.execute("""
                SELECT filename, kwh_consumed, end_time
                FROM print_jobs
                WHERE device_id = %s AND status = 'completed'
                ORDER BY end_time DESC
                LIMIT %s
            """, (device_id, limit))
            
            jobs = cursor.fetchall()
            cursor.close()
            
            history = []
            for job in jobs:
                history.append({
                    'filename': job['filename'],
                    'kwh': float(job['kwh_consumed']) if job['kwh_consumed'] else 0,
                    'completed_at': job['end_time'].isoformat() if job['end_time'] else None
                })
            
            return history
            
        except Exception as e:
            print(f"Error getting recent history: {e}")
            return []


# Global enricher instance
enricher = DPPDataEnricher()

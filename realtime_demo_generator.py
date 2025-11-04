#!/usr/bin/env python3
"""
Real-time mock data generator for DEMO devices in enms-demo environment
Continuously updates printer statuses, energy data, and simulates printing activity
"""

import psycopg2
from datetime import datetime, timedelta
import random
import time
import sys
import signal

# Database connection
DB_HOST = "localhost"
DB_PORT = 5434
DB_NAME = "reg_ml_demo"
DB_USER = "reg_ml_demo"
DB_PASS = "raptorblingx_demo"

# Update interval (seconds) - FAST for demo presentation
UPDATE_INTERVAL = 5  # Update every 5 seconds for immediate responsiveness

# ALL devices - Updated to include all 32 printers (excluding environment sensor)
DEMO_DEVICES = [
    'anycubic_kobra2_1', 'anycubic_kobra_max_1', 'anycubic_vyper_1',
    'artillery_genius_pro_1', 'artillery_sidewinder_x2_1', 'artillery_sidewinder_x4_plus_1',
    'bambu_p1p_1', 'bambu_p1s_1', 'bambu_x1_carbon_1',
    'creality_cr10_smart_pro_1', 'creality_ender3_v2_1', 'creality_ender5_s1_1', 'creality_k1_max_1',
    'elegoo_neptune3_pro_1', 'elegoo_neptune4_pro_1',
    'flashforge_adventurer_5m_1', 'flsun_qqs_pro_1',
    'kingroon_kp3s_pro_1',
    'prusa_mini_plus_1', 'prusa_mini_plus_2', 'prusa_mk3s_plus_1', 'prusa_mk4_1', 'prusa_mk4_2', 'prusa_mk4_3',
    'prusa_xl_1', 'prusa_xl_2',
    'qidi_xmax3_1',
    'sovol_sv06_plus_1', 'sovol_sv07_1',
    'voron_24_1', 'voron_switchwire_1', 'voron_trident_1'
]

MATERIALS = ['PLA', 'PETG', 'ABS', 'TPU', 'ASA']
FILENAMES = [
    'test_print.gcode', 'calibration_cube.gcode', 'benchy.gcode', 
    'temperature_tower.gcode', 'functional_part.gcode', 'prototype_v2.gcode',
    'demo_model.gcode', 'bracket_mount.gcode', 'enclosure_part.gcode'
]

# Device states (persistent across updates)
device_states = {}

class DeviceState:
    def __init__(self, device_id):
        self.device_id = device_id
        self.state_text = random.choice(['Idle', 'Offline'])
        self.material = random.choice(MATERIALS)
        self.filename = None
        self.progress_percent = 0
        self.print_start_time = None
        self.is_mini = 'Mini' in device_id
        self.is_large = 'XL' in device_id or 'Voron' in device_id
        self.cumulative_energy_wh = 0
    
    @property
    def printer_category(self):
        """Get printer category based on device type"""
        if self.is_mini:
            return 'Mini'
        elif self.is_large:
            return 'Large'
        else:
            return 'Standard'
        
    def get_power_range(self):
        """Get power consumption range based on device type"""
        if self.is_mini:
            return (40, 80)
        elif self.is_large:
            return (120, 250)
        else:
            return (80, 150)
    
    def update_state(self):
        """Update device state with realistic transitions"""
        
        # State transition logic
        if self.state_text == 'Printing':
            # Increment progress at 70% speed for more realistic demo
            # Was: 0.5-2.5, Now: 0.35-1.75 (70% of original)
            self.progress_percent = min(100, self.progress_percent + random.uniform(0.35, 1.75))
            
            # Finish print when complete - returns True to signal job completion
            if self.progress_percent >= 99.5:
                self.state_text = 'Cooling'
                self.progress_percent = 100
                print(f"  {self.device_id}: Print completed, cooling down")
                return True  # Signal job completion
                
        elif self.state_text == 'Heating':
            # Move to printing after heating
            if random.random() < 0.4:  # 40% chance to start printing
                self.state_text = 'Printing'
                self.progress_percent = 0
                self.print_start_time = datetime.now()
                print(f"  {self.device_id}: Started printing {self.filename}")
                
        elif self.state_text == 'Cooling':
            # Cool down then go idle
            if random.random() < 0.3:  # 30% chance to finish cooling
                self.state_text = 'Idle'
                self.filename = None
                print(f"  {self.device_id}: Cooling complete, now idle")
                
        elif self.state_text == 'Idle':
            # Random chance to start new print
            if random.random() < 0.05:  # 5% chance per interval
                self.state_text = 'Heating'
                self.material = random.choice(MATERIALS)
                self.filename = random.choice(FILENAMES)
                self.print_start_time = datetime.now()  # Track start time
                print(f"  {self.device_id}: Starting new print - {self.filename} ({self.material})")
                
        elif self.state_text == 'Offline':
            # Come online occasionally
            if random.random() < 0.03:  # 3% chance per interval
                self.state_text = 'Idle'
                print(f"  {self.device_id}: Came online")
        
        # Random offline events (rare)
        if self.state_text != 'Offline' and random.random() < 0.01:  # 1% chance
            self.state_text = 'Offline'
            self.filename = None
            print(f"  {self.device_id}: Went offline")
        
        return False  # No job completion by default
    
    def get_temperatures(self):
        """Get realistic temperatures based on state"""
        if self.state_text in ['Printing', 'Heating']:
            nozzle_temp = round(random.uniform(180, 230), 1)
            bed_temp = round(random.uniform(50, 80), 1)
        elif self.state_text == 'Cooling':
            nozzle_temp = round(random.uniform(40, 100), 1)
            bed_temp = round(random.uniform(30, 50), 1)
        else:
            nozzle_temp = None
            bed_temp = None
        return nozzle_temp, bed_temp
    
    def get_power(self):
        """Get power consumption based on state"""
        power_range = self.get_power_range()
        
        if self.state_text == 'Printing':
            power = random.uniform(power_range[0], power_range[1])
        elif self.state_text == 'Heating':
            power = random.uniform(power_range[1] * 0.8, power_range[1])
        elif self.state_text == 'Idle':
            power = random.uniform(5, 15)
        else:  # Offline/Cooling
            power = random.uniform(0, 5)
        
        return round(power, 2)

def initialize_device_states():
    """Initialize all device states with DIVERSE initial conditions for demo"""
    print("Initializing devices with diverse states for immediate demo impact:")
    
    # Distribute devices across different states for visual variety
    states_distribution = [
        'Printing',    # 40% printing at various stages
        'Printing',
        'Printing',
        'Printing',
        'Printing',
        'Printing',
        'Heating',     # 15% heating up
        'Heating',
        'Cooling',     # 10% cooling down
        'Idle',        # 25% idle
        'Idle',
        'Idle',
        'Idle',
        'Offline',     # 10% offline
        'Printing',
        'Printing'
    ]
    
    for i, device_id in enumerate(DEMO_DEVICES):
        state = DeviceState(device_id)
        
        # Assign initial state
        initial_state = states_distribution[i % len(states_distribution)]
        state.state_text = initial_state
        state.material = random.choice(MATERIALS)
        
        # Configure based on state
        if initial_state == 'Printing':
            # Random progress between 5% and 95%
            state.progress_percent = random.uniform(5, 95)
            state.filename = random.choice(FILENAMES)
            state.print_start_time = datetime.now() - timedelta(minutes=random.randint(10, 180))
            print(f"  ✓ {device_id}: Printing {state.filename} at {state.progress_percent:.1f}%")
            
        elif initial_state == 'Heating':
            state.filename = random.choice(FILENAMES)
            state.progress_percent = 0
            print(f"  ✓ {device_id}: Heating for {state.filename}")
            
        elif initial_state == 'Cooling':
            state.progress_percent = 100
            state.filename = random.choice(FILENAMES)
            print(f"  ✓ {device_id}: Cooling after print")
            
        elif initial_state == 'Idle':
            print(f"  ✓ {device_id}: Idle")
        else:
            print(f"  ✓ {device_id}: Offline")
        
        device_states[device_id] = state
    
    print(f"\nInitialized {len(DEMO_DEVICES)} devices with diverse states")
    
    # Set some devices to active states for demo
    for i in range(3):
        device = random.choice(DEMO_DEVICES)
        device_states[device].state_text = 'Printing'
        device_states[device].progress_percent = random.uniform(20, 80)
        device_states[device].filename = random.choice(FILENAMES)
        device_states[device].material = random.choice(MATERIALS)
        print(f"Initial: {device} set to Printing at {device_states[device].progress_percent:.1f}%")

def update_all_devices(conn):
    """Update all device statuses and energy data"""
    cursor = conn.cursor()
    timestamp = datetime.now()
    
    status_records = []
    energy_records = []
    completed_jobs = []  # Track completed jobs for insertion
    
    for device_id in DEMO_DEVICES:
        state = device_states[device_id]
        job_completed = state.update_state()  # Returns True if job finished
        
        # Handle job completion - insert to print_jobs table
        if job_completed and state.filename and state.print_start_time:
            duration_seconds = int((timestamp - state.print_start_time).total_seconds())
            
            # Calculate total energy for completed job
            avg_power = state.get_power_range()[1] * 0.7  # Use 70% of max power
            job_energy_kwh = (avg_power * duration_seconds / 3600) / 1000
            
            # Calculate filament used (rough estimate)
            if state.is_mini:
                filament_rate = 10  # g/hour
            elif state.is_large:
                filament_rate = 25
            else:
                filament_rate = 15
            filament_used = (filament_rate * duration_seconds / 3600)
            
            completed_jobs.append({
                'device_id': device_id,
                'filename': state.filename,
                'duration_seconds': duration_seconds,
                'kwh_consumed': round(job_energy_kwh, 4),
                'filament_used_g': round(filament_used, 1),
                'end_time': timestamp
            })
            
            print(f"  ✅ {device_id}: Completed {state.filename} - {duration_seconds}s, {job_energy_kwh:.4f} kWh")
        
        # Get current values
        nozzle_temp, bed_temp = state.get_temperatures()
        power = state.get_power()
        
        # Calculate energy (Wh for this interval)
        interval_hours = UPDATE_INTERVAL / 3600
        energy_wh = power * interval_hours
        state.cumulative_energy_wh += energy_wh
        
        # Prepare status record
        is_printing = state.state_text == 'Printing'
        is_operational = state.state_text not in ['Offline', 'Error']
        
        status_records.append((
            device_id,
            timestamp,
            state.state_text,
            state.material,
            nozzle_temp,
            bed_temp,
            state.progress_percent if is_printing else 0,
            is_operational,
            is_printing,
            False,  # is_paused
            False,  # is_error
            state.filename  # filename
        ))
        
        # Calculate voltage, current, and daily energy
        # Typical 3D printer: 230V (Europe) or 120V (US), we'll use ~230V with variation
        voltage = round(random.uniform(220, 240), 2)
        current_amps = round(power / voltage, 3) if voltage > 0 else 0
        
        # Calculate energy today (kWh) - reset daily, accumulate through the day
        # For demo, we'll use cumulative energy converted to kWh
        energy_today_kwh = round(state.cumulative_energy_wh / 1000, 4)
        
        energy_records.append((
            device_id,
            timestamp,
            power,
            round(energy_wh, 2),
            voltage,
            current_amps,
            energy_today_kwh
        ))
    
    # Batch insert
    try:
        cursor.executemany("""
            INSERT INTO printer_status (device_id, timestamp, state_text, material,
                                       nozzle_temp_actual, bed_temp_actual, progress_percent,
                                       is_operational, is_printing, is_paused, is_error, filename)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT DO NOTHING
        """, status_records)
        
        cursor.executemany("""
            INSERT INTO energy_data (device_id, timestamp, power_watts, energy_total_wh, voltage, current_amps, energy_today_kwh)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT DO NOTHING
        """, energy_records)
        
        # Insert completed jobs into print_jobs table with PDF reports
        for job in completed_jobs:
            # Generate a demo PDF URL (in real system, PDF would be generated asynchronously)
            job_id_hash = abs(hash(f"{job['device_id']}_{job['filename']}_{job['end_time']}")) % 10000
            pdf_url = f"/dpp_reports/dpp_job_demo_{job_id_hash}.pdf"
            
            # Get enriched job details for PDF generation
            import json
            device_state = device_states[job['device_id']]
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
            profile = gcode_profiles.get(job['filename'].replace('.gcode', ''), {'infill': 20, 'layers': 200, 'height': 0.2})
            
            # Generate analysis data based on printer size
            printer_sizes = {'Mini': 0.6, 'Standard': 1.0, 'Large': 1.4}
            size_multiplier = printer_sizes.get(device_state.printer_category, 1.0)
            
            gcode_analysis = {
                'object_name': job['filename'].replace('.gcode', '').replace('_', ' ').title(),
                'infill_density_percent': profile['infill'],
                'layer_height_mm': profile['height'],
                'total_layers': profile['layers'],
                'dimensions_x': int(60 * size_multiplier),
                'dimensions_y': int(70 * size_multiplier),
                'dimensions_z': int(40 * size_multiplier),
                'estimated_time_seconds': job['duration_seconds']
            }
            
            cursor.execute("""
                INSERT INTO print_jobs (
                    device_id, filename, status, kwh_consumed, filament_used_g,
                    duration_seconds, end_time, start_time, gcode_analysis_data
                )
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                RETURNING job_id
            """, (
                job['device_id'],
                job['filename'],
                'completed',
                job['kwh_consumed'],
                job['filament_used_g'],
                job['duration_seconds'],
                job['end_time'],
                job['end_time'] - timedelta(seconds=job['duration_seconds']),
                json.dumps(gcode_analysis)
            ))
            
            # Get the job_id of the inserted job
            inserted_job_id = cursor.fetchone()[0]
            print(f"  ✓ Created job {inserted_job_id} - PDF will be auto-generated by trigger")
        
        conn.commit()
        
        # Print summary
        printing_count = sum(1 for s in device_states.values() if s.state_text == 'Printing')
        idle_count = sum(1 for s in device_states.values() if s.state_text == 'Idle')
        offline_count = sum(1 for s in device_states.values() if s.state_text == 'Offline')
        
        print(f"[{timestamp.strftime('%H:%M:%S')}] Updated: {printing_count} printing, {idle_count} idle, {offline_count} offline")
        
    except Exception as e:
        print(f"Error updating devices: {e}")
        conn.rollback()

def main():
    print("=" * 70)
    print("DEMO Real-Time Data Generator")
    print("=" * 70)
    print(f"Database: {DB_NAME}@localhost:{DB_PORT}")
    print(f"Update interval: {UPDATE_INTERVAL} seconds")
    print(f"Devices: {len(DEMO_DEVICES)}")
    print("=" * 70)
    
    # Setup signal handler for graceful shutdown
    def signal_handler(sig, frame):
        print("\n\nShutdown signal received, exiting gracefully...")
        sys.exit(0)
    
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)
    
    try:
        # Connect to database
        print("Connecting to database...")
        conn = psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASS
        )
        print("✓ Connected!\n")
        
        # Initialize device states
        print("Initializing device states...")
        initialize_device_states()
        print()
        
        # Main loop
        iteration = 0
        while True:
            iteration += 1
            print(f"\n--- Iteration {iteration} ---")
            update_all_devices(conn)
            time.sleep(UPDATE_INTERVAL)
            
    except KeyboardInterrupt:
        print("\n\nStopped by user")
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        return 1
    finally:
        if 'conn' in locals():
            conn.close()
            print("Database connection closed")
    
    return 0

if __name__ == "__main__":
    sys.exit(main())

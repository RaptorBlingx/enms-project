#!/usr/bin/env python3
"""
Real-time IoT sensor data generator for Industrial Hybrid Edge System
Updates sensor readings every 30 seconds, synchronized with printer activity
"""

import psycopg2
from datetime import datetime, timedelta
import random
import math
import time
import sys
import signal

DB_CONFIG = {
    'host': 'localhost',
    'port': 5434,
    'database': 'reg_ml_demo',
    'user': 'reg_ml_demo',
    'password': 'raptorblingx_demo'
}

UPDATE_INTERVAL = 30  # seconds

ESP32_SENSOR = 'ESP32_SensorHub_Raptor'
SMARTPLUG_ID = 'SmartPlug_3DPrinter_01'
PRUSA_TEST = 'PRUSA_MK3_Test_TR'

# State tracking
cumulative_energy_kwh = 0
current_printing_state = False
hotend_temp = 25.0
ambient_temp = 22.0

def check_printer_activity(conn):
    """Check if any printers are currently printing (excluding environment sensor)"""
    cursor = conn.cursor()
    cursor.execute("""
        SELECT COUNT(*) 
        FROM printer_status 
        WHERE device_id != 'environment'
          AND is_printing = true
          AND timestamp > NOW() - INTERVAL '2 minutes'
    """)
    printing_count = cursor.fetchone()[0]
    return printing_count > 0

def update_iot_sensors(conn):
    """Update all IoT sensor readings"""
    global cumulative_energy_kwh, current_printing_state, hotend_temp, ambient_temp
    
    cursor = conn.cursor()
    timestamp = datetime.now()
    
    # Check if printers are active
    is_printing = check_printer_activity(conn)
    
    # Smooth temperature transitions
    if is_printing and not current_printing_state:
        print(f"  🔥 Printer started - heating up...")
    elif not is_printing and current_printing_state:
        print(f"  ❄️  Printer stopped - cooling down...")
    
    current_printing_state = is_printing
    
    # Hotend temperature (MAX6675) - gradual heating/cooling
    if is_printing:
        target_temp = random.uniform(205, 225)
        hotend_temp += (target_temp - hotend_temp) * 0.3  # Gradual approach
    else:
        target_temp = random.uniform(22, 30)
        hotend_temp += (target_temp - hotend_temp) * 0.1  # Slower cooling
    
    hotend_temp = max(20, min(230, hotend_temp))  # Clamp
    
    # Ambient temperature (DHT22) - rises when printing
    if is_printing:
        ambient_target = 24.0 + random.uniform(-0.5, 1.5)
    else:
        ambient_target = 22.0 + random.uniform(-1, 1)
    
    ambient_temp += (ambient_target - ambient_temp) * 0.2
    humidity = 45 + random.uniform(-5, 5)
    
    # Smart Plug power consumption
    if is_printing:
        base_power = random.uniform(80, 150)
    else:
        base_power = random.uniform(3, 15)
    
    power_w = base_power + random.uniform(-5, 5)
    voltage_v = random.uniform(220, 240)
    current_a = power_w / voltage_v
    power_factor = random.uniform(0.85, 0.98)
    
    # Cumulative energy
    interval_hours = UPDATE_INTERVAL / 3600
    energy_kwh = power_w * interval_hours / 1000
    cumulative_energy_kwh += energy_kwh
    
    # Insert Smart Plug data
    cursor.execute("""
        INSERT INTO smartplug_data (timestamp, device_id, power_w, voltage_v, 
                                    current_a, power_factor, energy_total_kwh)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    """, (timestamp, SMARTPLUG_ID, power_w, voltage_v, current_a, 
          power_factor, cumulative_energy_kwh))
    
    # Insert MAX6675 temperature
    cursor.execute("""
        INSERT INTO max6675_temperature_data (timestamp, device_id, printer_id, temperature_c)
        VALUES (%s, %s, %s, %s)
    """, (timestamp, ESP32_SENSOR, PRUSA_TEST, hotend_temp))
    
    # MPU6050 Accelerometer & Gyroscope (vibration when printing)
    if is_printing:
        accel_x = random.uniform(-2, 2) + random.uniform(-0.5, 0.5)
        accel_y = random.uniform(-2, 2) + random.uniform(-0.5, 0.5)
        accel_z = 9.8 + random.uniform(-0.3, 0.3)
        gyro_x = random.uniform(-50, 50)
        gyro_y = random.uniform(-50, 50)
        gyro_z = random.uniform(-30, 30)
    else:
        accel_x = random.uniform(-0.2, 0.2)
        accel_y = random.uniform(-0.2, 0.2)
        accel_z = 9.8 + random.uniform(-0.1, 0.1)
        gyro_x = random.uniform(-5, 5)
        gyro_y = random.uniform(-5, 5)
        gyro_z = random.uniform(-5, 5)
    
    cursor.execute("""
        INSERT INTO mpu6050_accelerometer_data (timestamp, device_id, printer_id,
                                                accel_x, accel_y, accel_z)
        VALUES (%s, %s, %s, %s, %s, %s)
    """, (timestamp, ESP32_SENSOR, PRUSA_TEST, accel_x, accel_y, accel_z))
    
    cursor.execute("""
        INSERT INTO mpu6050_gyroscope_data (timestamp, device_id, printer_id,
                                            gyro_x, gyro_y, gyro_z)
        VALUES (%s, %s, %s, %s, %s, %s)
    """, (timestamp, ESP32_SENSOR, PRUSA_TEST, gyro_x, gyro_y, gyro_z))
    
    # DHT22 Temperature & Humidity
    cursor.execute("""
        INSERT INTO dht22_data (timestamp, device_id, temperature_c, humidity_pct)
        VALUES (%s, %s, %s, %s)
    """, (timestamp, ESP32_SENSOR, ambient_temp, humidity))
    
    # Temperature readings (generic)
    cursor.execute("""
        INSERT INTO temperature_readings (timestamp, temperature, device_state)
        VALUES (%s, %s, %s)
    """, (timestamp, ambient_temp + random.uniform(-0.5, 0.5),
          'printing' if is_printing else 'idle'))
    
    # Power predictions (ML model)
    predicted_power = power_w * random.uniform(0.92, 1.08)
    difference = predicted_power - power_w
    apparent_power = power_w / power_factor
    reactive_power = math.sqrt(max(0, apparent_power**2 - power_w**2))
    
    cursor.execute("""
        INSERT INTO power_predictions (timestamp, actual_power, predicted_power, difference,
                                       apparent_power, reactive_power, power_factor,
                                       voltage, current, model_file)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """, (timestamp, power_w, predicted_power, difference,
          apparent_power, reactive_power, power_factor, voltage_v, current_a,
          'linear_regression_v1'))
    
    # Update weather (every 10 minutes)
    if int(timestamp.minute) % 10 == 0 and timestamp.second < 35:
        update_weather(conn, timestamp)
    
    conn.commit()
    
    return {
        'hotend_temp': hotend_temp,
        'ambient_temp': ambient_temp,
        'power_w': power_w,
        'is_printing': is_printing
    }

def update_weather(conn, timestamp):
    """Update weather forecast data"""
    cursor = conn.cursor()
    location = 'Hamburg'
    
    # Generate next 24 hours of forecast
    for hour_offset in range(24):
        forecast_time = timestamp + timedelta(hours=hour_offset)
        
        base_temp = 15 + 5 * math.sin((timestamp.hour + hour_offset) * math.pi / 12)
        temperature = base_temp + random.uniform(-2, 2)
        humidity = 60 + random.uniform(-10, 10)
        pressure = 1013 + random.uniform(-5, 5)
        wind_speed = random.uniform(2, 12)
        wind_direction = random.uniform(0, 360)
        
        rain_chance = random.random()
        rain_3h = random.uniform(0, 4) if rain_chance < 0.15 else 0
        snow_3h = random.uniform(0, 1.5) if rain_chance < 0.03 and temperature < 2 else 0
        
        weather = 'Rain' if rain_3h > 0 else ('Snow' if snow_3h > 0 else 'Clear')
        description = 'light rain' if rain_3h > 0 else ('light snow' if snow_3h > 0 else 'clear sky')
        
        cursor.execute("""
            INSERT INTO weather_forecast (timestamp, location, forecast_time, weather, description,
                                         temperature, humidity, pressure, wind_speed, wind_direction,
                                         rain_3h, snow_3h)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (timestamp, location, forecast_time) DO UPDATE SET
                weather = EXCLUDED.weather,
                temperature = EXCLUDED.temperature,
                humidity = EXCLUDED.humidity
        """, (timestamp, location, forecast_time, weather, description,
              temperature, humidity, pressure, wind_speed, wind_direction,
              rain_3h, snow_3h))
    
    # Update current weather reading
    cursor.execute("""
        INSERT INTO weather_readings (timestamp, location, temperature, humidity, pressure)
        VALUES (%s, %s, %s, %s, %s)
        ON CONFLICT (timestamp, location) DO UPDATE SET
            temperature = EXCLUDED.temperature
    """, (timestamp, location, temperature, humidity, pressure))

def main():
    print("=" * 70)
    print("IoT Sensor Real-Time Data Generator")
    print("=" * 70)
    print(f"Database: {DB_CONFIG['database']}@localhost:{DB_CONFIG['port']}")
    print(f"Update interval: {UPDATE_INTERVAL} seconds")
    print("=" * 70)
    
    def signal_handler(sig, frame):
        print("\n\nShutdown signal received, exiting...")
        sys.exit(0)
    
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)
    
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        print("✓ Connected to database\n")
        
        iteration = 0
        while True:
            iteration += 1
            print(f"\n--- Iteration {iteration} [{datetime.now().strftime('%H:%M:%S')}] ---")
            
            stats = update_iot_sensors(conn)
            
            print(f"  Hotend: {stats['hotend_temp']:.1f}°C")
            print(f"  Ambient: {stats['ambient_temp']:.1f}°C")
            print(f"  Power: {stats['power_w']:.1f}W")
            print(f"  Status: {'🖨️  Printing' if stats['is_printing'] else '💤 Idle'}")
            
            time.sleep(UPDATE_INTERVAL)
            
    except KeyboardInterrupt:
        print("\n\nStopped by user")
    except Exception as e:
        print(f"\n❌ Error: {e}")
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

import pandas as pd
import psycopg2
import sys
import os

# --- Database Connection Details 
DB_NAME = os.environ.get("POSTGRES_DB")
DB_USER = os.environ.get("POSTGRES_USER")
DB_PASS = os.environ.get("POSTGRES_PASSWORD")
DB_HOST = os.environ.get("POSTGRES_HOST")
DB_PORT = os.environ.get("POSTGRES_PORT")


# --- Output File ---
OUTPUT_CSV_FILE = 'printer_energy_data_raw.csv'

print("Connecting to database...")
try:
    conn = psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASS,
        host=DB_HOST,
        port=DB_PORT
    )
    print("Connection successful.")
except Exception as e:
    print(f"Error connecting to database: {e}")
    sys.exit(1)

# --- SQL Query to Join Energy and Status Data (MODIFIED) ---
# Fetches all energy data points and finds the latest status
# at or before each energy timestamp for the SAME device.
# MODIFIED: Added ps.material and ps.ambient_temp_c
sql_query = """
SELECT
    ed.timestamp,
    ed.device_id,
    ed.power_watts,
    ed.energy_total_wh,
    ed.voltage,
    ed.current_amps,
    ed.plug_temp_c,
    ps.state_text,
    ps.is_operational,
    ps.is_printing,
    ps.is_paused,
    ps.is_error,
    ps.is_busy,
    ps.is_sd_ready,
    ps.nozzle_temp_actual,
    ps.nozzle_temp_target,
    ps.bed_temp_actual,
    ps.bed_temp_target,
    ps.z_height_mm,
    ps.speed_multiplier_percent,
    ps.material,              -- <<< ADDED
    ps.ambient_temp_c          -- <<< ADDED
FROM energy_data ed
LEFT JOIN LATERAL (
    SELECT
        state_text, is_operational, is_printing, is_paused, is_error,
        is_busy, is_sd_ready, nozzle_temp_actual, nozzle_temp_target,
        bed_temp_actual, bed_temp_target, z_height_mm, speed_multiplier_percent,
        material, ambient_temp_c -- Match columns here
    FROM printer_status
    WHERE
        device_id = ed.device_id AND timestamp <= ed.timestamp
    ORDER BY timestamp DESC
    LIMIT 1
) ps ON true
ORDER BY ed.device_id, ed.timestamp;
"""

print("Executing SQL query to fetch and join data...")
try:
    # Use pandas to read directly into a DataFrame
    df = pd.read_sql_query(sql_query, conn)
    print(f"Query successful. Fetched {len(df)} rows.")
except Exception as e:
    print(f"Error executing query: {e}")
    conn.close()
    sys.exit(1)
finally:
    # Ensure connection is closed
    if conn:
        conn.close()
        print("Database connection closed.")

# --- Save to CSV ---
if not df.empty:
    print(f"Saving data to {OUTPUT_CSV_FILE}...")
    try:
        df.to_csv(OUTPUT_CSV_FILE, index=False)
        print("Data saved successfully.")
    except Exception as e:
        print(f"Error saving data to CSV: {e}")
else:
    print("No data fetched, CSV file not created.")

print("Script finished.")

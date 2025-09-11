# home/ubuntu/enms-project/python-api/app.py

import os
import traceback
import psycopg2
from flask import Flask, jsonify, request
from flask_cors import CORS

# Import our existing function for the summary
from dpp_simulator import get_live_dpp_data
# Import our new, dedicated function for PDF generation
from pdf_service import generate_pdf_for_job

app = Flask(__name__)
# Initialize CORS to allow cross-origin requests from the frontend
CORS(app)


# --- Existing DPP Endpoints (with syntax corrections) ---

@app.route('/api/dpp_summary', methods=['GET'])
def dpp_summary():
    """
    Provides a real-time summary of all printers for the DPP frontend.
    """
    try:
        data = get_live_dpp_data()
        if "error" in data:
            return jsonify(data), 500
        return jsonify(data)
    except Exception as e:
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500


@app.route('/api/generate_dpp_pdf', methods=['POST'])
def generate_dpp_pdf_endpoint():
    """
    Web endpoint to trigger PDF generation for a specific job.
    """
    data = request.get_json()
    job_id = data.get('job_id')

    if not job_id:
        return jsonify({"error": "job_id is required"}), 400

    try:
        # Call the function from our other file to do the work
        result = generate_pdf_for_job(job_id)
        return jsonify(result), 200
    except Exception as e:
        # If anything goes wrong in our service, handle the error gracefully
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500

# --- NEW: Database Connection Function (Docker-aware) ---
def get_db_connection():
    """Establishes a connection to the PostgreSQL database using environment variables."""
    try:
        conn = psycopg2.connect(
            dbname=os.environ.get('POSTGRES_DB'),
            user=os.environ.get('POSTGRES_USER'),
            password=os.environ.get('POSTGRES_PASSWORD'),
            host=os.environ.get('POSTGRES_HOST'), # This will be 'postgres' from docker-compose
            port=os.environ.get('POSTGRES_PORT')
        )
        return conn
    except psycopg2.OperationalError as e:
        print(f"Error connecting to database: {e}")
        return None

# --- NEW: DEVICE MANAGEMENT API ENDPOINTS ---

# GET /api/devices/ (Fetch all devices for the main table)
@app.route('/api/devices/', methods=['GET'])
def get_devices():
    conn = get_db_connection()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500
    
    try:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT device_id, device_model, friendly_name, location, notes, 
                       shelly_id, api_ip, simplyprint_id, sp_company_id,
                       printer_size_category, bed_width, bed_depth 
                FROM public.devices ORDER BY friendly_name ASC
            """)
            columns = [desc[0] for desc in cur.description]
            devices = [dict(zip(columns, row)) for row in cur.fetchall()]
        return jsonify(devices)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if conn:
            conn.close()

# GET /api/devices/<device_id> (Fetch a single device for the edit form)
@app.route('/api/devices/<string:device_id>', methods=['GET'])
def get_device(device_id):
    conn = get_db_connection()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500
        
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM public.devices WHERE device_id = %s", (device_id,))
            columns = [desc[0] for desc in cur.description]
            device_data = cur.fetchone()
            if device_data is None:
                return jsonify({"error": "Device not found"}), 404
            device = dict(zip(columns, device_data))
        return jsonify(device)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if conn:
            conn.close()

# POST /api/devices/ (Create a new device)
@app.route('/api/devices/', methods=['POST'])
def add_device():
    new_device = request.get_json()
    if not new_device or not new_device.get('device_id') or not new_device.get('device_model'):
        return jsonify({"error": "device_id and device_model are required"}), 400
    
    conn = get_db_connection()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500

    columns = [key for key in new_device.keys() if new_device[key] not in [None, '']]
    values = [new_device[key] for key in columns]
    
    if not columns:
        return jsonify({"error": "No data provided to insert"}), 400
        
    sql = f"INSERT INTO public.devices ({', '.join(columns)}) VALUES ({', '.join(['%s'] * len(values))}) RETURNING device_id;"
    
    try:
        with conn.cursor() as cur:
            cur.execute(sql, values)
            device_id = cur.fetchone()[0]
            conn.commit()
        return jsonify({"status": "success", "device_id": device_id}), 201
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        if conn:
            conn.close()

# PUT /api/devices/<device_id> (Update an existing device)
@app.route('/api/devices/<string:device_id>', methods=['PUT'])
def update_device(device_id):
    updates = request.get_json()
    if not updates:
        return jsonify({"error": "No update data provided"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500

    set_clause = ", ".join([f"{key} = %s" for key in updates.keys()])
    values = list(updates.values())
    values.append(device_id)

    sql = f"UPDATE public.devices SET {set_clause} WHERE device_id = %s;"
    
    try:
        with conn.cursor() as cur:
            cur.execute(sql, values)
            conn.commit()
        return jsonify({"status": "success", "updated_id": device_id})
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        if conn:
            conn.close()

# DELETE /api/devices/<device_id> (Delete a device)
@app.route('/api/devices/<string:device_id>', methods=['DELETE'])
def delete_device(device_id):
    conn = get_db_connection()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500

    sql = "DELETE FROM public.devices WHERE device_id = %s;"
    try:
        with conn.cursor() as cur:
            cur.execute(sql, (device_id,))
            conn.commit()
        return jsonify({"status": "success", "deleted_id": device_id})
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        if conn:
            conn.close()

# --- Main execution block ---
if __name__ == '__main__':
    # For production, debug should be False. Gunicorn or another WSGI server will be used.
    app.run(host='0.0.0.0', port=5000, debug=False)

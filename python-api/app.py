# home/ubuntu/enms-project/python-api/app.py

import os
import traceback
import psycopg2
from flask import Flask, jsonify, request
from flask_cors import CORS

# These imports might not exist, but let's keep them from your original file
# If they are the cause of the error, the app won't even start.
try:
    from dpp_simulator import get_live_dpp_data
    from pdf_service import generate_pdf_for_job
    print("--- DEBUG: Successfully imported dpp_simulator and pdf_service. ---")
except ImportError:
    print("--- DEBUG: Could not import dpp_simulator or pdf_service. Ignoring for now. ---")
    get_live_dpp_data = lambda: {"error": "DPP simulator not available"}
    generate_pdf_for_job = lambda job_id: {"error": "PDF service not available"}

# Import auth service
try:
    from auth_service import register_user, login_user, logout_user, verify_token
    print("--- DEBUG: Successfully imported auth_service. ---")
except ImportError as e:
    print(f"--- DEBUG: Could not import auth_service: {e} ---")
    register_user = None
    login_user = None
    logout_user = None
    verify_token = None


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
        # Call the real function from our other file
        result = generate_pdf_for_job(job_id)
        if "error" in result:
             return jsonify(result), 500
        return jsonify(result), 200
    except Exception as e:
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500

# --- AUTH ENDPOINTS ---

@app.route('/api/auth/register', methods=['POST'])
def api_register():
    """User registration endpoint"""
    if not register_user:
        return jsonify({"success": False, "error": "Auth service not available"}), 503
    
    try:
        data = request.get_json()
        required_fields = ['email', 'password', 'organization', 'full_name', 'position', 'country']
        
        for field in required_fields:
            if not data.get(field):
                return jsonify({"success": False, "error": f"Missing required field: {field}"}), 400
        
        result = register_user(
            email=data['email'],
            password=data['password'],
            organization=data['organization'],
            full_name=data['full_name'],
            position=data['position'],
            mobile=data.get('mobile', ''),
            country=data['country']
        )
        
        status_code = 201 if result.get('success') else 400
        return jsonify(result), status_code
        
    except Exception as e:
        traceback.print_exc()
        return jsonify({"success": False, "error": str(e)}), 500

@app.route('/api/auth/login', methods=['POST'])
def api_login():
    """User login endpoint"""
    if not login_user:
        return jsonify({"success": False, "error": "Auth service not available"}), 503
    
    try:
        data = request.get_json()
        
        if not data.get('email') or not data.get('password'):
            return jsonify({"success": False, "error": "Email and password are required"}), 400
        
        ip_address = request.remote_addr
        user_agent = request.headers.get('User-Agent', '')
        
        result = login_user(
            email=data['email'],
            password=data['password'],
            ip_address=ip_address,
            user_agent=user_agent
        )
        
        status_code = 200 if result.get('success') else 401
        return jsonify(result), status_code
        
    except Exception as e:
        traceback.print_exc()
        return jsonify({"success": False, "error": str(e)}), 500

@app.route('/api/auth/logout', methods=['POST'])
def api_logout():
    """User logout endpoint"""
    if not logout_user:
        return jsonify({"success": False, "error": "Auth service not available"}), 503
    
    try:
        auth_header = request.headers.get('Authorization', '')
        if not auth_header.startswith('Bearer '):
            return jsonify({"success": False, "error": "Invalid authorization header"}), 401
        
        token = auth_header.split(' ')[1]
        result = logout_user(token)
        
        return jsonify(result), 200
        
    except Exception as e:
        traceback.print_exc()
        return jsonify({"success": False, "error": str(e)}), 500

@app.route('/api/auth/verify', methods=['GET'])
def api_verify_token():
    """Verify authentication token"""
    if not verify_token:
        return jsonify({"valid": False, "error": "Auth service not available"}), 503
    
    try:
        auth_header = request.headers.get('Authorization', '')
        if not auth_header.startswith('Bearer '):
            return jsonify({"valid": False, "error": "Invalid authorization header"}), 401
        
        token = auth_header.split(' ')[1]
        result = verify_token(token)
        
        status_code = 200 if result.get('valid') else 401
        return jsonify(result), status_code
        
    except Exception as e:
        traceback.print_exc()
        return jsonify({"valid": False, "error": str(e)}), 500

@app.route('/api/auth/check-session', methods=['GET'])
def api_check_session():
    """Check if session is valid (alias for verify)"""
    if not verify_token:
        return jsonify({"valid": False, "error": "Auth service not available"}), 503
    
    try:
        auth_header = request.headers.get('Authorization', '')
        if not auth_header.startswith('Bearer '):
            return jsonify({"valid": False}), 200
        
        token = auth_header.split(' ')[1]
        result = verify_token(token)
        
        # If valid, extract user info from payload
        if result.get('valid') and result.get('payload'):
            payload = result['payload']
            return jsonify({
                "valid": True,
                "user": {
                    "id": payload.get('user_id'),
                    "email": payload.get('email'),
                    "role": payload.get('role'),
                    "full_name": payload.get('full_name', payload.get('email', '').split('@')[0])
                }
            }), 200
        else:
            return jsonify({"valid": False, "error": result.get('error', 'Invalid token')}), 200
        
    except Exception as e:
        traceback.print_exc()
        return jsonify({"valid": False, "error": str(e)}), 200

@app.route('/api/auth/me', methods=['GET'])
def api_get_current_user():
    """Get current user information"""
    if not verify_token:
        return jsonify({"success": False, "error": "Auth service not available"}), 503
    
    try:
        auth_header = request.headers.get('Authorization', '')
        if not auth_header.startswith('Bearer '):
            return jsonify({"success": False, "error": "Invalid authorization header"}), 401
        
        token = auth_header.split(' ')[1]
        result = verify_token(token)
        
        if result.get('valid'):
            # Return user info from the token verification
            return jsonify({
                "success": True,
                "user": result.get('user', {})
            }), 200
        else:
            return jsonify({"success": False, "error": "Invalid token"}), 401
        
    except Exception as e:
        traceback.print_exc()
        return jsonify({"success": False, "error": str(e)}), 500

# --- NEW: Database Connection Function (Docker-aware) with DEBUG LOGGING ---
def get_db_connection():
    """Establishes a connection to the PostgreSQL database using environment variables."""
    print("--- DEBUG: Attempting to connect to database... ---")
    print(f"--- DEBUG: Host: {os.environ.get('POSTGRES_HOST')}, Port: {os.environ.get('POSTGRES_PORT')}, DB: {os.environ.get('POSTGRES_DB')}, User: {os.environ.get('POSTGRES_USER')}")
    try:
        conn = psycopg2.connect(
            dbname=os.environ.get('POSTGRES_DB'),
            user=os.environ.get('POSTGRES_USER'),
            password=os.environ.get('POSTGRES_PASSWORD'),
            host=os.environ.get('POSTGRES_HOST'), # This will be 'postgres' from docker-compose
            port=os.environ.get('POSTGRES_PORT')
        )
        print("--- DEBUG: Database connection SUCCESSFUL. ---")
        return conn
    except Exception as e:
        # This will now catch ANY exception during connection, not just OperationalError
        print("--- DEBUG: DATABASE CONNECTION FAILED! ---")
        traceback.print_exc() # Print the full exception traceback to the logs
        return None

# --- NEW: DEVICE MANAGEMENT API ENDPOINTS ---

# GET /api/devices/ (Fetch all devices for the main table) - WITH DEBUG LOGGING
@app.route('/api/devices/', methods=['GET'])
def get_devices():
    print("\n--- DEBUG: ENTERED get_devices() endpoint. ---")
    conn = get_db_connection()

    if not conn:
        print("--- DEBUG: get_db_connection() returned None. Exiting with 500. ---")
        return jsonify({"error": "Database connection failed as reported by get_db_connection"}), 500

    try:
        print("--- DEBUG: Connection object exists, proceeding to create cursor. ---")
        with conn.cursor() as cur:
            print("--- DEBUG: Cursor created. Executing SQL query... ---")
            cur.execute("""
                SELECT device_id, device_model, friendly_name, location, notes,
                       shelly_id, api_ip, simplyprint_id, sp_company_id,
                       printer_size_category, bed_width, bed_depth
                FROM public.devices ORDER BY friendly_name ASC
            """)
            print("--- DEBUG: SQL query executed successfully. Fetching results... ---")
            columns = [desc[0] for desc in cur.description]
            devices = [dict(zip(columns, row)) for row in cur.fetchall()]
            print("--- DEBUG: Results fetched and processed. Returning data. ---")
        return jsonify(devices)
    except Exception as e:
        print("--- DEBUG: An exception occurred INSIDE THE 'try' block of get_devices(). ---")
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500
    finally:
        if conn:
            print("--- DEBUG: Closing database connection in get_devices(). ---")
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
        traceback.print_exc()
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
        traceback.print_exc()
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
        traceback.print_exc()
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
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500
    finally:
        if conn:
            conn.close()

# --- Main execution block ---
if __name__ == '__main__':
    # For production, debug should be False. Gunicorn or another WSGI server will be used.
    print("--- DEBUG: Starting Flask development server. ---")
    app.run(host='0.0.0.0', port=5000, debug=False)

# /enms-project/python-api/pdf_service.py

import os
import sys
import traceback
import json
import base64
import psycopg2
import psycopg2.extras
from weasyprint import HTML
from jinja2 import Environment, FileSystemLoader

# --- Setup Jinja2 to find the templates inside the container ---
# The Dockerfile copies our code to /app, so templates will be in /app/templates
template_loader = FileSystemLoader(searchpath="/app/templates")
template_env = Environment(loader=template_loader)

# --- NEW: Helper function to clean garbled filenames ---
def clean_filename(raw_name):
    if not raw_name or not isinstance(raw_name, str):
        return raw_name
    if raw_name.startswith("namen_b'") and raw_name.endswith("'"):
        try:
            base64_str = raw_name[9:-1]
            decoded_bytes = base64.b64decode(base64_str)
            decoded_str = decoded_bytes.decode('utf-8')
            json_str = decoded_str.replace("'", '"')
            data = json.loads(json_str)
            model_ids = [item.get('model', {}).get('id', '') for item in data]
            clean_name = ", ".join(filter(None, model_ids))
            return clean_name if clean_name else "Multi-Part Print"
        except Exception:
            return raw_name
    return raw_name

# --- Database Connection (Docker-aware) ---
def get_db_connection():
    # This function reads environment variables provided by docker-compose
    return psycopg2.connect(
        dbname=os.environ.get('POSTGRES_DB'),
        user=os.environ.get('POSTGRES_USER'),
        password=os.environ.get('POSTGRES_PASSWORD'),
        host=os.environ.get('POSTGRES_HOST'), # This will be 'postgres'
        port=os.environ.get('POSTGRES_PORT')
    )

# --- Helper Functions for Plant Image (Docker paths) ---
PLANT_THRESHOLDS = [0.01, 0.018, 0.021, 0.022, 0.024, 0.027, 0.030, 0.04, 0.045, 0.05, 0.06, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.5, 3.0]

def get_plant_stage(kwh):
    kwh_val = kwh if isinstance(kwh, (int, float)) else float('-inf')
    if kwh_val < PLANT_THRESHOLDS[0]: return 1
    for i in range(len(PLANT_THRESHOLDS) - 1, -1, -1):
        if kwh_val >= PLANT_THRESHOLDS[i]: return min(i + 2, 19)
    return 1

def get_plant_image_src(plant_type, kwh_for_plant):
    # This path is where the artistic-resources will be mounted inside this container
    ART_ROOT = "/app/artistic-resources"
    plant_type_clean = (plant_type or 'generic_plant').lower()
    stage = get_plant_stage(kwh_for_plant)
    max_stages = 21
    plant_folder = "generic_plant"
    if plant_type_clean == 'corn':
        max_stages = 8
        plant_folder = "corn"
    stage = min(stage, max_stages)
    stage_padded = str(stage).zfill(2)
    image_path = os.path.join(ART_ROOT, "plants", plant_folder, f"{plant_folder}_stage_{stage_padded}.png")
    return f"file://{image_path}"

# --- Main Service Function ---
def generate_pdf_for_job(job_id):
    """
    Fetches job data, renders a template, creates a PDF, and updates the database.
    Returns a dictionary with success status and the PDF URL.
    """
    conn = None
    try:
        conn = get_db_connection()
        cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        # The SQL query now also fetches the material
        query = """
            SELECT pj.*, d.friendly_name, d.device_model, d.printer_size_category,
                   ps.nozzle_temp_actual, ps.bed_temp_actual, ps.material
            FROM print_jobs pj
            JOIN devices d ON pj.device_id = d.device_id
            LEFT JOIN LATERAL (
                SELECT nozzle_temp_actual, bed_temp_actual, material FROM printer_status
                WHERE device_id = pj.device_id AND timestamp <= pj.end_time
                ORDER BY timestamp DESC LIMIT 1
            ) ps ON true
            WHERE pj.job_id = %s;
        """
        cur.execute(query, (job_id,))
        job_data = cur.fetchone()

        if not job_data:
            raise ValueError(f"Job with ID {job_id} not found")

        job_data_dict = dict(job_data)

        # ===== THIS IS THE FIX: The order of operations is corrected =====
        
        # 1. FIRST, safely handle the gcode_analysis_data field.
        # This ensures it is ALWAYS a dictionary before anything else tries to access it.
        gca_data = job_data_dict.get("gcode_analysis_data")
        if gca_data is None:
            job_data_dict["gcode_analysis_data"] = {} # If NULL, make it an empty dict
        elif isinstance(gca_data, str):
            try:
                job_data_dict["gcode_analysis_data"] = json.loads(gca_data)
            except (json.JSONDecodeError, TypeError):
                job_data_dict["gcode_analysis_data"] = {}

        # 2. SECOND, now that we know gcode_analysis_data is a dict, we can safely clean filenames.
        if 'filename' in job_data_dict:
            job_data_dict['filename'] = clean_filename(job_data_dict.get('filename'))
        
        # This line is now safe because job_data_dict["gcode_analysis_data"] is guaranteed to be a dict.
        if job_data_dict.get("gcode_analysis_data", {}).get("object_name"):
            job_data_dict["gcode_analysis_data"]["object_name"] = clean_filename(job_data_dict["gcode_analysis_data"]["object_name"])

        # ===== END OF FIX =====

        numeric_fields = ['session_energy_wh', 'filament_used_g', 'duration_seconds', 'nozzle_temp_actual', 'bed_temp_actual']
        for field in numeric_fields:
            if field in job_data_dict and job_data_dict[field] is not None:
                job_data_dict[field] = float(job_data_dict[field])
        
        session_energy = job_data_dict.get('session_energy_wh', 0) or 0
        kwh_consumed = session_energy / 1000.0 if session_energy else 0
        
        plant_type_for_job = job_data_dict.get('plant_type', 'generic_plant')
        file_path_plant_image_url = get_plant_image_src(plant_type_for_job, kwh_consumed)
        
        file_path_thumbnail_url = None
        if job_data_dict.get('thumbnail_url'):
            thumbnail_path = os.path.join("/app", job_data_dict['thumbnail_url'].lstrip('/'))
            if os.path.exists(thumbnail_path):
                file_path_thumbnail_url = f"file://{thumbnail_path}"

        template = template_env.get_template('dpp_job_report.html')
        rendered_html = template.render(
            job=job_data_dict, device=job_data_dict,
            plant_image_url=file_path_plant_image_url,
            thumbnail_url=file_path_thumbnail_url
        )

        pdf_filename = f'dpp_job_{job_id}.pdf'
        pdf_dir = '/app/generated_pdfs' 
        pdf_path = os.path.join(pdf_dir, pdf_filename)
        HTML(string=rendered_html).write_pdf(pdf_path)

        pdf_url = f'/dpp_reports/{pdf_filename}'
        update_query = "UPDATE print_jobs SET dpp_pdf_url = %s WHERE job_id = %s;"
        cur.execute(update_query, (pdf_url, job_id))
        conn.commit()

        return {"success": True, "pdf_url": pdf_url}

    finally:
        if conn:
            conn.close()

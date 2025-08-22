# /home/ubuntu/enms-project/python-api/app.py

import traceback
from flask import Flask, jsonify, request

# Import our existing function for the summary
from dpp_simulator import get_live_dpp_data
# Import our new, dedicated function for PDF generation
from pdf_service import generate_pdf_for_job

app = Flask(__name__)


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


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)

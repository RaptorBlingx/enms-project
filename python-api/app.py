# /home/ubuntu/enms-project/python-api/app.py

from flask import Flask, jsonify

# Import our new, refactored function
from dpp_simulator import get_live_dpp_data
# We will import and add the gcode analyzer endpoint later

app = Flask(__name__)

@app.route('/api/dpp_summary', methods=['GET'])
def dpp_summary():
    """
    Provides a real-time summary of all printers for the DPP frontend.
    """
    # Call the function that does all the database work
    data = get_live_dpp_data()
    
    # Check if the function returned an error
    if "error" in data:
        # Return a 500 Internal Server Error status code for better error handling
        return jsonify(data), 500
    
    # If successful, return the data with a 200 OK status code
    return jsonify(data)

if __name__ == '__main__':
    # Set debug=False for a production-like environment
    app.run(host='0.0.0.0', port=5000, debug=False)

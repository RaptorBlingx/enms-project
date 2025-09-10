from flask import Flask, jsonify, request
import psycopg2
import os

app = Flask(__name__)

def get_db_connection():
    conn = psycopg2.connect(
        host=os.environ.get("DB_HOST"),
        database=os.environ.get("DB_NAME"),
        user=os.environ.get("DB_USER"),
        password=os.environ.get("DB_PASSWORD"))
    return conn

@app.route('/api/devices', methods=['GET'])
def get_devices():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT device_id, device_model, friendly_name, location, shelly_id, api_ip, api_key, notes FROM devices ORDER BY friendly_name ASC;')
    devices = cur.fetchall()
    cur.close()
    conn.close()

    device_list = []
    for device in devices:
        device_list.append({
            "device_id": device[0],
            "device_model": device[1],
            "friendly_name": device[2],
            "location": device[3],
            "shelly_id": device[4],
            "api_ip": device[5],
            "api_key": device[6],
            "notes": device[7]
        })

    return jsonify(device_list)

@app.route('/api/devices/<string:device_id>', methods=['GET'])
def get_device(device_id):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT device_id, device_model, friendly_name, location, shelly_id, api_ip, api_key, notes FROM devices WHERE device_id = %s;', (device_id,))
    device = cur.fetchone()
    cur.close()
    conn.close()

    if device is None:
        return jsonify({"error": "Device not found"}), 404

    return jsonify({
        "device_id": device[0],
        "device_model": device[1],
        "friendly_name": device[2],
        "location": device[3],
        "shelly_id": device[4],
        "api_ip": device[5],
        "api_key": device[6],
        "notes": device[7]
    })

@app.route('/api/devices', methods=['POST'])
def add_device():
    new_device = request.get_json()
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('INSERT INTO devices (device_id, device_model, friendly_name, location, shelly_id, api_ip, api_key, notes) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)',
                (new_device['device_id'], new_device['device_model'], new_device['friendly_name'], new_device['location'], new_device.get('shelly_id'), new_device.get('api_ip'), new_device.get('api_key'), new_device.get('notes')))
    conn.commit()
    cur.close()
    conn.close()
    return jsonify(new_device)

@app.route('/api/devices/<string:device_id>', methods=['PUT'])
def update_device(device_id):
    device_data = request.get_json()
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('UPDATE devices SET device_model = %s, friendly_name = %s, location = %s, shelly_id = %s, api_ip = %s, api_key = %s, notes = %s WHERE device_id = %s',
                (device_data['device_model'], device_data['friendly_name'], device_data['location'], device_data.get('shelly_id'), device_data.get('api_ip'), device_data.get('api_key'), device_data.get('notes'), device_id))
    conn.commit()
    cur.close()
    conn.close()
    return jsonify(device_data)

@app.route('/api/devices/<string:device_id>', methods=['DELETE'])
def delete_device(device_id):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('DELETE FROM devices WHERE device_id = %s;', (device_id,))
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({'result': True})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)

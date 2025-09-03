#!/usr/bin/env python3
# prediction_worker_mqtt.py - Listens to MQTT for prediction requests

import os
import sys
import json
import signal
import traceback
import warnings

import numpy as np
import pandas as pd
import joblib
import paho.mqtt.client as mqtt

# --------------------
# General Config
# --------------------
MODEL_DIR = os.environ.get("MODEL_DIR")
IMPUTE = float(os.environ.get("IMPUTE", "0.0"))
IDLE_NOZZLE_C = float(os.environ.get("IDLE_NOZZLE_C", "30.0"))
IDLE_BED_C    = float(os.environ.get("IDLE_BED_C", "30.0"))

NUMERIC_COLS = [
    "plug_temp_c",
    "nozzle_temp_actual", "nozzle_temp_target",
    "bed_temp_actual",    "bed_temp_target",
    "ambient_temp_c",
    "z_height_mm",
    "voltage", "current_amps",
    "speed_multiplier_percent",
    "is_printing", "is_operational", "is_paused", "is_error", "is_busy"
]

# --------------------
# Helper Functions
# --------------------
def log_err(msg: str) -> None:
    print(msg, file=sys.stderr, flush=True)

def predict_from_features(feat: dict, model, scaler, features) -> float:
    df = pd.DataFrame(0.0, index=[0], columns=features)
    for k, v in (feat or {}).items():
        if k in df.columns and v is not None:
            df.loc[0, k] = v
    for c in NUMERIC_COLS:
        if c in df.columns:
            df.loc[0, c] = pd.to_numeric(df.loc[0, c], errors="coerce")
    df.fillna(IMPUTE, inplace=True)
    if "z_height_mm" in df.columns and df.loc[0, "z_height_mm"] < 0:
        df.loc[0, "z_height_mm"] = 0.0
    if "is_printing" in df.columns:
        df.loc[0, "is_printing"] = 1.0 if df.loc[0, "is_printing"] in (True, 1, 1.0, "1", "true", "True") else 0.0
    if all(c in df.columns for c in ("nozzle_temp_target", "nozzle_temp_actual")):
        df["nozzle_temp_delta"] = df["nozzle_temp_target"] - df["nozzle_temp_actual"]
    if all(c in df.columns for c in ("bed_temp_target", "bed_temp_actual")):
        df["bed_temp_delta"] = df["bed_temp_target"] - df["bed_temp_actual"]
    mat = (feat or {}).get("material") or "Unknown"
    onehot = f"material_{mat}"
    if onehot in df.columns:
        df.loc[0, onehot] = 1.0
    elif "material_Unknown" in df.columns:
        df.loc[0, "material_Unknown"] = 1.0
    X = df[features]
    X = X.apply(pd.to_numeric, errors='coerce')
    X.fillna(IMPUTE, inplace=True)
    if np.isinf(X.values).any():
        X.replace([np.inf, -np.inf], 0.0, inplace=True)
    Xs = scaler.transform(X)
    raw_prediction = float(model.predict(Xs)[0])
    is_printing_val = X.get("is_printing", pd.Series([0.0])).iloc[0]
    nozzle_temp = X.get("nozzle_temp_actual", pd.Series([0.0])).iloc[0]
    bed_temp = X.get("bed_temp_actual", pd.Series([0.0])).iloc[0]
    if is_printing_val == 0 and nozzle_temp < IDLE_NOZZLE_C and bed_temp < IDLE_BED_C:
        return 0.0
    return max(0.0, raw_prediction)

# --------------------
# MQTT Configuration
# --------------------
MQTT_BROKER_HOST = os.environ.get("MQTT_BROKER_HOST")
MQTT_PORT = int(os.environ.get("MQTT_PORT"))
MQTT_USERNAME = os.environ.get("MQTT_USERNAME")
MQTT_PASSWORD = os.environ.get("MQTT_PASSWORD")
MQTT_TOPIC_REQUEST = "predictions/request"
MQTT_TOPIC_RESULT = "predictions/result"

# --------------------
# MQTT Callback Functions
# --------------------
# --- THIS IS THE FIX ---
# The function now accepts the 5th argument 'properties' which the V2 API provides.
def on_connect(client, userdata, flags, rc, properties=None):
    if rc == 0:
        log_err(f"Successfully connected to MQTT Broker. Subscribing to topic '{MQTT_TOPIC_REQUEST}'")
        client.subscribe(MQTT_TOPIC_REQUEST)
    else:
        log_err(f"Failed to connect to MQTT, return code {rc}")

def on_message(client, userdata, msg):
    device_id = "unknown_device"
    try:
        data = json.loads(msg.payload.decode("utf-8"))
        features_payload = data.get("payload", {})
        device_id = data.get("device_id", "unknown_device")
        prediction = predict_from_features(
            features_payload, userdata['model'], userdata['scaler'], userdata['features']
        )
        result = {"payload": {"predicted_power_watts": prediction}, "device_id": device_id}
        client.publish(MQTT_TOPIC_RESULT, json.dumps(result))
    except Exception as e:
        log_err(f"Error processing message for device '{device_id}': {e}\n{traceback.format_exc()}")

# --------------------
# Main Application
# --------------------
if __name__ == "__main__":
    warnings.filterwarnings("ignore", category=UserWarning)
    warnings.filterwarnings("ignore", category=FutureWarning)

    try:
        log_err("--- Loading ML assets into memory... ---")
        MODEL = joblib.load(os.path.join(MODEL_DIR, "best_model.joblib"))
        SCALER = joblib.load(os.path.join(MODEL_DIR, "scaler.joblib"))
        FEATURES = joblib.load(os.path.join(MODEL_DIR, "model_features.joblib"))
        log_err("--- ML assets loaded. Initializing MQTT client. ---")
    except Exception as e:
        log_err(f"FATAL: Could not load ML assets from '{MODEL_DIR}': {e}")
        sys.exit(1)

    client_userdata = {"model": MODEL, "scaler": SCALER, "features": FEATURES}
    
    # We are using the modern V2 API, which is good practice.
    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, userdata=client_userdata)
    
    client.username_pw_set(MQTT_USERNAME, MQTT_PASSWORD)
    client.on_connect = on_connect
    client.on_message = on_message

    try:
        log_err(f"Connecting to MQTT broker at {MQTT_BROKER_HOST}:{MQTT_PORT}...")
        client.connect(MQTT_BROKER_HOST, MQTT_PORT, 60)
    except Exception as e:
        log_err(f"FATAL: Could not connect to MQTT broker: {e}")
        sys.exit(1)

    client.loop_forever()

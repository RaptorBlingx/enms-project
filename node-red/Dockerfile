# ====================================================================
# FINAL DOCKERFILE FOR ENMS NODE-RED SERVICE (ALPINE LINUX)
# ====================================================================

# 1. Start from the official Alpine-based Node-RED image
FROM nodered/node-red:latest

# 2. Switch to the root user to install system packages
USER root

# 3. Install all necessary system dependencies using Alpine's 'apk' package manager
RUN apk add --no-cache python3 python3-dev build-base postgresql-client cmake

# 4. Create a proper Python virtual environment at the path your flow expects
RUN python3 -m venv /home/ubuntu/monitor_ml/venv

# 5. Copy your Python requirements file into a temporary location
COPY backend/requirements.txt /tmp/requirements.txt

# 6. Activate the virtual environment and install dependencies.
#    --extra-index-url tells pip where to find the NVIDIA packages if xgboost needs them.
RUN . /home/ubuntu/monitor_ml/venv/bin/activate && \
    pip install --no-cache-dir --extra-index-url https://pypi.nvidia.com -r /tmp/requirements.txt

# 7. Copy your Python scripts to the exact location the exec node expects
COPY backend/dpp_simulator.py /home/ubuntu/monitor_ml/dpp_simulator.py
COPY backend/gcode_analyzer.py /home/ubuntu/monitor_ml/gcode_analyzer.py

# 8. Switch to the data directory for Node-RED specific installations
WORKDIR /data

# 9. Copy your project's package.json to install custom Node-RED nodes
COPY node-red/package.json .
RUN npm install

# 10. Switch back to the non-root node-red user for security
USER node-red

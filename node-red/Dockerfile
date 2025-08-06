# ====================================================================
# FINAL DOCKERFILE FOR ENMS NODE-RED SERVICE
# ====================================================================

# 1. Use a Debian-based Node-RED image for better Python compatibility
FROM nodered/node-red:latest-18

# 2. Switch to the root user to install system packages
USER root

# 3. Update package list and install all necessary system dependencies
#    - python3-venv: For creating the virtual environment
#    - python3-dev & build-essential: For compiling Python packages
#    - postgresql-client: For psycopg2
#    - cmake: For building xgboost
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-venv \
    python3-dev \
    build-essential \
    postgresql-client \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# 4. Create the exact directory structure your exec node expects
RUN mkdir -p /home/ubuntu/monitor_ml/venv

# 5. Create a proper Python virtual environment at that location
RUN python3 -m venv /home/ubuntu/monitor_ml/venv

# 6. Copy your Python requirements file into a temporary location
COPY backend/requirements.txt /tmp/requirements.txt

# 7. Activate the virtual environment and use its pip to install dependencies
#    This will now use pre-compiled wheels for most packages, making it faster.
RUN . /home/ubuntu/monitor_ml/venv/bin/activate && \
    pip install --no-cache-dir -r /tmp/requirements.txt

# 8. Copy your Python scripts to the exact location the exec node expects
COPY backend/dpp_simulator.py /home/ubuntu/monitor_ml/dpp_simulator.py
COPY backend/gcode_analyzer.py /home/ubuntu/monitor_ml/gcode_analyzer.py

# 9. Switch to the data directory for Node-RED specific installations
WORKDIR /data

# 10. Copy your project's package.json to install custom Node-RED nodes
COPY node-red/package.json .
RUN npm install

# 11. Switch back to the non-root node-red user for security
USER node-red

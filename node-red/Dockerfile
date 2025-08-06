# Start from the official Node-RED image
FROM nodered/node-red:latest

# Switch to the root user to install packages
USER root

# Install Python, venv, compilers, and PostgreSQL client
RUN apk add --no-cache python3 python3-dev build-base postgresql-client cmake

# --- Corrected Python Setup ---
# 1. Create the directory structure
RUN mkdir -p /home/ubuntu/monitor_ml/venv

# 2. Create a proper Python virtual environment
RUN python3 -m venv /home/ubuntu/monitor_ml/venv

# 3. Copy your Python requirements file
COPY backend/requirements.txt /tmp/requirements.txt

# 4. Activate the virtual environment, install nvidia-pyindex first, then requirements
RUN . /home/ubuntu/monitor_ml/venv/bin/activate && \
    pip install --no-cache-dir nvidia-pyindex && \
    pip install --no-cache-dir -r /tmp/requirements.txt

# 5. Copy your Python scripts
COPY backend/dpp_simulator.py /home/ubuntu/monitor_ml/dpp_simulator.py
COPY backend/gcode_analyzer.py /home/ubuntu/monitor_ml/gcode_analyzer.py

# Switch to the data directory for Node-RED specific installations
WORKDIR /data

# Copy your project's package.json to install custom Node-RED nodes
COPY node-red/package.json .
RUN npm install

# Switch back to the non-root node-red user
USER node-red

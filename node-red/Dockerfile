# Start from the official Node-RED image
FROM nodered/node-red:latest

# Switch to the root user to install system packages and set up the environment
USER root

# Install Python, venv, pip, and PostgreSQL client libraries
# python3 automatically includes venv. python3-dev and build-base are needed by some pip packages.
RUN apk add --no-cache python3 python3-dev build-base postgresql-client
# 1. Create the directory structure your exec node expects
RUN mkdir -p /home/ubuntu/monitor_ml/venv

# 2. Create a proper Python virtual environment at that location
RUN python3 -m venv /home/ubuntu/monitor_ml/venv

# 3. Copy your Python requirements file into a temporary location
COPY backend/requirements.txt /tmp/requirements.txt

# 4. Activate the virtual environment and use its pip to install the dependencies
# This is the key step that satisfies PEP 668
RUN . /home/ubuntu/monitor_ml/venv/bin/activate && \
    pip install --no-cache-dir -r /tmp/requirements.txt

# 5. Copy your Python scripts to the location the exec node expects
COPY backend/dpp_simulator.py /home/ubuntu/monitor_ml/dpp_simulator.py
COPY backend/gcode_analyzer.py /home/ubuntu/monitor_ml/gcode_analyzer.py
# --- END OF CORRECTED PYTHON SETUP ---

# Switch to the data directory for Node-RED specific installations
WORKDIR /data

# Copy your project's package.json to install custom Node-RED nodes
COPY node-red/package.json .
RUN npm install

# Switch back to the non-root node-red user for security
USER node-red

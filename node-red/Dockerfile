# ====================================================================
# ENMS Node-RED Service Dockerfile (FINAL with PEP 668 fix)
# ====================================================================

FROM nodered/node-red:4.0.9

# Switch to root user for system-level installations
USER root

# Install Python and tools needed to create a venv and compile packages
RUN apk add --no-cache python3 py3-pip postgresql-client build-base

# --- NEW: Create and activate a virtual environment ---
# This is the standard way to comply with PEP 668.
# 1. Create a virtual environment in a standard location like /opt/venv
RUN python3 -m venv /opt/venv

# 2. Add the venv's bin directory to the system's PATH.
# This makes 'python' and 'pip' commands automatically use the venv.
ENV PATH="/opt/venv/bin:$PATH"

# --- Python Dependencies ---
# Copy the requirements file
COPY python-api/requirements.txt /tmp/requirements.txt
# Now, this 'pip install' command will use the venv's pip,
# installing packages into /opt/venv, not the protected system area.
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# --- Node-RED Setup ---
USER node-red
WORKDIR /data

# Copy backend ML scripts
COPY backend /data/backend

# Standard Node-RED setup (unchanged)
COPY node-red/package.json ./
RUN npm install --no-audit --no-fund
COPY python-api/gcode_analyzer.py /data/scripts/gcode_analyzer.py
COPY node-red/flows_docker.json /data/flows_docker.json
COPY node-red/settings.js /data/settings.js

# --- Permissions and Finalization ---
USER root
RUN chown -R node-red:node-red /data
USER node-red

WORKDIR /usr/src/node-red

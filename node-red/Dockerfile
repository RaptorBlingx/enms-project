# ====================================================================
# ENMS Node-RED Service Dockerfile (MODIFIED with full Python/ML runtime)
# ====================================================================

# Base image remains the same
FROM nodered/node-red:4.0.9

# Switch to root user for system-level installations
USER root

# MODIFICATION: Added py3-pip and build-base for installing Python packages
RUN apk add --no-cache python3 py3-pip postgresql-client build-base

# NEW: Install all Python dependencies from the shared requirements file
# This is a critical new section.
COPY python-api/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Switch back to the non-root node-red user
USER node-red
WORKDIR /data

# Node-RED palette dependencies (this block is unchanged)
COPY node-red/package.json ./
RUN npm install --no-audit --no-fund

# Copy analyzer script (this block is unchanged)
RUN mkdir -p /data/scripts
COPY python-api/gcode_analyzer.py /data/scripts/gcode_analyzer.py

# NEW: Copy the backend ML scripts for training and analysis
# This makes them available for the exec nodes in the flows.
RUN mkdir -p /data/backend
COPY backend/export_training_data.py /data/backend/export_training_data.py
COPY backend/train_model.py /data/backend/train_model.py

# Flows / settings (this block is unchanged)
COPY node-red/flows_docker.json /data/flows_docker.json
COPY node-red/flows_cred.json   /data/flows_cred.json
COPY node-red/settings.js       /data/settings.js

# Permissions tidy (this block is unchanged)
USER root
RUN chown -R node-red:node-red /data
USER node-red

# Keep default entrypoint (this block is unchanged)
WORKDIR /usr/src/node-red

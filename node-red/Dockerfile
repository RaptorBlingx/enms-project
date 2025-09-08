# ====================================================================
# ENMS Node-RED Service Dockerfile (FINAL - Corrected)
# ====================================================================

FROM nodered/node-red:4.0.9

USER root
RUN apk add --no-cache \
    python3 py3-pip build-base python3-dev postgresql-client cmake

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY python-api/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copy scripts to the permanent application directory
COPY backend /usr/src/node-red/backend_scripts

# --- NODE-RED SETUP ---
USER node-red
WORKDIR /data

# Copy the initial user data files
COPY node-red/package.json ./
# --- THIS IS THE FIX ---
# Copy the specific flow file to the default name 'flows.json'
COPY node-red/flows_docker.json /data/flows.json
COPY node-red/settings.js ./

# Install npm packages
RUN npm install --no-audit --no-fund

# --- Permissions and Finalization ---
USER root
RUN chown -R node-red:node-red /data

USER node-red
WORKDIR /usr/src/node-red

# ====================================================================
# ENMS Node-RED Service Dockerfile (flows + python runtime + analyzer)
# ====================================================================

FROM nodered/node-red:4.0.9

# OS deps (Alpine base)
USER root
RUN apk add --no-cache python3 postgresql-client

# Node-RED home
USER node-red
WORKDIR /data

# Node-RED palette deps
COPY node-red/package.json ./
RUN npm install --no-audit --no-fund

# Copy analyzer script from python_api (single source of truth)
RUN mkdir -p /data/scripts
COPY python-api/gcode_analyzer.py /data/scripts/gcode_analyzer.py

# Flows / settings
COPY node-red/flows_docker.json /data/flows_docker.json
COPY node-red/flows_cred.json   /data/flows_cred.json
COPY node-red/settings.js       /data/settings.js

# Permissions tidy
USER root
RUN chown -R node-red:node-red /data
USER node-red

# Keep default entrypoint
WORKDIR /usr/src/node-red

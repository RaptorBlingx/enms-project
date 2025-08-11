# ====================================================================
# ENMS Node-RED Service Dockerfile (Baked dependencies + flows)
# ====================================================================

# 1. Base image (pin version to avoid future breaking changes)
FROM nodered/node-red:4.0.9

# 2. Switch to root to install OS-level deps (optional: postgres client)
USER root
RUN apk add --no-cache postgresql-client

# 3. Work in /data (Node-RED userDir)
WORKDIR /data

# 4. Copy package.json and install dependencies
COPY node-red/package.json .
RUN npm install --no-audit --no-fund

# 5. Copy Node-RED config files and optional lib directory
COPY node-red/flows.json ./flows.json
COPY node-red/flows_cred.json ./flows_cred.json
COPY node-red/settings.js ./settings.js
COPY node-red/lib ./lib

# 6. Fix permissions
RUN chown -R node-red:node-red /data

# 7. Switch back to node-red user
USER node-red

# 8. Set workdir back to default for base image entrypoint
WORKDIR /usr/src/node-red

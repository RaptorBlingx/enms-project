# ====================================================================
# ENMS Node-RED Service Dockerfile (Baked dependencies + flows)
# ====================================================================

# 1. Base image (pin version to avoid future breaking changes)
FROM nodered/node-red:4.0.9

USER root
RUN apk add --no-cache postgresql-client
USER node-red

WORKDIR /data
COPY node-red/package.json .
RUN npm install --no-audit --no-fund

# copy flows, creds, settings, and optional lib
COPY node-red/flows.json ./flows.json
COPY node-red/flows_cred.json ./flows_cred.json
COPY node-red/settings.js ./settings.js
COPY node-red/lib ./lib

# ensure perms
USER root
RUN chown -R node-red:node-red /data
USER node-red

WORKDIR /usr/src/node-red

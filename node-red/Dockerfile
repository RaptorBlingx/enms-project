# ====================================================================
# FINAL DOCKERFILE FOR ENMS NODE-RED SERVICE (Simplified)
# ====================================================================

# 1. Start from the official Node-RED image
FROM nodered/node-red:latest

# 2. Switch to root to install the postgres client tools
USER root
RUN apk add --no-cache postgresql-client

# 3. Switch to the /data directory for the user
WORKDIR /data

# 4. Copy the package.json from the correct path relative to the build context
COPY node-red/package.json .

# 5. Run npm install to get the postgres node
RUN npm install

# 6. Change ownership of the installed modules to the node-red user
RUN chown -R node-red:node-red /data/node_modules

# 7. Switch back to the standard node-red user
USER node-red

# 8. Reset WORKDIR so the base image's relative entrypoint works
WORKDIR /usr/src/node-red

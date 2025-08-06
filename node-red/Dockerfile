# ====================================================================
# FINAL DOCKERFILE FOR ENMS NODE-RED SERVICE (Corrected Permissions)
# ====================================================================

# 1. Start from the official Alpine-based Node-RED image
FROM nodered/node-red:latest

# 2. Switch to the root user to install system packages
USER root

# 3. Install only the PostgreSQL client, which is needed by node-red-contrib-postgres
RUN apk add --no-cache postgresql-client

# 4. Switch to the data directory where Node-RED runs
WORKDIR /data

# 5. Copy your project's package.json to install custom Node-RED nodes
#    We copy this file first to take advantage of Docker layer caching.
COPY node-red/package.json .

# 6. Run npm install. This will create the node_modules directory owned by root.
RUN npm install

# 7. THIS IS THE FIX:
#    Recursively change the ownership of everything in /data
#    to the 'node-red' user. This ensures the runtime user has permission.
RUN chown -R node-red:node-red /data

# 8. Switch back to the non-root node-red user for running the application
USER node-red

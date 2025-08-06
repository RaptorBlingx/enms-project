# ====================================================================
# FINAL DOCKERFILE FOR ENMS NODE-RED SERVICE (No Python)
# ====================================================================

# 1. Start from the official Alpine-based Node-RED image
FROM nodered/node-red:latest

# 2. Switch to the root user to install system packages
USER root

# 3. Install only the PostgreSQL client, which is needed by node-red-contrib-postgres
RUN apk add --no-cache postgresql-client

# 4. Switch to the data directory for Node-RED specific installations
WORKDIR /data

# 5. Copy your project's package.json to install custom Node-RED nodes
COPY node-red/package.json .
RUN npm install

# 6. Switch back to the non-root node-red user for security
USER node-red1~# ====================================================================
# FINAL DOCKERFILE FOR ENMS NODE-RED SERVICE (No Python)
# ====================================================================

# 1. Start from the official Alpine-based Node-RED image
FROM nodered/node-red:latest

# 2. Switch to the root user to install system packages
USER root

# 3. Install only the PostgreSQL client, which is needed by node-red-contrib-postgres
RUN apk add --no-cache postgresql-client

# 4. Switch to the data directory for Node-RED specific installations
WORKDIR /data

# 5. Copy your project's package.json to install custom Node-RED nodes
COPY node-red/package.json .
RUN npm install

# 6. Switch back to the non-root node-red user for security
USER node-red

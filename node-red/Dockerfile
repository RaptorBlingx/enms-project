# Start from the official Node-RED image
FROM nodered/node-red:latest

# Switch to the root user to install system and Python packages
USER root

# Install Python, pip, and PostgreSQL client libraries
RUN apk add --no-cache python3 py3-pip postgresql-client

# Create the exact directory structure that your exec node expects
RUN mkdir -p /home/ubuntu/monitor_ml/venv/bin

# Now, we will create a symbolic link. This is the magic step.
# This makes the system's python3 executable also appear at the path your exec node calls.
RUN ln -s /usr/bin/python3 /home/ubuntu/monitor_ml/venv/bin/python

# Copy your Python requirements file into a temporary location in the container
COPY /backend/requirements.txt /tmp/requirements.txt

# Install all Python dependencies globally within the container
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Copy your Python scripts to the exact location the exec node expects
COPY /backend/dpp_simulator.py /home/ubuntu/monitor_ml/dpp_simulator.py
COPY /backend/gcode_analyzer.py /home/ubuntu/monitor_ml/gcode_analyzer.py
# Note: We don't need train_model.py for the live system

# Copy your project's package.json to install custom Node-RED nodes
WORKDIR /data
COPY node-red/package.json .
RUN npm install

# Switch back to the non-root node-red user for security
USER node-red

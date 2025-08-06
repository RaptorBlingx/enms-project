# ====================================================================
# Dockerfile for the ENMS Python API Service
# ====================================================================

# 1. Start from an official, Debian-based Python image.
#    'slim-bullseye' is a good choice as it's smaller than the full image
#    but has excellent compatibility for scientific packages.
FROM python:3.11-slim-bullseye

# 2. Set the working directory inside the container.
WORKDIR /app

# 3. Install necessary system dependencies.
#    - build-essential & postgresql-client are needed by psycopg2-binary.
#    - cmake is needed to build xgboost.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    postgresql-client \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# 4. Copy the requirements file into the container.
COPY requirements.txt .

# 5. Install the Python dependencies.
#    This step is now very reliable because we are on a Debian-based image.
RUN pip install --no-cache-dir -r requirements.txt

# 6. Copy the rest of your application code into the container.
COPY . .

# 7. Expose the port that the Flask application will run on.
EXPOSE 5000

# 8. Define the command to run when the container starts.
#    This command executes your Flask application.
CMD ["python", "app.py"]

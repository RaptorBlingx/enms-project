# ====================================================================
# Dockerfile for the ENMS Python API Service
# ====================================================================

# 1. Start from an official, Debian-based Python image.
FROM python:3.11-slim-bullseye

# 2. Set the working directory inside the container.
WORKDIR /app

# 3. Install necessary system dependencies.
#    - build-essential, postgresql-client, cmake are for existing packages.
#    - libpango, cairo, etc., are NEW and required by WeasyPrint for rendering.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    postgresql-client \
    cmake \
    libpango-1.0-0 \
    libpangoft2-1.0-0 \
    libharfbuzz0b \
    libffi-dev \
    libcairo2 \
    && rm -rf /var/lib/apt/lists/*

# 4. Copy the requirements file into the container.
COPY requirements.txt .

# 5. Install the Python dependencies.
RUN pip install --no-cache-dir -r requirements.txt

# 6. Copy the rest of your application code into the container.
COPY . .

# 7. Create a directory inside the container for generated PDFs.
RUN mkdir -p /app/generated_pdfs

# 8. Expose the port that the Flask application will run on.
EXPOSE 5000

# 9. Define the command to run when the container starts.
CMD ["python", "app.py"]

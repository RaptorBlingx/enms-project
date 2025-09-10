# Use an official Python runtime as a parent image
FROM python:3.9 as builder

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the requirements file into the container at /usr/src/app
COPY requirements.txt ./

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Use a smaller base image for the final image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the installed packages from the builder stage
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# Copy the rest of the application's code into the container
COPY device_api.py .

# Make port 5001 available to the world outside this container
EXPOSE 5001

# Define environment variables
ENV DB_HOST=db \
    DB_NAME=enms \
    DB_USER=enms \
    DB_PASSWORD=enms

# Run app.py when the container launches
CMD ["python", "device_api.py"]

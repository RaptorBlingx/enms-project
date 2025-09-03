# Dockerfile for the ML Prediction Worker
FROM python:3.12-slim
WORKDIR /app
COPY ./python-api/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY ./backend/prediction_worker_mqtt.py .
CMD ["python", "-u", "prediction_worker_mqtt.py"]

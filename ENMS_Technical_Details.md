# ENMS Technical Documentation

This document provides a deep dive into the architecture, data flows, interfaces, and deployment procedures for the Energy Management System (ENMS) project.

## 1. Architecture Overview

The ENMS platform has been re-architected into a modular, containerized system based on a microservices approach. This design improves stability, scalability, and maintainability by decoupling core functionalities into independent services that communicate over the network. All services are orchestrated by Docker Compose.

### 1.1. Service Architecture Diagram

The following diagram illustrates the high-level service architecture, showing the key Docker containers and their interactions.

![ENMS Architecture](./docs/enms-architecture.png)

### 1.2. Core Services (Docker Containers)

The `docker-compose.yml` file defines the following core services:

*   **`postgres`**
    *   **Description:** The primary data storage backend. It uses **PostgreSQL** with the **TimescaleDB** extension, which provides powerful features for handling time-series data, such as hypertables and continuous aggregates.
    *   **Responsibilities:** Stores all relational data (device configurations, print job history) and time-series data (energy readings, sensor data, ML predictions).

*   **`nodered`**
    *   **Description:** The low-code data processing and automation engine. In the new architecture, its role is focused on ingestion, enrichment, and routing.
    *   **Responsibilities:**
        *   Polling external APIs (PrusaLink, SimplyPrint) for printer status.
        *   Subscribing to MQTT topics for sensor data from Shelly plugs and ESP32 hubs.
        *   Performing data enrichment (e.g., mapping a `shelly_id` to an internal `device_id`).
        *   Storing processed data in the `postgres` database.
        *   Hosting the `POST /api/analyze` endpoint for the Interactive Analysis page.
    *   **Dockerfile:** The `node-red/Dockerfile` now builds a hardened image with a self-contained Python environment to run analysis scripts reliably.

*   **`ml_worker`**
    *   **Description:** A new, dedicated Python service that runs the machine learning model for live predictions. This service is the core of the new, stable prediction pipeline.
    *   **Responsibilities:**
        *   Loads the trained ML model into memory once on startup.
        *   Subscribes to the `enms/predictions/request` MQTT topic.
        *   Listens for prediction requests, processes them sequentially, and publishes results to the `enms/predictions/result` topic.
    *   **Script:** `backend/prediction_worker_mqtt.py`.

*   **`mosquitto`**
    *   **Description:** A new, lightweight, and high-performance MQTT message broker. It is the central communication bus for real-time messages between services.
    *   **Responsibilities:**
        *   Receiving sensor data published by IoT devices (Shelly, ESP32).
        *   Brokering messages for the live prediction pipeline between `nodered` (producer) and `ml_worker` (consumer).

*   **`mosquitto_config_generator`**
    *   **Description:** A "zero-touch" utility service that runs once on the very first launch of the stack.
    *   **Responsibilities:**
        *   Reads the `MQTT_USER` and `MQTT_PASSWORD` from the `.env` file.
        *   Generates a valid `mosquitto.conf` and a password file.
        *   Places these files in a shared Docker volume (`mosquitto_config`) where the `mosquitto` service can find and use them.
    *   **Benefit:** This eliminates the need for manual broker configuration, making the initial setup seamless for new developers.

*   **Other Services:**
    *   **`grafana`:** For visualization and dashboards.
    *   **`python-api`:** The legacy Flask API for the DPP summary.
    *   **`nginx`:** The reverse proxy that routes traffic to the appropriate frontend or backend service.

## 2. The Live Prediction Pipeline (MQTT Producer/Consumer)

A major architectural change was the decoupling of the live prediction system to solve critical stability issues. The old system, which spawned a Python process from within Node-RED for every printer, was prone to server freezes and database crashes under load (a "spawn storm").

The new system implements a robust **Producer/Consumer pattern** using MQTT, which is highly scalable and resilient.

### 2.1. The Pattern Explained

1.  **Producer (`nodered`):**
    *   The Node-RED "Live Predictor" flow has been simplified. It no longer runs any Python code directly.
    *   Instead, it queries the database for the latest features of all active printers.
    *   For each printer, it formats the features into a JSON payload and **publishes** a message to the `enms/predictions/request` MQTT topic.

2.  **Message Broker (`mosquitto`):**
    *   The `mosquitto` service instantly receives the request message and holds it until a subscriber is ready.

3.  **Consumer (`ml_worker`):**
    *   The `ml_worker` service runs a persistent Python script (`prediction_worker_mqtt.py`) that subscribes to the `enms/predictions/request` topic.
    *   The ML model is **loaded into memory only once** when the script starts.
    *   The worker processes one message from the queue at a time, in a sequential manner.
    *   For each message, it runs the prediction using the already-loaded model, which is extremely fast.
    *   It then publishes the prediction result to the `enms/predictions/result` topic.

4.  **Result Handling (`nodered`):**
    *   A separate Node-RED flow subscribes to the `enms/predictions/result` topic, receives the result, and inserts it into the `ml_predictions` table in the database.

### 2.2. Advantages of the New Architecture

*   **Stability:** Eliminates the "spawn storm" by having one persistent, long-running Python process instead of many short-lived ones. This prevents server freezes and crashes.
*   **Performance:** The ML model is loaded only once, dramatically reducing the latency of each prediction. Processing is sequential and non-blocking.
*   **Scalability:** The MQTT broker can handle a massive volume of messages. If prediction becomes a bottleneck in the future, the `ml_worker` service can be scaled horizontally (by running more instances) without changing any other part of the system.
*   **Decoupling:** The `nodered` service no longer needs to know how prediction is implemented. It just sends a request to a known topic. This makes the system easier to maintain and upgrade.

## 3. Data Flow & Dataset Descriptions

This section describes how data flows through the system, from its source to its storage, and details the structure of the key datasets (database tables).

### 3.1. Data Flow

1.  **Ingestion**:
    *   **IoT Devices**: Shelly plugs and ESP32 hubs publish data directly to the **`mosquitto`** broker.
    *   **Printer APIs**: **`nodered`** polls the REST APIs of PrusaLink and SimplyPrint.
2.  **Processing**: Within **`nodered`**, raw data is subscribed to (from MQTT) or received (from APIs), parsed, standardized, and enriched.
3.  **Storage**: **`nodered`** inserts the processed data into the appropriate tables in the **`postgres`** database.
4.  **Live Prediction**:
    *   `nodered` publishes prediction requests to MQTT.
    *   `ml_worker` consumes requests, runs predictions, and publishes results to MQTT.
    *   `nodered` subscribes to results and stores them in the database.
5.  **Consumption**:
    *   **`grafana`** directly queries the PostgreSQL database to populate its dashboards.
    *   The **Custom Frontend** makes API calls to endpoints which in turn query the database.

### 3.2. Data Sources & MQTT Topics

The MQTT broker is now central to the system.

*   **Shelly Smart Plugs**:
    *   `+/status/switch:0`: Publishes JSON with energy data.
*   **ESP32 Sensor Hub**:
    *   `esp32/raptorblingx/...`: Publishes various sensor readings.
*   **Live Prediction Pipeline**:
    *   `enms/predictions/request`: Topic where `nodered` sends feature sets for prediction.
    *   `enms/predictions/result`: Topic where `ml_worker` publishes prediction results.

### 3.3. Dataset Descriptions (Database Schema)

The database schema remains largely the same. The key tables are:
*   `public.devices`: Stores configuration for all monitored devices.
*   `public.print_jobs`: Stores history and metadata for each print job.
*   `public.energy_data`: Time-series hypertable for raw energy readings.
*   `public.printer_status`: Time-series hypertable for periodic printer status snapshots.
*   `public.ml_predictions`: Time-series hypertable where the final prediction results are stored.

## 4. Deployment Guide

This guide provides the necessary steps to deploy and run the ENMS project.

### 4.1. Software Prerequisites

*   **Docker** & **Docker Compose**
*   **Git**

### 4.2. Installation and Setup

1.  **Clone the Repository:**
    ```bash
    git clone https://gitlab.com/raptorblingx/enms-project.git
    cd enms-project
    ```

2.  **Create and Edit `.env` file:**
    This is a critical step for secure deployment.
    ```bash
    cp .env.example .env
    # Now, edit the .env file with your own secure passwords.
    ```

### 4.3. Zero-Touch Startup

The project is designed for zero-touch deployment.

1.  **Build and Run the Stack:**
    ```bash
    docker compose up --build -d
    ```
2.  **First Launch Process:**
    *   On the very first run, the `mosquitto_config_generator` service will start.
    *   It reads the `MQTT_USER` and `MQTT_PASSWORD` from your `.env` file.
    *   It generates the necessary `mosquitto.conf` and password files and saves them to a shared volume.
    *   The service then exits, and the main `mosquitto` service starts up using this newly generated configuration.
    *   This process only happens once. On subsequent launches, the configuration files already exist and are reused.

3.  **Access Services:**
    The services are available at their respective URLs (e.g., `http://localhost/`). Refer to the `README.md` for a full list.

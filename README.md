# **ENMS Project** – IoT-based Energy & Device Monitoring System

## 📌 Overview

The **ENMS Project** is an **IoT-based, real-time monitoring and analytics platform** designed for factories, production facilities, and IoT environments.
It integrates **Node-RED**, **PostgreSQL**, **Grafana**, **Python Flask API**, and **Nginx** into a **zero-touch Dockerized deployment**.

Main features:

* Real-time IoT data ingestion (MQTT, Modbus, APIs).
* PostgreSQL (TimescaleDB) storage for time-series analysis.
* Grafana dashboards for rich visualization.
* Node-RED automation flows.
* Flask API for external integrations.
* Fully containerized for easy deployment.

---

## System Architecture

![ENMS Architecture](docs/enms-architecture.png)


---

## 🚀 Quick Start

### 1️⃣ Clone the repository

```bash
git clone https://gitlab.com/raptorblingx/enms-project.git
cd enms-project
```

### 2️⃣ Create the environment file

The project uses a `.env` file to manage essential variables like database credentials and secrets. Create it by copying the template:

```bash
cp .env.example .env
```
*This file contains default credentials. For any non-local or production use, you should update the `MQTT_PASSWORD` and `NODE_RED_CREDENTIAL_SECRET` with your own secure values.*

### 3️⃣ Build & run the stack

```bash
docker compose up --build -d
```

### 4️⃣ Access services

| Service    | URL                                                                   |
| ---------- | --------------------------------------------------------------------- |
| Node-RED   | [http://localhost:1880](http://localhost:1880)                        |
| Grafana    | [http://localhost:3000](http://localhost:3000)                        |
| Web Server | [http://localhost/](http://localhost/)                                |
| Flask API  | [http://localhost/api/dpp\_summary](http://localhost/api/dpp_summary) |
| PostgreSQL | `localhost:5432` (user/pass in `.env`)                                |

---

## ⚙ Environment Variables

All user-configurable variables for the project are managed in a single `.env` file in the root of the repository. This file is not checked into source control and must be created locally.

To get started, simply copy the provided template:
```bash
cp .env.example .env
```
The `.env.example` file contains all the necessary variables with sensible default values for a local development environment.

**Important:** The default passwords and secrets in the `.env.example` file are for convenience only. You should change `MQTT_PASSWORD` and `NODE_RED_CREDENTIAL_SECRET` to your own secure, randomly generated strings before running the project in any non-local or production setting.

---

## 📦 Project Structure

```
enms-project/
│
├── backend/             # Backend services, including database initialization and ML model training
├── docs/                # Supporting documentation and architecture diagrams
├── frontend/            # Frontend HTML, CSS, and JavaScript files
├── grafana/             # Grafana provisioning (datasources, dashboards)
├── nginx/               # Nginx reverse proxy configuration
├── node-red/            # Node-RED flows, settings, and custom nodes
├── python-api/          # Python Flask application for the DPP API
├── artistic-resources/  # Image assets for the frontend
├── docker-compose.yml   # Main Docker Compose file for orchestrating services
├── ANALYSIS_DEEP_DIVE.md # Deep dive into the analysis engine & ML models
├── Custom Hardware.md # Details on custom sensor hardware (ESP32, etc.)
├── DPP_API_Documentation.md # Detailed developer documentation for the DPP API
├── ui_guide.md          # Guide to the user interface and user profiles
├── ENMS_Technical_Details.md # General project documentation
└── README.md            # This file
```

---

## 🧩 Included Services

* **Nginx** – Reverse proxy and web server for the frontend application.
* **Node-RED** – Low-code environment for data ingestion, processing, and automation flows.
* **PostgreSQL + TimescaleDB** – Optimized time-series database for storing sensor data.
* **Grafana** – Rich, real-time dashboards for visualizing system and sensor data.
* **Python API** – A Flask-based API for generating reports and other backend tasks.
* **Mosquitto** – A lightweight MQTT broker for real-time messaging between services.
* **ML Worker** – A Python service that runs machine learning models for predictive analytics.

---

## 📄 Documentation

*   For **The DPP API Reference**, see: 📖 [`DPP_API_Documentation.md`](./DPP_API_Documentation.md)
*   For **Technical Details** (architecture, data flows, deployment), see: 📜 [`ENMS_Technical_Details.md`](./ENMS_Technical_Details.md)
*   For a **Guide to the User Interface** and different user profiles, see: 👤 [`ui_guide.md`](./ui_guide.md)
*   For a **Deep Dive into the Analysis Engine and ML Model Training**, see: 🧠 [`ANALYSIS_DEEP_DIVE.md`](./ANALYSIS_DEEP_DIVE.md)
*   For a **Guide to the Interactive Analysis Feature**, see: 📊 [`INTERACTIVE_ANALYSIS_GUIDE.md`](./INTERACTIVE_ANALYSIS_GUIDE.md)
*   For **Details on the Custom Sensor Hardware** and connectivity, see: 🔩 [`Custom Hardware.md`](./Custom%20Hardware.md)

---

## 🛡 Zero-Touch Deployment

This project supports **zero-touch deployment**:

* All flows, settings, and dashboards are preloaded.
* No manual post-deployment configuration required.
* Ready to use immediately after `docker compose up`.

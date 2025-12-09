# Documentation and Resources Guide

**Human-Centric EnMS Project**  
*Comprehensive Documentation for Software, Hardware, and Reusability*

---

## 📋 Table of Contents

- [Overview](#overview)
- [Repository Access](#repository-access)
- [Software Documentation](#software-documentation)
- [Hardware Documentation](#hardware-documentation)
- [Bill of Materials (BOM)](#bill-of-materials-bom)
- [Code Resources](#code-resources)
- [Technical Manuals](#technical-manuals)
- [Reusability Guidelines](#reusability-guidelines)

---

## Overview

This document serves as a **comprehensive index** of all technical documentation, code repositories, hardware specifications, and resources for the **Human-Centric EnMS (Energy Management System)** project. It ensures complete transparency and reproducibility for all stakeholders, developers, and auditors.

The Human-Centric EnMS platform is an IoT-based, real-time energy monitoring and Digital Product Passport (DPP) generation system designed for additive manufacturing environments. All components are documented with sufficient detail to enable independent verification, modification, and deployment.

---

## Repository Access

### Official Repositories

**Primary Repository (GitHub):**
- **URL**: https://gitlab.com/lauds/enms-project
- **Purpose**: Main development repository with full version history
- **Access**: Public (Open Source)


**Demo:**
- **URL**: https://lauds-demo.intel50001.com
- **Purpose**: Live demonstration environment with simulated data

### Cloning the Repository

```bash
# Clone from Gitlab
git clone https://gitlab.com/lauds/enms-project.git
---

## Software Documentation

### Core Documentation Files

All documentation is located in the root directory of the repository in Markdown format:

| Document | File | Purpose |
|----------|------|---------|
| **User Guide** | `ui_guide.md` | Comprehensive guide to all software features, user profiles, and artistic visualizations |
| **README** | `README.md` | Quick start guide, installation instructions, and architecture overview |
| **API Documentation** | `DPP_API_Documentation.md` | Complete REST API reference for Digital Product Passport endpoints |
| **Technical Details** | `ENMS_Technical_Details.md` | System architecture, design decisions, and technical implementation details |
| **Analysis Deep Dive** | `ANALYSIS_DEEP_DIVE.md` | Machine learning models, feature engineering, and statistical analysis |
| **Interactive Analysis** | `INTERACTIVE_ANALYSIS_GUIDE.md` | Step-by-step guide for the interactive analysis feature |
| **Hardware Guide** | `Custom Hardware.md` | ESP32 sensor hub specifications, wiring diagrams, and integration guide |

### Documentation Coverage

The documentation provides:
- ✅ **Installation & Deployment**: Complete Docker Compose setup with zero-touch deployment
- ✅ **User Workflows**: Three distinct user profiles (Technical, Staff, DPP) with role-specific features
- ✅ **API Specifications**: All REST endpoints with request/response schemas
- ✅ **Database Schema**: PostgreSQL + TimescaleDB table structures and relationships
- ✅ **ML Model Training**: Data preprocessing, feature engineering, model selection, and evaluation
- ✅ **Frontend Architecture**: HTML/CSS/JavaScript structure and component interactions
- ✅ **Backend Workflows**: Node-RED flows, MQTT topics, and data pipelines
- ✅ **Custom Hardware**: Sensor specifications, firmware, and MQTT integration

---

## Hardware Documentation

### Custom Hardware Components

**Location**: `Custom Hardware.md`

The system integrates custom IoT sensor hubs for enhanced monitoring capabilities beyond standard 3D printer APIs.

#### ESP32 Sensor Hub

**Purpose**: Real-time environmental and operational monitoring

**Main Components:**
1. **ESP32 Microcontroller**
   - **Model**: ESPDuino-32 ESP32 WiFi and Bluetooth Development Board
   - **Purpose**: WiFi-enabled dual-core processor for sensor data collection and MQTT publishing
   - **Quick Spec**: 
    - Input Voltage 7-12V (recommended)
    - IO Pins are 3.3V and not 5V
    - Arduino UNO Architecture
    - Soft Serial or Hardware Serial Connection
    - Integrated ESP-Wroom-32 Wifi Module
   - **Firmware**: Custom C++ code for sensor polling and MQTT communication

2. **MPU6050 (6-Axis IMU)**
   - **Purpose**: 3-axis accelerometer + 3-axis gyroscope for vibration analysis
   - **Use Case**: Operational state detection (Printing/Idle/Off), predictive maintenance
   - **Interface**: I2C
   - **Output**: Acceleration (g), Angular velocity (°/s)

3. **MAX6675 Thermocouple Amplifier**
   - **Purpose**: High-precision temperature measurement via K-type thermocouple
   - **Temperature Range**: 0°C to 1024°C
   - **Resolution**: 0.25°C
   - **Interface**: SPI
   - **Use Case**: Hotend, bed, or enclosure temperature monitoring

4. **DHT22 Sensor**
   - **Purpose**: Ambient temperature and humidity monitoring
   - **Temperature Range**: -40°C to 80°C (±0.5°C)
   - **Humidity Range**: 0-100% RH (±2%)
   - **Interface**: Single-wire digital
   - **Use Case**: Environmental condition tracking for print quality correlation

**Connectivity:**
- **Protocol**: MQTT over WiFi
- **MQTT Topics**:
  - `enms/sensor/<device_id>/accel` - Accelerometer data
  - `enms/sensor/<device_id>/gyro` - Gyroscope data
  - `enms/sensor/<device_id>/ambient` - DHT22 temperature/humidity
  - `enms/sensor/<device_id>/thermocouple` - MAX6675 temperature

**Data Flow:**
```
ESP32 Sensors → WiFi → MQTT Broker (Mosquitto) → Node-RED → PostgreSQL (TimescaleDB)
```

**Visual Reference:**
- Sensor Hub Photo: `docs/Sensor Hub.png`
- MAX6675 Module: `docs/MAX6675.png`

---

## Bill of Materials (BOM)

### ESP32 Sensor Hub - Hardware Components

| Quantity | Component | Model/Type | Purpose |
|----------|-----------|------------|---------|
| 1 | Microcontroller | ESP32-WROOM-32 Development Board | Main processor with WiFi |
| 1 | Accelerometer/Gyroscope | MPU6050 6-Axis IMU Module | Vibration and motion detection |
| 1 | Thermocouple Amplifier | MAX6675 K-Type Module | High-temperature measurement |
| 1 | K-Type Thermocouple | Standard K-Type Probe | Temperature sensor probe |
| 1 | Temperature/Humidity Sensor | DHT22 (AM2302) | Ambient environmental monitoring |
| 1 | Breadboard or PCB | Standard 830-point breadboard or custom PCB | Component mounting |
| - | Jumper Wires | Male-to-Male and Male-to-Female | Connections |
| 1 | Power Supply | 5V 2A USB Power Adapter | ESP32 power source |
| 1 | USB Cable | Micro-USB or USB-C (depending on ESP32 board) | Programming and power |

**Notes:**
- PCB design files can be created for production runs (currently breadboard prototype)

### Software Components (Free/Open Source)

| Component | License | Purpose |
|-----------|---------|---------|
| Docker & Docker Compose | Apache 2.0 | Container orchestration |
| PostgreSQL + TimescaleDB | PostgreSQL License | Time-series database |
| Node-RED | Apache 2.0 | Data flow automation |
| Grafana | AGPL v3 | Visualization dashboards |
| Mosquitto MQTT Broker | EPL/EDL | Message broker |
| Python Flask | BSD-3-Clause | REST API service |
| Nginx | 2-clause BSD | Web server and reverse proxy |
| WeasyPrint | BSD-3-Clause | PDF generation |

### Optional Hardware

| Component | Purpose |
|-----------|---------|
| Raspberry Pi 4 (4GB) | Bridge for legacy printers via OctoPrint |
| Shelly Plug S | Smart plug for power monitoring |

---

## Code Resources

### Repository Structure

```
enms-project/
├── backend/
│   ├── db_init/              # PostgreSQL initialization scripts
│   │   ├── 01_schema.sql     # Database schema (tables, hypertables)
│   │   ├── 02_data.sql       # Sample data and initial records
│   │   ├── 03_functions.sql  # Custom SQL functions and triggers
│   │   └── 04_auth_schema.sql # Authentication tables
│   ├── train_model.py        # Model training pipeline
│   ├── prediction_worker_mqtt.py # Real-time prediction worker
│   ├── export_training_data.py # Training data export
│   └── models/               # ML model artifacts directory
│
├── frontend/
│   ├── index.html            # Main UI entry point
│   ├── dpp_page.html         # Digital Product Passport carousel
│   ├── device_management.html # Printer fleet configuration
│   ├── auth.html             # Login/registration page
│   ├── analysis/             # Interactive analysis feature
│   └── components/           # Reusable UI components
│
├── grafana/
│   ├── provisioning/
│   │   ├── datasources/      # TimescaleDB datasource config
│   │   └── dashboards/       # Dashboard provisioning
│   └── dashboards/           # JSON dashboard definitions
│       ├── fleet-operations.json
│       ├── Machine-Performance-Comparison.json
│       ├── Industrial-Hybrid-Edge-System.json
│       ├── Sensor-Data-Explorer.json
│       └── esp32.json
│
├── node-red/
│   ├── flows.json            # Node-RED flow definitions
│   ├── settings.js           # Node-RED configuration
│   └── nodes/                # Custom Node-RED nodes
│
├── python-api/
│   ├── app.py                # Flask application entry point
│   ├── dpp_simulator.py      # DPP data generation logic
│   ├── pdf_service.py        # PDF report generation
│   ├── gcode_analyzer.py     # G-code metadata extraction
│   └── templates/            # HTML templates for PDF reports
│
├── nginx/
│   └── conf.d/
│       └── default.conf      # Nginx routing configuration
│
├── artistic-resources/
│   └── plants/               # Energy plant visualization images
│       ├── potato/           # 21 growth stages
│       ├── corn/             # 8 growth stages
│       ├── corn_2/           # 12 growth stages
│       └── corn_3/           # 7 growth stages
│
└── docker-compose.yml        # Complete service orchestration
```

### Key Source Files

**Database Schema:**
- `backend/db_init/01_schema.sql` - Complete table definitions, indexes, and hypertables

**Backend API:**
- `python-api/app.py` - REST API endpoints
- `python-api/dpp_simulator.py` - Energy plant stage calculation, DPP data aggregation
- `python-api/pdf_service.py` - WeasyPrint PDF generation with plant images

**Frontend:**
- `frontend/index.html` - Profile selection and main dashboard
- `frontend/dpp_page.html` - Interactive 3D carousel
- `frontend/analysis/analysis_page.js` - Statistical analysis and ML feature importance

**Data Pipeline:**
- `node-red/flows.json` - Complete data ingestion, transformation, and routing logic

**Machine Learning:**
- `backend/train_model.py` - Model training pipeline (XGBoost, RandomForest, LightGBM)
- `backend/prediction_worker_mqtt.py` - Real-time energy prediction worker

---

## Technical Manuals

### Installation Manual

#### Prerequisites

- **Docker Engine**: Version 20.10 or higher
- **Docker Compose**: Version 2.0 or higher
- **System Resources**: 
  - RAM: 4GB minimum (8GB recommended)
  - Storage: 20GB free disk space
  - OS: Linux (Ubuntu 20.04+), macOS, or Windows with WSL2

#### Installation Steps

**1. Clone the Repository**
```bash
git clone https://gitlab.com/lauds/enms-project.git
cd enms-project
```

**2. Configure Environment Variables**

Create the environment file from the provided template:
```bash
cp .env.example .env
```

Edit `.env` with your preferred text editor and update the following critical variables:
- `MQTT_PASSWORD` - Set a secure password for MQTT broker
- `NODE_RED_CREDENTIAL_SECRET` - Generate a random secret key
- `POSTGRES_PASSWORD` - Set database password (default: `enms_pass`)

**3. Build and Start All Services**
```bash
docker compose up --build -d
```

This command will:
- Download all required Docker images
- Build custom images for Node-RED and Python services
- Initialize PostgreSQL database with schema and sample data
- Configure MQTT broker with authentication
- Start all services in detached mode

**4. Verify Deployment**
```bash
docker compose ps
```

All services should show status as "Up" or "running".

**5. Access the Application**

| Service | URL | Default Credentials |
|---------|-----|-------------------|
| Main UI | http://localhost:8090 | demo / demo123 |
| Node-RED | http://localhost:1882 | (see `.env`) |
| Grafana | http://localhost:3000 | admin / (see `.env`) |
| PostgreSQL | localhost:5432 | enms_user / (see `.env`) |

**Estimated Setup Time**: 10-15 minutes (depending on internet speed)

#### Post-Installation Configuration

**Add Devices**: Navigate to Device Management page and add your 3D printers
**Import Grafana Dashboards**: Dashboards are auto-provisioned on first startup
**Configure SimplyPrint Integration**: Add your SimplyPrint API credentials in Node-RED settings

---

### User Manual

#### System Overview

The Human-Centric EnMS platform provides three distinct user interfaces tailored to different roles:

**1. Technical Profile**
- **Purpose**: Detailed operational monitoring and analysis
- **Features**:
  - Real-time printer status dashboard
  - Energy consumption analytics
  - Machine performance comparison
  - Sensor data visualization
  - Interactive analysis tools

**2. Staff Profile**
- **Purpose**: Simplified monitoring for operations staff
- **Features**:
  - Fleet status overview
  - Active job monitoring
  - Energy plant visualizations (artistic representation)
  - Simplified metrics

**3. DPP (Digital Product Passport) Profile**
- **Purpose**: Product-focused documentation and traceability
- **Features**:
  - 3D carousel of completed jobs
  - PDF report generation
  - G-code preview and analysis
  - Energy footprint per product
  - Environmental impact visualization

#### Key Features

**Energy Plant Visualizations**

The system uses an artistic metaphor where energy consumption is visualized as a growing plant:
- **potato** - 21 growth stages (high-energy products)
- **corn** - 8 growth stages (standard products)
- **corn_2** - 12 growth stages (medium products)
- **corn_3** - 7 growth stages (small products)

Each stage represents a threshold of energy consumption, making sustainability tangible and engaging.

**PDF Report Generation**

Users can generate comprehensive reports including:
- Job metadata (duration, material, settings)
- Energy consumption breakdown
- 3D G-code preview rendering
- Environmental impact metrics
- Growth stage visualization

**Interactive Analysis**

Advanced statistical analysis tools:
- Feature importance visualization
- Correlation matrices
- Energy prediction models
- Performance trend analysis

---

### Developer Manual

#### System Architecture

The Human-Centric EnMS follows a microservices architecture with the following components:

**Data Flow:**
```
3D Printers → SimplyPrint API → Node-RED → PostgreSQL (TimescaleDB)
                                    ↓
ESP32 Sensors → MQTT → Node-RED → PostgreSQL
                                    ↓
                              Python API ← Frontend (Web Browser)
                                    ↓
                                 Grafana
```

#### API Specifications

**Base URL**: `http://localhost:8090/api`

**Key Endpoints:**

1. **GET /dpp_summary**
   - Returns list of all completed print jobs
   - Response: Array of job objects with metadata

2. **GET /dpp_report_data/:job_id**
   - Returns detailed data for specific job
   - Includes energy metrics, plant visualization stage, G-code preview

3. **POST /generate_pdf**
   - Generates PDF report for specified job
   - Returns PDF file for download

4. **GET /devices**
   - Returns list of all registered devices
   - Includes device status and configuration

5. **POST /devices**
   - Registers new device
   - Request body: device_id, model, friendly_name, etc.

**Authentication**: Session-based authentication with username/password

#### Database Schema

**Core Tables:**

1. **devices** - Printer fleet registry
   - `device_id` (PK) - Unique printer identifier
   - `device_model` - Printer model
   - `friendly_name` - Display name
   - `simplyprint_id` - SimplyPrint integration ID
   - `location` - Physical location

2. **print_jobs** - Completed print job records
   - `job_id` (PK) - Auto-incrementing job ID
   - `device_id` (FK) - References devices
   - `start_time`, `end_time` - Job duration
   - `energy_kwh` - Total energy consumed
   - `material_used_grams` - Filament weight

3. **energy_readings** (Hypertable) - Time-series energy data
   - `time` - Timestamp (indexed by TimescaleDB)
   - `device_id` (FK) - References devices
   - `power_w` - Instantaneous power reading
   - `cumulative_kwh` - Running total

4. **sensor_data** (Hypertable) - ESP32 sensor readings
   - `time` - Timestamp
   - `device_id` (FK)
   - `accel_x`, `accel_y`, `accel_z` - Accelerometer data
   - `gyro_x`, `gyro_y`, `gyro_z` - Gyroscope data
   - `temperature`, `humidity` - Environmental sensors

#### MQTT Topics

**Published by ESP32 Sensors:**
- `enms/sensor/<device_id>/accel` - Accelerometer data (JSON)
- `enms/sensor/<device_id>/gyro` - Gyroscope data (JSON)
- `enms/sensor/<device_id>/ambient` - DHT22 temperature/humidity
- `enms/sensor/<device_id>/thermocouple` - MAX6675 temperature

**Message Format Example:**
```json
{
  "device_id": "ender3_01",
  "timestamp": "2025-12-09T10:30:00Z",
  "accel_x": 0.12,
  "accel_y": -0.05,
  "accel_z": 9.81
}
```

#### Machine Learning Models

**Training Pipeline:**
1. Data extraction from TimescaleDB
2. Feature engineering (rolling averages, variance, time-based features)
3. Model training with cross-validation
4. Model selection (XGBoost, RandomForest, LightGBM)
5. Serialization with joblib

**Features Used:**
- Print duration
- Layer height
- Infill percentage
- Print temperature
- Print speed
- Material type
- Bed temperature

**Target Variable**: `energy_kwh` (total energy consumption)

---

### Hardware Integration Manual

#### ESP32 Sensor Hub Setup

**Required Hardware:**
- ESP32 development board (ESPDuino-32 recommended)
- MPU6050 6-axis IMU module
- MAX6675 thermocouple amplifier
- K-type thermocouple probe
- DHT22 temperature/humidity sensor
- Breadboard and jumper wires
- 5V USB power adapter

**Wiring Diagram:**

**MPU6050 (I2C):**
- VCC → ESP32 3.3V
- GND → ESP32 GND
- SCL → ESP32 GPIO 22
- SDA → ESP32 GPIO 21

**MAX6675 (SPI):**
- VCC → ESP32 3.3V
- GND → ESP32 GND
- SCK → ESP32 GPIO 18
- CS → ESP32 GPIO 5
- SO → ESP32 GPIO 19

**DHT22:**
- VCC → ESP32 3.3V
- GND → ESP32 GND
- DATA → ESP32 GPIO 4

**Firmware Configuration:**

Edit the Arduino sketch with your WiFi and MQTT credentials:
```cpp
const char* ssid = "Your_WiFi_SSID";
const char* password = "Your_WiFi_Password";
const char* mqtt_server = "your_mqtt_broker_ip";
const char* mqtt_user = "enms_mqtt_user";
const char* mqtt_pass = "your_mqtt_password";
```

**Upload Firmware:**
1. Install Arduino IDE
2. Add ESP32 board support (ESP32 Board Manager URL)
3. Install libraries: MPU6050, MAX6675, DHT, PubSubClient
4. Compile and upload sketch to ESP32
5. Open Serial Monitor to verify connection

**Troubleshooting:**
- **WiFi not connecting**: Verify SSID/password, check 2.4GHz band
- **MQTT publish fails**: Confirm broker IP, check firewall rules
- **Sensor not detected**: Verify wiring, check I2C address with scanner
- **MAX6675 reads 0**: Ensure thermocouple polarity is correct

---



## Software Code Documentation

### Docker Compose Configuration

The complete system orchestration is defined in `docker-compose.yml`:

```yaml
services:
  postgres:
    image: timescale/timescaledb:latest-pg16
    container_name: enms_postgres
    restart: unless-stopped
    environment:
      - POSTGRES_DB=${POSTGRES_DB}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./backend/db_init:/docker-entrypoint-initdb.d
    ports:
      - "${POSTGRES_PORT}:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]
      interval: 10s
      timeout: 5s
      retries: 5

  mosquitto:
    image: eclipse-mosquitto:2
    container_name: enms_mosquitto
    restart: unless-stopped
    ports:
      - "1884:1883"
    volumes:
      - mosquitto_config:/mosquitto/config
      - mosquitto_data:/mosquitto/data

  nodered:
    build:
      context: .
      dockerfile: ./node-red/Dockerfile
    container_name: enms_nodered
    restart: unless-stopped
    ports:
      - "1882:1880"
    volumes:
      - ./node-red:/data
      - ./backend/models:/models
    environment:
      - POSTGRES_DB=${POSTGRES_DB}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - MQTT_BROKER_HOST=${MQTT_BROKER_HOST}
      - MQTT_USERNAME=${MQTT_USERNAME}
      - MQTT_PASSWORD=${MQTT_PASSWORD}
    depends_on:
      - postgres
      - mosquitto

  python-api:
    build:
      context: ./python-api
    container_name: enms_python_api
    restart: unless-stopped
    environment:
      - DATABASE_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}
    volumes:
      - generated_pdfs:/app/generated_pdfs
      - ./artistic-resources:/app/artistic-resources
    depends_on:
      - postgres

  grafana:
    image: grafana/grafana:latest
    container_name: enms_grafana
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_ADMIN_PASSWORD}
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana/provisioning:/etc/grafana/provisioning
      - ./grafana/dashboards:/var/lib/grafana/dashboards
    depends_on:
      - postgres

  nginx:
    image: nginx:alpine
    container_name: enms_nginx
    restart: unless-stopped
    ports:
      - "8090:80"
    volumes:
      - ./frontend:/usr/share/nginx/html
      - ./nginx/conf.d:/etc/nginx/conf.d
      - generated_pdfs:/usr/share/nginx/html/generated_pdfs
    depends_on:
      - python-api
```

### Database Schema (PostgreSQL + TimescaleDB)

Key table definitions from `backend/db_init/01_schema.sql`:

```sql
-- Devices table: Printer fleet registry
CREATE TABLE public.devices (
    device_id text NOT NULL PRIMARY KEY,
    device_model text NOT NULL,
    friendly_name text,
    location text,
    simplyprint_id text,
    api_key text,
    bed_width integer,
    bed_depth integer,
    last_seen timestamp with time zone
);

-- Print jobs table
CREATE TABLE public.print_jobs (
    job_id integer NOT NULL PRIMARY KEY,
    device_id text NOT NULL REFERENCES public.devices(device_id),
    simplyprint_job_id text,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    duration_seconds integer,
    filename text,
    filament_used_grams real,
    energy_kwh real,
    cost_estimate real,
    status text,
    thumbnail_url text
);

-- Energy readings (TimescaleDB hypertable)
CREATE TABLE public.energy_readings (
    time timestamp with time zone NOT NULL,
    device_id text NOT NULL REFERENCES public.devices(device_id),
    power_w real,
    cumulative_kwh real,
    voltage real,
    current real
);

-- Convert to hypertable for time-series optimization
SELECT create_hypertable('public.energy_readings', 'time', if_not_exists => TRUE);

-- Sensor data (TimescaleDB hypertable)
CREATE TABLE public.sensor_data (
    time timestamp with time zone NOT NULL,
    device_id text NOT NULL REFERENCES public.devices(device_id),
    sensor_type text,
    accel_x real,
    accel_y real,
    accel_z real,
    gyro_x real,
    gyro_y real,
    gyro_z real,
    temperature real,
    humidity real,
    thermocouple_temp real
);

SELECT create_hypertable('public.sensor_data', 'time', if_not_exists => TRUE);

-- Create indexes for performance
CREATE INDEX idx_energy_device_time ON public.energy_readings (device_id, time DESC);
CREATE INDEX idx_sensor_device_time ON public.sensor_data (device_id, time DESC);
CREATE INDEX idx_jobs_device ON public.print_jobs (device_id);
CREATE INDEX idx_jobs_time ON public.print_jobs (start_time DESC);
```

### Python Flask API

Core API implementation from `python-api/app.py`:

```python
from flask import Flask, jsonify, request, send_file
import psycopg2
from psycopg2.extras import RealDictCursor
import os

app = Flask(__name__)

# Database connection
def get_db_connection():
    conn = psycopg2.connect(os.environ['DATABASE_URL'])
    return conn

# Get all completed jobs for DPP carousel
@app.route('/api/dpp_summary', methods=['GET'])
def dpp_summary():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    query = """
        SELECT 
            job_id, device_id, filename, start_time, end_time,
            duration_seconds, filament_used_grams, energy_kwh,
            thumbnail_url, status
        FROM print_jobs
        WHERE status = 'completed'
        ORDER BY end_time DESC
        LIMIT 50
    """
    
    cursor.execute(query)
    jobs = cursor.fetchall()
    cursor.close()
    conn.close()
    
    return jsonify(jobs)

# Get detailed report data for specific job
@app.route('/api/dpp_report_data/<int:job_id>', methods=['GET'])
def dpp_report_data(job_id):
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    # Get job details
    cursor.execute("SELECT * FROM print_jobs WHERE job_id = %s", (job_id,))
    job = cursor.fetchone()
    
    # Get energy data for job duration
    cursor.execute("""
        SELECT time, power_w, cumulative_kwh
        FROM energy_readings
        WHERE device_id = %s 
        AND time BETWEEN %s AND %s
        ORDER BY time
    """, (job['device_id'], job['start_time'], job['end_time']))
    
    energy_data = cursor.fetchall()
    
    # Calculate plant visualization stage
    energy_kwh = job['energy_kwh'] or 0
    plant_type, stage = calculate_plant_stage(energy_kwh)
    
    cursor.close()
    conn.close()
    
    return jsonify({
        'job': job,
        'energy_data': energy_data,
        'plant_type': plant_type,
        'plant_stage': stage
    })

# Plant stage calculation
def calculate_plant_stage(energy_kwh):
    # Potato: 21 stages (high energy)
    if energy_kwh > 5.0:
        stage = min(int(energy_kwh / 0.5), 21)
        return 'potato', stage
    # Corn: 8 stages (standard)
    elif energy_kwh > 2.0:
        stage = min(int((energy_kwh - 2.0) / 0.4), 8)
        return 'corn', stage
    # Corn_2: 12 stages (medium)
    elif energy_kwh > 0.5:
        stage = min(int((energy_kwh - 0.5) / 0.15), 12)
        return 'corn_2', stage
    # Corn_3: 7 stages (small)
    else:
        stage = min(int(energy_kwh / 0.1), 7)
        return 'corn_3', stage

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

### ESP32 Sensor Hub Firmware

Arduino sketch for ESP32 sensor hub:

```cpp
#include <WiFi.h>
#include <PubSubClient.h>
#include <Wire.h>
#include <MPU6050.h>
#include <MAX6675.h>
#include <DHT.h>

// WiFi credentials
const char* ssid = "Your_WiFi_SSID";
const char* password = "Your_WiFi_Password";

// MQTT Configuration
const char* mqtt_server = "your_mqtt_broker_ip";
const int mqtt_port = 1884;
const char* mqtt_user = "enms_mqtt_user";
const char* mqtt_pass = "your_mqtt_password";

// Device configuration
const char* device_id = "ender3_01";

// Sensor objects
MPU6050 mpu;
MAX6675 thermocouple(18, 5, 19); // SCK, CS, SO pins
DHT dht(4, DHT22);

WiFiClient espClient;
PubSubClient client(espClient);

void setup() {
  Serial.begin(115200);
  Wire.begin(21, 22); // SDA, SCL
  
  // Initialize sensors
  mpu.initialize();
  dht.begin();
  
  // Connect to WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("WiFi connected");
  
  // Configure MQTT
  client.setServer(mqtt_server, mqtt_port);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
  
  // Read sensors every 5 seconds
  static unsigned long last_read = 0;
  if (millis() - last_read > 5000) {
    publishSensorData();
    last_read = millis();
  }
}

void reconnect() {
  while (!client.connected()) {
    if (client.connect(device_id, mqtt_user, mqtt_pass)) {
      Serial.println("MQTT connected");
    } else {
      delay(5000);
    }
  }
}

void publishSensorData() {
  // Read MPU6050
  int16_t ax, ay, az, gx, gy, gz;
  mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
  
  // Publish accelerometer
  char topic[100];
  char payload[200];
  
  snprintf(topic, 100, "enms/sensor/%s/accel", device_id);
  snprintf(payload, 200, "{\"x\":%.2f,\"y\":%.2f,\"z\":%.2f}", 
           ax/16384.0, ay/16384.0, az/16384.0);
  client.publish(topic, payload);
  
  // Publish gyroscope
  snprintf(topic, 100, "enms/sensor/%s/gyro", device_id);
  snprintf(payload, 200, "{\"x\":%.2f,\"y\":%.2f,\"z\":%.2f}", 
           gx/131.0, gy/131.0, gz/131.0);
  client.publish(topic, payload);
  
  // Read DHT22
  float temp = dht.readTemperature();
  float humidity = dht.readHumidity();
  
  snprintf(topic, 100, "enms/sensor/%s/ambient", device_id);
  snprintf(payload, 200, "{\"temperature\":%.1f,\"humidity\":%.1f}", 
           temp, humidity);
  client.publish(topic, payload);
  
  // Read MAX6675
  float thermocouple_temp = thermocouple.readCelsius();
  snprintf(topic, 100, "enms/sensor/%s/thermocouple", device_id);
  snprintf(payload, 200, "{\"temperature\":%.2f}", thermocouple_temp);
  client.publish(topic, payload);
}
```

---

## Reusability Guidelines

### Customization Points

**Easy Modifications:**
- ✅ Adding new plant types (artistic visualizations)
- ✅ Configuring energy thresholds for plant stages
- ✅ Customizing Grafana dashboards
- ✅ Modifying PDF report templates
- ✅ Adding new printer models to device management

**Intermediate Modifications:**
- ⚙️ Creating custom Node-RED flows for different data sources
- ⚙️ Adding new sensor types to ESP32 hub
- ⚙️ Extending REST API with new endpoints
- ⚙️ Implementing additional ML models

### Deployment Scenarios

**Scenario 1: Small Workshop (1-5 printers)**
- Deploy on single server or workstation
- Use default Docker Compose configuration
- No clustering required
- Estimated hardware: 8GB RAM, 4-core CPU

**Scenario 2: Medium Facility (10-50 printers)**
- Deploy on dedicated server
- Scale Node-RED workers
- Add Grafana read replicas
- Estimated hardware: 16GB RAM, 8-core CPU

**Scenario 3: Enterprise (50+ printers)**
- Multi-node deployment
- PostgreSQL clustering (TimescaleDB multi-node)
- Load-balanced Nginx
- Distributed MQTT brokers
- Kubernetes orchestration recommended

### Extensibility Examples

1. **New Printer Integrations**: Custom printer types can be added through device management
2. **Custom Sensors**: ESP32 firmware can be extended with additional I2C/SPI devices
3. **Alternative Databases**: Node-RED flows can be modified to support InfluxDB, MongoDB, etc.
4. **Custom Visualizations**: 3D rendering can be extended for alternative file formats (STL, OBJ)

### Code Modification Examples

**Adding a New Plant Type:**
1. Add images to `artistic-resources/plants/new_plant/` (sequential stages: 01.png, 02.png, etc.)
2. Update `python-api/dpp_simulator.py`:
```python
def calculate_plant_stage(energy_kwh):
    if energy_kwh > 10.0:  # New threshold
        stage = min(int(energy_kwh / 0.8), 15)
        return 'new_plant', stage
    # ... existing logic
```
3. Rebuild Python API container

**Adding a New API Endpoint:**
```python
@app.route('/api/custom_metric/<device_id>', methods=['GET'])
def custom_metric(device_id):
    # Your custom logic
    return jsonify({'result': 'data'})
```

**Adding a New Sensor Type:**
```cpp
// In ESP32 firmware
#include <NewSensor.h>
NewSensor sensor(pin);

void publishNewSensor() {
  float value = sensor.read();
  snprintf(topic, 100, "enms/sensor/%s/new_sensor", device_id);
  snprintf(payload, 200, "{\"value\":%.2f}", value);
  client.publish(topic, payload);
}
```

---

## Verification and Testing

### Functional Tests

**Location**: `backend/` (various test scripts)

**Run Tests:**
```bash
# Database schema verification
docker exec -it enms_postgres psql -U enms_user -d enms_db -f /docker-entrypoint-initdb.d/01_schema.sql

# ML model validation
python backend/train_model.py
```

### Data Integrity

**Database Migrations**: All schema changes are versioned in `backend/db_init/` with sequential numbering

**Backup/Restore**:
```bash
# Backup database
docker exec enms_postgres pg_dump -U enms_user enms_db > backup.sql

# Restore database
docker exec -i enms_postgres psql -U enms_user enms_db < backup.sql
```

---

## Support and Contribution

### Getting Help

**Documentation Issues**: Open an issue on GitHub with label `documentation`
**Bug Reports**: Use issue template with reproduction steps
**Feature Requests**: Submit enhancement proposals via GitHub Discussions

### Contributing

**Pull Request Process**:
1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes with descriptive messages
4. Push to branch
5. Open Pull Request with detailed description

**Code Standards**:
- Python: PEP 8 compliance
- JavaScript: ES6+ with consistent formatting
- SQL: Uppercase keywords, consistent indentation
- Markdown: Follow existing documentation style

---

## Appendix: Quick Reference

### Essential Commands

```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f [service_name]

# Stop all services
docker compose down

# Rebuild after code changes
docker compose up --build -d

# Access database
docker exec -it enms_postgres psql -U enms_user -d enms_db

# Check service health
docker compose ps
```

### Service URLs (Default Configuration)

| Service | URL | Default Credentials |
|---------|-----|-------------------|
| Main UI | http://localhost:8090 | demo / demo123 |
| Node-RED | http://localhost:1882 | (see `.env`) |
| Grafana | http://localhost:3000 | admin / (see `.env`) |
| PostgreSQL | localhost:5432 | enms_user / (see `.env`) |
| MQTT | localhost:1884 | (see `.env`) |

### Important Files

| Purpose | File Path |
|---------|-----------|
| Environment Config | `.env` (create from `.env.example`) |
| Database Schema | `backend/db_init/01_schema.sql` |
| Main Dashboard | `grafana/dashboards/fleet-operations.json` |
| API Endpoints | `python-api/app.py` |
| Data Flows | `node-red/flows.json` |

---

**Document Version**: 1.0  
**Last Updated**: 2025-12-09  
**Maintainer**: ENMS Development Team  

---

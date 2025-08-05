# ENMS - Energy Management System for 3D Printers

This repository contains the full-stack application for the LAUDS Open Call 1 Energy Management project. The system is designed to ingest, store, and visualize energy and operational data from a fleet of 3D printers.

The entire stack is containerized using Docker and Docker Compose, allowing for easy deployment and development.

---

## Service Overview

The application consists of several services managed by Docker Compose:

| Service | Host Port | Description |
| :--- | :--- | :--- |
| **Web Server (Nginx)** | `80` | Serves the main frontend UI (DPP, Analysis) and acts as a reverse proxy for APIs. |
| **Node-RED** | `1880` | The core processing engine. The editor is available for debugging. |
| **Grafana** | `3000` | Provides dashboards for monitoring and visualization. |
| **PostgreSQL** | `5432` | The main database for all time-series and relational data. |

---

## Quick Start (Production Deployment)

These instructions are for deploying the application on a server (e.g., for Axel).

### Prerequisites
*   Git
*   Docker Engine (v20.10+)
*   Docker Compose (v1.29+)

### Steps

1.  **Clone the Repository**
    ```bash
    git clone git@gitlab.com:raptorblingx/enms-project.git
    cd enms-project
    ```

2.  **Start the Application**
    Use Docker Compose to build the images and start all services in the background.
    ```bash
    # Use sudo if your user doesn't have Docker permissions
    sudo docker-compose up --build -d
    ```
    *   `--build`: Required on the first run to build the service images.
    *   `-d`: Runs the containers in detached (background) mode.

3.  **Access the System**
    Once the containers are running, the system will be available at the following URLs:
    *   **Main Application:** `http://<your-server-ip>`
    *   **Grafana:** `http://<your-server-ip>:3000` (Default login: admin / admin)
    *   **Node-RED Editor:** `http://<your-server-ip>:1880`

---

## Developer Setup

These instructions are for developers running the system locally for code changes.

### Prerequisites
*   Git
*   Docker Engine
*   Docker Compose

### Steps

1.  **Clone the Repository and Start**
    Follow the same steps as the production deployment, but start the system in the foreground to see live logs from all services.
    ```bash
    git clone [your-gitlab-repo-url.git]
    cd enms-project
    docker-compose up --build
    ```

2.  **Live Development**
    This project uses a `docker-compose.override.yml` file to enable live code reloading.
    *   Any changes you save to files in the `/frontend`, `/backend`, `/node-red`, or `/nginx` directories on your local machine will be immediately reflected inside the running containers.
    *   There is no need to run `docker-compose build` again unless you change the `Dockerfile` or `package.json` / `requirements.txt` files.

3.  **Stopping the System**
    To stop all running services, press `Ctrl+C` in the terminal where `docker-compose up` is running. To clean up all containers and volumes, run `docker-compose down -v`.

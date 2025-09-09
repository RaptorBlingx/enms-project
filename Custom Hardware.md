# Custom Hardware and Connectivity

This document outlines the specialized hardware and connectivity solutions used in the ENMS project. It is intended to provide a clear understanding for new developers and external partners of how we interface with our 3D printers and gather supplementary data.

## The Core: SimplyPrint.io Cloud Platform

At the heart of our printer management strategy is **SimplyPrint.io**, a cloud-based platform. It serves as the central hub for controlling and monitoring all 3D printers in our fleet, regardless of their original manufacturer or capabilities. Our backend system, driven by Node-RED, exclusively communicates with the SimplyPrint API to fetch all printer status, job history, and control printers. This centralized approach simplifies our architecture significantly.

## Raspberry Pi 4 with OctoPrint: The Bridge for Legacy Printers

**Problem:** Many of our 3D printers (e.g., Ender-3) are excellent workhorses but lack modern networking capabilities like WiFi or Ethernet. They typically only have a USB port for direct connection.

**Solution:** To integrate these "offline" printers into our cloud-based system, we use a **Raspberry Pi 4 running the OctoPi operating system**. OctoPi is a pre-configured distribution of the popular OctoPrint server.

**Role and Data Flow:**
In our setup, the Raspberry Pi 4's role is exclusively that of a **bridge**. It connects to the legacy printer via USB and uses its own network connection to link the printer to the SimplyPrint.io cloud service.

The data flow is as follows:
`Legacy 3D Printer -> (USB) -> Raspberry Pi 4 (OctoPrint) -> (Internet) -> SimplyPrint.io Cloud`

It is crucial to understand that our backend system **does not** interact with the OctoPrint API. Instead, Node-RED polls the **SimplyPrint API**, which provides a unified interface for all printers. The OctoPrint instance is simply a hardware driver, making the legacy printer visible to the cloud platform we use.

## ESP32 Sensor Hub: Environmental and Operational Insights
![Sensor Hub](docs/Sensor%20Hub.png)

**Problem:** Standard printer APIs, including SimplyPrint's, provide essential data like temperatures and job progress, but they don't offer insights into the machine's physical environment or its operational vibrations.

**Solution:** To capture this valuable data, we have developed a custom **ESP32-based sensor hub**. This small, low-power microcontroller is equipped with a suite of sensors and placed near the 3D printer.

**Data Transmission:**
The ESP32 hub connects to our local WiFi network and sends all sensor readings to our Node-RED instance via the **MQTT protocol**. Each sensor publishes its data to a unique MQTT topic, allowing for easy and reliable ingestion.

### Onboard Sensors and Their Purpose

The ESP32 Sensor Hub includes the following components:

*   **MPU6050 (Accelerometer & Gyroscope):**
    *   **Purpose:** This sensor measures vibration and changes in orientation. By analyzing the vibration patterns, we can determine the printer's real-time operational state with high accuracy (e.g., `Printing`, `Idle`, `Off`).
    *   **Future Potential:** This data is foundational for future enhancements. With further development, these vibration signatures can be used to implement advanced features like automated print failure detection, predictive maintenance alerts, and quality assurance monitoring.

*   **MAX6675 with K-Type Thermocouple:**
    *   **Purpose:** The MAX6675 is a specialized amplifier that allows the ESP32 to read temperatures from a K-type thermocouple. This provides highly accurate and responsive temperature readings, which can be used to monitor critical components like the printer's hotend or enclosure temperature.
![Sensor Hub](docs/MAX6675.png)

*   **DHT22 (Temperature & Humidity Sensor):**
    *   **Purpose:** This sensor monitors the ambient temperature and humidity of the room where the printer is located. This data is important because environmental conditions can affect print quality and filament health.

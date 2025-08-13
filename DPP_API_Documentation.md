# ENMS DPP API Documentation

## 1. Introduction

This document provides comprehensive developer documentation for the ENMS (Energy and Network Management System) Digital Product Passport (DPP) API. It is intended for software engineers and system integrators who need to connect external applications to the ENMS platform.

### 1.1. API Purpose and Scope

The DPP API is a core component of the ENMS ecosystem. Its primary purpose is to provide a single, authoritative endpoint for accessing real-time and historical data from a fleet of connected 3D printers. The API serves as a read-only gateway to the curated data within the ENMS database, which is populated by a sophisticated data ingestion and processing pipeline.

This API is designed for use in production environments where reliability, accuracy, and consistency are paramount.

### 1.2. Key Capabilities

*   **Real-Time Fleet Status:** Get a live snapshot of all printers, including their operational state (e.g., `Printing`, `Idle`, `Error`), current temperatures, and active material.
*   **Active Job Monitoring:** For printers that are currently active, the API provides detailed job information, such as progress percentage, estimated time remaining, and real-time energy consumption.
*   **Historical Job Data:** Access a curated history of recently completed print jobs across the entire fleet, including final energy consumption and duration.
*   **G-Code Analysis Integration:** The API exposes valuable metadata that has been automatically extracted from G-code files by the ENMS backend, including layer height, infill density, and object dimensions.
*   **Per-Part Energy Analysis:** For supported jobs, the API provides an estimated breakdown of energy consumption per individual part within a print.

## 2. Access

### 2.1. Base URL

All API endpoints are relative to the following base URL, which is defined by the Nginx reverse proxy configuration:

```
http://<your_enms_instance_ip>/api/
```

Replace `<your_enms_instance_ip>` with the IP address or domain name of your ENMS installation.

### 2.2. Authentication

The DPP API itself does not implement an authentication layer. Access control is managed at the network and infrastructure level.

**Clients must be on an authorized network (e.g., a corporate VPN or a specific IP allow-list) to access the API.**

If you are unable to connect, please contact your network administrator to ensure you have a route to the ENMS host and that your access has been permitted by the relevant firewalls.

## 3. Endpoint Reference

### Get DPP Summary

This is the primary endpoint of the DPP API. It returns a comprehensive, real-time snapshot of the entire printer fleet.

*   **Method:** `GET`
*   **Path:** `dpp_summary`
*   **Full URL:** `http://<your_enms_instance_ip>/api/dpp_summary`

#### Query Parameters

This endpoint does not accept any query parameters.

#### Example Request

```bash
curl http://<your_enms_instance_ip>/api/dpp_summary
```

#### Example JSON Response

The response is a JSON object containing two top-level keys: `printers` and `globalHistory`.

```json
{
  "printers": [
    {
      "deviceId": "PrusaMK4-1",
      "friendlyName": "Prusa MK4 1",
      "model": "PrusaMK4",
      "sizeCategory": "Standard",
      "plant_type": "generic_plant",
      "kwhLast24h": 1.234,
      "lastJobKwh": 0.28,
      "printTimeSeconds": 1800,
      "lastJobFilamentGrams": 5.2,
      "bedWidth": 250,
      "bedDepth": 210,
      "currentStatus": "Printing",
      "isPrintingNow": true,
      "currentNozzleTemp": 215,
      "targetNozzleTemp": 215,
      "currentBedTemp": 60,
      "targetBedTemp": 60,
      "currentMaterial": "PLA",
      "jobFilename": "big_benchy.gcode",
      "jobProgressPercent": 65,
      "jobTimeLeftSeconds": 3600,
      "jobKwhConsumed": 0.75,
      "gcodePath": "http://<prusa_link_host>/downloads/files/local/big_benchy.gcode",
      "gcode_preview_api_key": "ABC-123-DEF-456",
      "job_details": {
        "object_name": "Benchy (Large)",
        "infill_density_percent": 20,
        "layer_height_mm": 0.2,
        "supports_enabled": false,
        "nozzle_diameter_mm": 0.4,
        "object_dimensions_mm": { "x": 120, "y": 62, "z": 96 },
        "estimated_material_g": 55.8,
        "slicer_profile_name": "Prusament PLA Quality 0.2mm"
      },
      "detailed_analysis_data": {},
      "history": [
          {
              "filename": "calibration_cube.gcode",
              "session_energy_wh": 280,
              "end_time": "2023-10-27T10:00:00Z",
              "thumbnail_url": "/gcode_previews/job_123.png",
              "per_part_analysis": null
          }
      ],
      "plantStage": 13,
      "tipText": "Heads up: 'big_benchy.gcode' is currently printing. Monitor its progress to ensure a successful outcome."
    },
    {
      "deviceId": "PrusaMK4-2",
      "friendlyName": "Prusa MK4 2",
      "model": "PrusaMK4",
      "sizeCategory": "Standard",
      "plant_type": "generic_plant",
      "kwhLast24h": 0.075,
      "lastJobKwh": 0.55,
      "currentStatus": "Idle",
      "isPrintingNow": false,
      ...
    }
  ],
  "globalHistory": [
    {
      "printerName": "Prusa MK4 2",
      "filename": "some_other_print.gcode",
      "kwh": 0.85,
      "completedAt": "2023-10-27T10:30:00Z",
      "thumbnailUrl": "/gcode_previews/job_124.png"
    }
  ]
}
```

#### Status Codes

| Code | Meaning                 | Description                                                                                              |
| :--- | :---------------------- | :------------------------------------------------------------------------------------------------------- |
| `200 OK` | The request was successful. | The response body contains the DPP summary JSON object.                                          |
| `403 Forbidden` | Access is denied. | This indicates that the request was understood, but the server is refusing to fulfill it. This is typically due to network access rules (e.g., firewall, VPN) blocking the client's IP address. |
| `404 Not Found` | The endpoint does not exist. | The requested URL (e.g., `/api/dpp_summaryyy`) does not match a valid endpoint. Please check the path for typos. |
| `429 Too Many Requests` | The client is sending too many requests. | While not currently implemented, this code will be used if rate limiting is introduced in the future. Clients should be prepared to handle this response by implementing a backoff strategy. |
| `500 Internal Server Error` | The server encountered an error. | This typically occurs if the API cannot connect to the database or if an unexpected error happens during data processing. The response body may contain an `error` key with a descriptive message. |

## 4. Data Model

This section provides an authoritative reference for all fields in the JSON response, based on the ENMS database schema.

### 4.1. Top-Level Object

| Field           | Type  | Description                                           |
| :-------------- | :---- | :---------------------------------------------------- |
| `printers`      | array | An array of Printer Objects, each representing a device. |
| `globalHistory` | array | An array of Global History Objects.                   |

### 4.2. The Printer Object

Each object in the `printers` array represents a single device and its current state.

| Field                   | Type    | Source Table (`Column`)                                    | Description                                                                                                                              |
| :---------------------- | :------ | :--------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------- |
| `deviceId`              | string  | `devices` (`device_id`)                                    | The unique identifier for the printer.                                                                                                   |
| `friendlyName`          | string  | `devices` (`friendly_name`)                                | The human-readable name of the printer.                                                                                                  |
| `model`                 | string  | `devices` (`device_model`)                                 | The model of the printer (e.g., `PrusaMK4`).                                                                                             |
| `sizeCategory`          | string  | `devices` (`printer_size_category`)                        | The size category of the printer (e.g., `Standard`, `Mini`, `XL`).                                                                       |
| `kwhLast24h`            | float   | Calculated from `energy_data`                              | The total energy consumed by the printer in the last 24 hours, in kilowatt-hours (kWh).                                                  |
| `lastJobKwh`            | float   | `print_jobs` (`session_energy_wh`)                         | The total energy in kWh consumed by the last successfully completed print job.                                                           |
| `printTimeSeconds`      | integer | `print_jobs` (`duration_seconds`)                          | The total duration in seconds of the last successfully completed print job.                                                              |
| `lastJobFilamentGrams`  | float   | `print_jobs` (`filament_used_g`)                           | The total filament in grams used by the last successfully completed print job.                                                           |
| `bedWidth`              | integer | `devices` (`bed_width`)                                    | The width of the printer's bed in millimeters.                                                                                           |
| `bedDepth`              | integer | `devices` (`bed_depth`)                                    | The depth of the printer's bed in millimeters.                                                                                           |
| `currentStatus`         | string  | `printer_status` (`state_text`)                            | The current operational status of the printer (e.g., `Printing`, `Idle`, `Offline`, `Heating`, `Cooling`, `Error`).                    |
| `isPrintingNow`         | boolean | Calculated from `printer_status` (`state_text`)            | A flag indicating if the printer is currently in an active printing or heating state.                                                    |
| `currentNozzleTemp`     | float   | `printer_status` (`nozzle_temp_actual`)                    | The current temperature of the nozzle, in degrees Celsius.                                                                               |
| `targetNozzleTemp`      | float   | `printer_status` (`nozzle_temp_target`)                    | The target temperature of the nozzle, in degrees Celsius.                                                                                |
| `currentBedTemp`        | float   | `printer_status` (`bed_temp_actual`)                       | The current temperature of the print bed, in degrees Celsius.                                                                            |
| `targetBedTemp`         | float   | `printer_status` (`bed_temp_target`)                       | The target temperature of the print bed, in degrees Celsius.                                                                             |
| `currentMaterial`       | string  | `printer_status` (`material`)                              | The material currently loaded in the printer (e.g., `PLA`, `PETG`, `ASA`).                                                                |
| `jobFilename`           | string  | `printer_status` (`filename`)                              | The filename of the G-code file for the current print job. `null` if not printing.                                                       |
| `jobProgressPercent`    | float   | `printer_status` (`progress_percent`)                      | The completion percentage of the current print job (0-100).                                                                              |
| `jobTimeLeftSeconds`    | integer | `printer_status` (`time_left_seconds`)                     | The estimated time remaining for the current print job, in seconds.                                                                      |
| `jobKwhConsumed`        | float   | Calculated from `energy_data`                              | The energy consumed by the current print job so far, in kWh.                                                                             |
| `gcodePath`             | string  | `devices` (`gcode_preview_host`, `filename`)               | The full URL to download the G-code file for the current job. `null` if not available.                                                   |
| `gcode_preview_api_key` | string  | `devices` (`gcode_preview_api_key`)                        | The API key required to access the `gcodePath`, if applicable.                                                                           |
| `job_details`           | object  | `print_jobs` (`gcode_analysis_data`)                       | A JSONB object containing metadata from the G-code file. See section 4.3.                                                              |
| `history`               | array   | `print_jobs`                                               | An array of objects representing the last 5 completed jobs for this specific printer.                                                    |
| `tipText`               | string  | Calculated by the API                                      | A helpful tip or insight about the printer's current state.                                                                              |

### 4.3. The `job_details` (G-Code Analysis) Object

This object contains metadata extracted from the G-code file by the ENMS backend. All fields originate from the `gcode_analysis_data` JSONB column in the `print_jobs` table.

| Field                    | Type    | Description                                                              |
| :----------------------- | :------ | :----------------------------------------------------------------------- |
| `object_name`            | string  | The name of the object being printed.                                    |
| `infill_density_percent` | number  | The infill percentage used for the print.                                |
| `layer_height_mm`        | float   | The layer height in millimeters.                                         |
| `supports_enabled`       | boolean | Whether supports were enabled for the print.                             |
| `nozzle_diameter_mm`     | float   | The diameter of the nozzle in millimeters.                               |
| `object_dimensions_mm`   | object  | An object with `x`, `y`, and `z` keys for the object's dimensions in mm. |
| `estimated_material_g`   | float   | The estimated weight of the material to be used, in grams.               |
| `slicer_profile_name`    | string  | The name of the slicer profile used to generate the G-code.              |

### 4.4. The Global History Object

Each object in the `globalHistory` array represents a single completed print job from anywhere in the fleet.

| Field         | Type                      | Source Table (`Column`)         | Description                                                  |
| :------------ | :------------------------ | :------------------------------ | :----------------------------------------------------------- |
| `printerName` | string                    | `devices` (`friendly_name`)     | The friendly name of the printer that completed the job.     |
| `filename`    | string                    | `print_jobs` (`filename`)       | The filename of the G-code file for the completed job.       |
| `kwh`         | float                     | `print_jobs` (`session_energy_wh`)| The total energy consumed by the job, in kWh.                |
| `completedAt` | string (ISO 8601)         | `print_jobs` (`end_time`)       | The timestamp when the job was completed.                    |
| `thumbnailUrl`| string                    | `print_jobs` (`thumbnail_url`)  | A URL to a thumbnail image of the printed object. `null` if not available. |

### 4.5. Field Nullability

Several fields in the `Printer Object` can be `null` depending on the printer's state. Your application should be designed to handle these cases gracefully.

| Field                  | Condition for being `null`                                       |
| :--------------------- | :--------------------------------------------------------------- |
| `jobFilename`          | The printer is not currently in a `Printing` or `Heating` state. |
| `jobProgressPercent`   | The printer is not currently printing.                           |
| `jobTimeLeftSeconds`   | The printer is not currently printing.                           |
| `jobKwhConsumed`       | The printer is not currently printing.                           |
| `job_details`          | The printer is not currently printing.                           |
| `gcodePath`            | A G-code preview host is not configured for the device.          |
| `gcode_preview_api_key`| A G-code preview host is not configured for the device.          |
| `lastJobKwh`           | The printer has not yet completed any jobs.                      |
| `printTimeSeconds`     | The printer has not yet completed any jobs.                      |
| `lastJobFilamentGrams` | The printer has not yet completed any jobs.                      |

## 5. Performance & Scalability

The DPP API is designed to be a lightweight and efficient way to monitor a printer fleet. However, to ensure system stability and performance, please adhere to the following guidelines:

*   **Polling Frequency:** For applications that require real-time data, a polling interval of **30 to 60 seconds** is recommended. Polling more frequently than every 15 seconds is discouraged as it may place an unnecessary load on the database and provide diminishing returns on data freshness.
*   **Response Size:** The size of the JSON response is directly proportional to the number of printers in the fleet. The `globalHistory` object is capped at the 50 most recent jobs to maintain a predictable and manageable response size.
*   **Large-Scale Data Analysis:** This API is optimized for real-time monitoring and dashboarding. For large-scale historical data analysis or data warehousing purposes, it is recommended to query the PostgreSQL database directly.

## 6. Security

Security is managed at the infrastructure level, not within the API application itself.

*   **Network Segmentation:** The ENMS system, including the DPP API, should be deployed in a secure network zone that is not publicly accessible.
*   **Firewall and VPN:** Access to the API should be restricted via firewall rules or require a VPN connection. Only authorized client IP addresses or subnets should be permitted.
*   **No Sensitive Data in GET Requests:** The API is read-only and does not accept sensitive information in its URL.

## 7. Versioning and API Evolution

*   **Current Version:** The API is currently **unversioned**.
*   **Future Versions:** Significant or breaking changes will be introduced under a new versioned endpoint (e.g., `/api/v2/dpp_summary`).
*   **Non-Breaking Changes:** New, non-breaking fields may be added to the JSON response without a version change. Client applications should be designed to gracefully handle unexpected fields.
*   **Deprecation Policy:** Any plans to deprecate fields or endpoints will be communicated through official project channels with a clear timeline for removal.

## 8. Troubleshooting

| Issue                               | Possible Cause & Solution                                                                                                                                                                                          |
| :---------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Connection Refused / Timeout**    | <ul><li>Verify the IP address or domain name of the ENMS instance.</li><li>Confirm that your client's IP is on the authorized list or that you are connected to the correct VPN.</li><li>Check for firewall rules blocking access to the ENMS host on port 80.</li></ul> |
| **500 Internal Server Error**       | This indicates a server-side problem, most commonly a failure to connect to the PostgreSQL database. Contact the ENMS system administrator and check the `docker-compose` logs for the `python_api` and `postgres` services. |
| **Empty `printers` Array**          | This is expected if no printers are configured in the `devices` table of the ENMS database.                                                                                                                         |
| **Data Seems Stale or Not Updating**| The Node-RED data ingestion flows may be paused or have encountered an error. Check the Node-RED editor for the status of the "Master Ingestion Flow" and its sub-flows.                                           |
| **`null` Values in Response**       | `null` is an expected value for many fields, especially for printers that are idle or offline (e.g., `jobFilename` will be `null` if not printing). Your application should handle `null` values gracefully.        |

## 9. Code Examples

### 9.1. Python Example

This example uses the `requests` library to fetch data and prints a summary. It includes robust error handling for a production environment.

```python
import requests
import json
import os

def get_dpp_summary(api_base_url):
    """
    Fetches and prints a summary from the DPP API.

    Args:
        api_base_url (str): The base URL of the ENMS API (e.g., http://192.168.1.100/api)
    """
    api_endpoint = f"{api_base_url}/dpp_summary"

    try:
        response = requests.get(api_endpoint, timeout=10)  # Set a reasonable timeout
        response.raise_for_status()  # Raises an HTTPError for bad responses (4xx or 5xx)

        data = response.json()

        print("--- Printer Fleet Status ---")
        printers = data.get("printers")
        if not printers:
            print("No printer data returned from API.")
            return

        for printer in printers:
            name = printer.get("friendlyName", "Unknown Printer")
            status = printer.get("currentStatus", "N/A")

            if status == "Printing":
                progress = printer.get("jobProgressPercent", 0)
                print(f"- {name}: {status} ({progress:.1f}%)")
            else:
                print(f"- {name}: {status}")

    except requests.exceptions.RequestException as e:
        print(f"Error: A network error occurred while contacting the API: {e}")
    except json.JSONDecodeError:
        print("Error: Failed to parse a valid JSON response from the API.")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

if __name__ == "__main__":
    # It is recommended to use an environment variable for the IP address
    enms_ip = os.getenv("ENMS_INSTANCE_IP", "localhost")
    base_url = f"http://{enms_ip}/api"
    get_dpp_summary(base_url)

```

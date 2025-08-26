# ENMS - Analysis & Machine Learning Deep Dive

This document provides a detailed, technical explanation of two of the most powerful features in the ENMS platform: the **Interactive Analysis** module and the **Machine Learning Model Training** process.

It is intended for developers, system integrators, and technical partners who need to understand how these systems work under the hood.

## 1. Interactive Analysis Deep Dive

> **Note:** Interactive Analysis is designed for Prusa APIs only. For SimplyPrint, use the DPP Page and Node-RED flows under **Historical Enrichment**.

This section breaks down the end-to-end workflow of the Interactive Analysis page, from a user clicking a button in the UI to the results being displayed. The entire process is orchestrated by a powerful Node-RED flow that acts as a backend API, dynamically querying the database and executing a Python script to perform complex analysis.

Here is a high-level overview of the data flow:

```
[Frontend: analysis_page.html]
       |
       | (1) User clicks "Run Analysis"
       |
[POST /api/analyze Request]
       |
       | (2) Request with {deviceId, timeRange, drivers}
       |
[Backend: Node-RED "Analysis API" Flow]
       |
       | (3) Constructs SQL query
       |
[Database: PostgreSQL / TimescaleDB]
       |
       | (4) Returns unified time-series dataset
       |
[Backend: Python-Function Node]
       |
       | (5) Performs statistical & ML analysis
       |
[API Response (JSON)]
       |
       | (6) Sends detailed results back to frontend
       |
[Frontend: analysis_page.html]
       |
       | (7) Visualizes results using Chart.js
       V
```

### Step 1: The Frontend (`analysis/analysis_page.html`)

The process begins with the user on the Interactive Analysis page. The user has several controls to define the scope of their analysis:

*   **Device Dropdown:** Selects the target device (e.g., `PrusaMK4-1`). *This only applies to Prusa; skip if using SimplyPrint.*
*   **Time Range Buttons:** Chooses the time window for the analysis (e.g., `Last 24 hours`, `Last 7 days`).
*   **Driver Checkboxes:** Selects various operational or environmental factors to correlate with energy consumption. These "drivers" correspond to columns in the database, such as `nozzle_temp_actual`, `is_printing`, and `z_height_mm`.

### Step 2: The API Request (`POST /api/analyze`)

When the user clicks "Run Energy Analysis", the frontend JavaScript constructs a JSON object containing the user's selections and sends it as a `POST` request to the `/api/analyze` endpoint.

**Example Request Payload:**
```json
{
  "deviceId": "PrusaMK4-1",
  "timeRange": "24h",
  "selectedDrivers": {
    "nozzle_temp_actual": true,
    "bed_temp_actual": true,
    "is_printing": true
  }
}
```

### Step 3: The Backend (Node-RED `Analysis API` Flow)

The `/api/analyze` endpoint is not a traditional Python Flask or Node.js application. Instead, it is hosted directly by a **Node-RED flow**.

1.  An `http in` node is configured to listen for `POST` requests at this path.
2.  A `function` node receives the request, parses the JSON payload, and validates the inputs. It also translates the human-friendly `timeRange` (e.g., "24h") into a precise timestamp that the database can understand (e.g., `NOW() - INTERVAL '24 hours'`).

### Step 4: Data Aggregation (The SQL Query)

This is the most critical data-gathering step. A `function` node constructs a single, complex SQL query to create a unified dataset for the analysis. This query is executed against the PostgreSQL database.

Its primary job is to join the `energy_data` table (which contains power readings) with the `printer_status` and `environment_data` tables. The challenge is that these readings are not perfectly aligned by timestamp. The query solves this using `LEFT JOIN LATERAL`, which is a powerful and efficient way to find the "most recent" or "closest" record from another table for each row in the primary table.

**Example SQL Query Snippet (from `ENMS_Technical_Details.md`):**
```sql
SELECT
    ep.timestamp, ep.power_watts,
    ps.nozzle_temp_actual, ps.is_printing,
    env.temperature_c AS ambient_temp_c
FROM energy_data ep
LEFT JOIN LATERAL (
    SELECT nozzle_temp_actual, is_printing FROM printer_status
    WHERE device_id = ep.device_id AND timestamp <= ep.timestamp
    ORDER BY timestamp DESC LIMIT 1
) ps ON true
LEFT JOIN LATERAL (
    SELECT temperature_c FROM environment_data
    WHERE timestamp BETWEEN ep.timestamp - INTERVAL '15 minutes' AND ep.timestamp + INTERVAL '15 minutes'
    ORDER BY ABS(EXTRACT(EPOCH FROM (ep.timestamp - timestamp))) ASC
    LIMIT 1
) env ON true
WHERE ep.device_id = $1 AND ep.timestamp >= $2
ORDER BY ep.timestamp ASC;
```
The result is a rich, high-resolution dataset where every single power reading is enriched with the printer's state and the ambient environmental conditions at that moment in time.

### Step 5: Core Analysis (Python `function` Node)

The entire dataset returned from the SQL query is passed into a `python-function` node within Node-RED. This node executes a Python script that performs the heavy lifting of the analysis.

The script performs the following actions:
1.  **Calculates Key Metrics:** It computes high-level summary statistics like:
    *   Total energy consumption (kWh) for the period.
    *   Overall average power (Watts).
    *   Average power during "active" periods (defined as power > 5W).
2.  **Performs Phase Analysis:** It categorizes the data into distinct operational phases (e.g., `Printing`, `Idle`, `Active (Other)`) based on rules (e.g., `is_printing` flag, power levels). It then calculates the total time spent and energy consumed in each phase.
3.  **Runs Statistical Analysis:** For the specific "drivers" the user selected, it calculates:
    *   **Pearson Correlation:** A statistical measure (-1 to +1) of the linear relationship between each driver and the `power_watts`.
    *   **Simple Linear Regression:** It builds a simple, on-the-fly regression model to show how the selected drivers can be used to predict power.
4.  **Loads the Pre-trained ML Model:** The script loads the `best_model.joblib` and `scaler.joblib` artifacts that were created by the offline training process (see Section 2). It uses this model to extract the **Feature Importance** scores, which indicate which factors the comprehensive model considers most influential in predicting power consumption.

### Step 6: The API Response

The Python script returns a large JSON object containing all of these results back to the Node-RED flow. A final `function` node formats this into a clean response that is sent back to the frontend.

The response object includes keys for `summary`, `new_metrics`, `phase_analysis`, `correlation`, `regression`, `ml_feature_importance`, and more, providing all the data the frontend needs to render the results.

### Step 7: Frontend Visualization

The JavaScript on the `analysis_page.html` receives the API response. It then parses the JSON data and uses the **Chart.js** library to dynamically build and render the various charts (pie charts for phase analysis, bar charts for feature importance) and populate the summary tables and key insight boxes.

## 2. Machine Learning Model Training

This section explains the offline process used to train the machine learning models that predict power consumption. This process is handled by the `backend/train_model.py` script and is a crucial preparatory step that is separate from the live operation of the ENMS platform.

### Objective

The primary goal of the training script is to produce a reliable regression model that can accurately predict a printer's `power_watts` based on a set of operational and environmental features. The resulting model is used in two key places:
1.  **The Interactive Analysis Page:** To provide "Feature Importance" scores.
2.  **The `Live Predictor` Flow (Node-RED):** To generate real-time power predictions.

### Key Characteristic: Offline Training

It is critical to understand that this model is trained **offline**.

*   **Data Source:** The script **does not** connect to the live PostgreSQL database. Instead, it reads from a static CSV file named `printer_energy_data_raw.csv` located in the `backend/` directory.
*   **Rationale:** This approach ensures that model training is a deterministic and reproducible process. It is not affected by potential live data quality issues, and it allows for easier experimentation and versioning of the dataset used for training.

### The Training Workflow (`train_model.py`)

The script follows a standard machine learning workflow:

#### Step 1: Load and Preprocess Data
1.  **Load CSV:** The script loads the `printer_energy_data_raw.csv` file into a pandas DataFrame.
2.  **Clean Data:** It performs several preprocessing steps:
    *   Removes duplicate entries based on the timestamp.
    *   Handles missing values by imputing them with `0`. This is based on the assumption that `NaN` values for sensor data (like nozzle temperature) often occur when the printer's API is offline, a state in which the values are effectively zero.
    *   Corrects invalid data, such as negative `z_height_mm` values.
3.  **Feature Selection:** It selects a specific list of columns defined in `FINAL_MODEL_FEATURES` to be used for training.

#### Step 2: Model Comparison via Cross-Validation
To ensure the most robust model is chosen, the script does not rely on a single model type. It compares the performance of several common regression algorithms:
*   `LinearRegression`
*   `RandomForestRegressor`
*   `LightGBM` (if installed)
*   `XGBoost` (if installed)

The comparison is done using **K-Fold Cross-Validation** (with 5 folds). The script uses the training portion of the data to evaluate each model type, and the primary metric for comparison is **Negative Mean Absolute Error** (MAE). The model type with the best average MAE across the folds is selected as the "best model".

#### Step 3: Final Training and Evaluation
1.  **Train/Test Split:** The preprocessed data is split into two sets: 80% for training and 20% for the final hold-out test set.
2.  **Scaling:** A `StandardScaler` is fit *only* on the training data. This scaler is then used to transform both the training and test data, ensuring no data leakage from the test set.
3.  **Train the Best Model:** A new instance of the "best model" type (e.g., RandomForest) is trained on the *entire* scaled 80% training set.
4.  **Evaluate on Test Set:** The newly trained model is used to make predictions on the unseen 20% test set. The script calculates and prints the final evaluation metrics (MAE, RMSE, and R-squared) to provide a reliable estimate of the model's real-world performance.

### Step 4: Saving the Model Artifacts

After successful training and evaluation, the script saves several crucial files (artifacts) to the directory specified by the `MODEL_DIR` environment variable (e.g., `./models`). This directory is mapped as a Docker volume, allowing the trained models to be persisted and accessed by other services (like Node-RED). See the `docker-compose.yml` file for details.

The following artifacts are saved:
*   `best_model.joblib`: The trained model object itself (e.g., the trained RandomForestRegressor).
*   `scaler.joblib`: The fitted `StandardScaler` object. It is essential for scaling new, live data in the exact same way as the training data.
*   `scaler_columns.joblib`: A list of the feature names in the exact order the scaler expects them. This prevents errors if the column order changes.
*   `model_features.joblib`: The list of features the model was ultimately trained on.
*   `model_evaluation_metrics.joblib`: A dictionary containing the final evaluation metrics (MAE, RMSE, R²) from the test set. This data is displayed on the "Advanced Details" section of the Interactive Analysis page.

## 3. Frequently Asked Questions (FAQ)

This section answers common questions about the analysis and machine learning functionalities.

#### Q1: Why is the ML model trained from a static CSV file and not from the live database?

**Answer:** This is a deliberate design choice to ensure the model training process is **reproducible** and **stable**.

*   **Reproducibility:** By using a static, version-controlled CSV file, anyone can retrain the exact same model that is running in production. If the model were trained on a live, constantly changing database, it would be nearly impossible to reproduce the same result twice.
*   **Stability:** Live data can sometimes have quality issues, gaps, or anomalies. Training on a curated, cleaned dataset prevents these issues from negatively impacting the model.
*   **Decoupling:** It decouples the complex and potentially resource-intensive training process from the live operational database, preventing any impact on the platform's real-time performance.
*   **Experimentation:** It allows data scientists to easily experiment with different versions of the dataset without having to modify the live database.

#### Q2: What is the difference between the "Correlation" analysis and the "Feature Importance" analysis on the results page?

**Answer:** This is a key distinction between a simple statistical analysis and a more complex machine learning interpretation.

*   **Correlation / Regression:**
    *   **Scope:** This analysis is performed **only on the "drivers" you explicitly selected** in the checkboxes.
    *   **Timing:** It is calculated **in real-time** on the specific dataset for the time range you chose.
    *   **Meaning:** It shows the simple, direct linear relationship between two variables (e.g., as nozzle temperature goes up, does power go up or down?). It does not account for the complex interplay between multiple factors.
*   **Feature Importance:**
    *   **Scope:** This comes from the comprehensive, pre-trained Machine Learning model (`best_model.joblib`), which was trained on **all available features**, not just the ones you selected.
    *   **Timing:** It is a **pre-calculated** property of the trained model. The values do not change unless the model is retrained.
    *   **Meaning:** It represents how much influence or predictive power each feature has *within the context of the entire model*. It reflects more complex, non-linear relationships and interactions between features. A feature might have low direct correlation but high importance because it is critical when combined with other features.

In short: **Correlation is a simple, live analysis of your selected inputs. Feature Importance is a sophisticated, pre-calculated insight from the master ML model.**

#### Q3: How do I retrain the model with new, updated data?

**Answer:** The model must be retrained manually by following these steps:

1.  **Generate a New Dataset:** The first step is to create an updated version of `printer_energy_data_raw.csv`. This typically involves running a separate script or a database query to export the latest data from the live database into the required CSV format. (Note: This export script is not currently part of this project and would need to be created).
2.  **Replace the CSV:** Place the new `printer_energy_data_raw.csv` file into the `backend/` directory, replacing the old one.
3.  **Run the Training Script:** Execute the training script from the root of the project directory. You can do this inside the running `node-red` container or locally if you have the python environment set up.
    ```bash
    # Example of running inside the container
    docker compose exec enms-nodered python /usr/src/node-red/backend/train_model.py
    ```
4.  **Verify the Output:** The script will print the new evaluation metrics and save the updated artifacts (`best_model.joblib`, `scaler.joblib`, etc.) to the mapped volume specified by `MODEL_DIR`.
5.  **Automatic Pickup:** The `Analysis API` and `Live Predictor` flows will automatically pick up the new model artifacts on their next execution, as they load the model from the file each time they run.

#### Q4: Why do I sometimes see "N/A" or get an error for the Correlation analysis?

**Answer:** This typically happens when the data in your selected time range does not have enough variance for a meaningful statistical calculation.

For example, if you select "Is Printing" as a driver but for the entire chosen time period the printer was never printing (the value was always `false`), there is no variation to correlate. The correlation is mathematically undefined, and the analysis will return "N/A: No variance". The same can happen if a sensor value was constant for the entire period. To fix this, try selecting a wider time range or a different set of drivers.

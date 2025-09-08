# ENMS - Analysis & Machine Learning Deep Dive

This document provides a detailed, technical explanation of the **Interactive Analysis** module and the **Machine Learning Model Training** process. It is intended for developers, data scientists, and system integrators who need to understand how these systems work under the hood.

## 1. Interactive Analysis Deep Dive

This section breaks down the end-to-end workflow of the Interactive Analysis page. The entire process is orchestrated by a Node-RED flow that acts as a backend API, dynamically querying the database and executing a Python script to perform complex analysis.

### 1.1. The Workflow

The data flow for a single analysis request is as follows:
1.  **Frontend:** On the `analysis_page.html`, the user selects a device, a time range, and a set of "drivers" to analyze. A `POST` request is sent to `/api/analyze`.
2.  **Backend (Node-RED):** The `Analysis API` flow receives the request, validates it, and constructs a complex SQL query.
3.  **Database (PostgreSQL):** The query is executed. This query joins `energy_data` with `printer_status` and `environment_data` to create a rich, unified dataset for the requested time range.
4.  **Performance Optimization (Data Downsampling):** A new optimization has been added to prevent timeouts on large queries (e.g., "7d", "All"). The SQL query now includes logic to aggregate data points, effectively downsampling the data before it is sent to the analysis script.
5.  **Core Analysis (Python):** The resulting dataset is passed to a Python script within a `python-function` node. This script performs all the heavy lifting: statistical calculations, phase analysis, and extraction of feature importances from the pre-trained model.
6.  **Response:** The analysis results are formatted into a JSON object and sent back to the frontend.
7.  **Visualization:** The frontend uses Chart.js to render the charts and tables from the response data.

### 1.2. New: Performance Optimizations

To handle large time ranges like "7 days" or "All" without causing API timeouts or overwhelming the analysis script, a **data downsampling strategy** has been implemented directly in the main SQL query.

*   **How it Works:**
    *   The query detects when a large time range is requested.
    *   Instead of returning every single raw data point, it uses the `time_bucket()` function from TimescaleDB to group data into larger intervals (e.g., 5-minute or 15-minute buckets).
    *   It then calculates the `AVG()` of the metrics within each bucket.
*   **Benefit:** This significantly reduces the number of rows returned, making the query and subsequent analysis much faster and preventing timeouts, while still preserving the overall trends in the data.

## 2. Machine Learning Model Training

This section explains the offline process used to train the machine learning models that predict power consumption. This process is handled by the `backend/train_model.py` script. The resulting model artifacts are used by both the `ml_worker` service for live predictions and the Interactive Analysis page.

### 2.1. Objective

The goal is to produce a regression model that can accurately predict a printer's `power_watts` based on a set of operational, environmental, and material features.

### 2.2. Key Characteristic: Offline Training

The model is trained **offline** from a static CSV file (`printer_energy_data_raw.csv`). This is a deliberate design choice to ensure the training process is **reproducible, stable, and decoupled** from the live operational database.

### 2.3. The Training Workflow (`train_model.py`)

The script follows a standard machine learning workflow:
1.  **Load and Preprocess Data:** Loads the data, cleans it, and handles missing values.
2.  **Feature Engineering:** Creates new, more powerful features from the raw data.
3.  **Model Comparison:** Uses K-Fold Cross-Validation to find the best performing model type (e.g., RandomForest, XGBoost).
4.  **Final Training:** Trains the chosen model on an 80% training split.
5.  **Evaluation:** Evaluates the final model on the unseen 20% test set and prints the metrics (MAE, RMSE, R²).
6.  **Save Artifacts:** Saves the trained model (`best_model.joblib`), the scaler (`scaler.joblib`), and other metadata.

### 2.4. Model Features (Updated)

The model has been upgraded to be more powerful and universal across all printer types. It now uses a more sophisticated set of features:

*   **Core Operational Features:**
    *   `nozzle_temp_actual`, `nozzle_temp_target`
    *   `bed_temp_actual`, `bed_temp_target`
    *   `progress_percent`
    *   `is_printing` (boolean)

*   **New Environmental Features:**
    *   `ambient_temp_c`: The ambient air temperature around the printer, which can significantly affect heating power requirements.

*   **New Engineered Features (Deltas):**
    *   `nozzle_temp_delta`: The difference between the actual and target nozzle temperature (`target - actual`).
    *   `bed_temp_delta`: The difference between the actual and target bed temperature (`target - actual`).
    *   *Rationale:* These delta features are very powerful indicators of whether the printer is currently in a heating phase (large positive delta), a cooling phase (negative delta), or maintaining temperature (delta near zero).

*   **New Material Feature (One-Hot Encoded):**
    *   `material`: The filament material being used for the print (e.g., `PLA`, `PETG`, `ABS`).
    *   *Implementation:* This categorical feature is converted into multiple numerical columns using **one-hot encoding** (e.g., `material_PLA`, `material_PETG`). This allows the model to learn the distinct energy properties associated with each material type.

### 2.5. Obsolete: The Old Live Predictor Flow

**This section is for informational purposes to document the upgrade. The old system is no longer in use.**

Previously, live predictions were handled by a `Live Predictor` flow in Node-RED. This flow would trigger every 10 seconds, gather features, and then execute a Python script using a `python-function` or `exec` node **for every active printer**.

*   **Problem:** This created a "spawn storm" where dozens of Python processes were created and destroyed in parallel. Each process had to load the entire ML model from disk, leading to massive resource consumption, server instability, and frequent crashes.
*   **Solution:** This entire flow has been **removed and replaced** by the new, stable **`ml_worker` service**. The new architecture uses a persistent Python worker and an MQTT message queue to process prediction requests sequentially and efficiently. This has resolved the stability and performance issues.

## 3. Frequently Asked Questions (FAQ)

#### Q1: Why is the ML model trained from a static CSV file and not from the live database?

**Answer:** This is a deliberate design choice for **reproducibility, stability, and decoupling**. It ensures that model training is a deterministic process that doesn't impact the live database. It allows data scientists to easily version control the dataset and experiment without risk.

#### Q2: What is the difference between the "Correlation" analysis and the "Feature Importance" analysis?

**Answer:**
*   **Correlation:** A simple, real-time statistical calculation performed on only the "drivers" you explicitly selected for the requested time range. It shows a direct linear relationship.
*   **Feature Importance:** A sophisticated, pre-calculated property of the comprehensive ML model. It reflects the predictive power of each feature in the context of all other features and their complex interactions.

In short: **Correlation is a live, simple analysis. Feature Importance is a pre-calculated, deep insight from the master ML model.**

#### Q3: How do I retrain the model with new data?

**Answer:**
1.  **Generate a New Dataset:** Export the latest data from the live database into the required CSV format.
2.  **Replace the CSV:** Place the new `printer_energy_data_raw.csv` file into the `backend/` directory.
3.  **Run the Training Script:** Execute the `backend/train_model.py` script. You can do this inside the `nodered` or `ml_worker` container.
    ```bash
    # Example of running inside a container
    docker compose exec enms-nodered python /usr/src/node-red/backend/train_model.py
    ```
4.  **Restart the `ml_worker`:** For the live prediction service to use the new model, you must restart it so it can load the new artifacts into memory.
    ```bash
    docker compose restart ml_worker
    ```
The Interactive Analysis page will automatically use the new model on its next run.

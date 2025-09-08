# The Definitive Guide to Interactive Analysis

This guide provides a comprehensive overview of the "Interactive Analysis" feature in the ENMS platform. It is designed for a dual audience: non-technical end-users who want to leverage the tool for energy savings, and technical developers or data scientists who need to understand the underlying architecture and machine learning models.

## 1. Overview

The Interactive Analysis page is a powerful, custom-built tool designed to help you understand your 3D printers' energy consumption in great detail. It allows you to perform a deep-dive analysis of a specific printer's performance, correlating its energy usage with various operational and environmental factors.

The feature is designed for two primary audiences:
*   **For Staff and Operators:** It provides clear, automated insights and actionable suggestions to improve energy efficiency and reduce operational costs. You can quickly see which printing phases consume the most energy or which factors have the biggest impact on power draw.
*   **For Developers and Data Scientists:** It offers a transparent look into the backend data analysis, including the statistical models and machine learning feature importances that drive the insights.

Whether you are looking to make operational decisions to save energy or seeking to understand the underlying data science, this tool provides the necessary visibility.

## 2. User Guide

This section is for anyone who wants to use the Interactive Analysis page to explore energy data and find opportunities for savings.

### How to Use the Analysis Page

The page is organized into two main sections: the **Analysis Configuration** panel on the left, where you set up your analysis, and the **Analysis Results** panel on the right, where the results appear.

Here is a step-by-step guide to running an analysis:

**Step 1: Select a Device**
Use the `Device` dropdown menu to choose which printer you want to analyze.

**Step 2: Select a Time Range**
Choose the period of time you want to analyze by clicking one of the time range buttons.
- For recent activity, use `1h`, `6h`, or `24h`.
- For long-term trends, use `7d` (7 days) or `All` (all available data).

**Step 3: Select Drivers**
"Drivers" are factors that you think might influence energy consumption. Selecting drivers tells the system to perform a statistical analysis to see if there is a relationship between them and the printer's power usage.

You can select drivers from several categories:
- **Temperatures:** `Nozzle Temp` and `Bed Temp`. Are heating cycles a major energy user?
- **Print State & Progress:** `Is Printing` and `Z-Height`. How much energy is used during active printing versus idle time?
- **Environment:** `Ambient Temp` and `Ambient Humidity`. Does the room's temperature affect how much energy the printer needs to stay hot?
- **Print Properties:** `Filament Material`. Do different materials have different energy footprints?

**Step 4: Run the Analysis**
Click the **Run Energy Analysis** button. The system will fetch the data and perform the analysis, which may take a few moments. The results will then populate in the panel on the right.

### Understanding the Results

The results panel is designed to give you insights at a glance, with more detailed information available if you need it.

#### Analysis Insights (Main Summary)

This is the main results box, which contains several key components:

*   **Key Metrics:**
    *   `Total Energy`: The total electricity (in kWh) consumed by the printer during the selected time period.
    *   `Avg Power (Overall)`: The average power draw (in Watts) across the entire period, including idle time.
    *   `Avg Power (Active)`: The average power draw only during times the printer was considered "active" (drawing more than 5 Watts). A large difference between this and the overall average indicates significant idle time.

*   **Energy Breakdown by Phase:** This is one of the most useful sections for identifying energy waste. The system automatically categorizes the printer's activity into phases (`Printing`, `Active (Other)`, `Idle`) and shows you:
    *   A table detailing how much time and energy was spent in each phase.
    *   Two pie charts for a quick visual comparison of where the printer spends its time and where it spends its energy.
    *   **What to look for:** If a large percentage of energy is spent in the `Active (Other)` or `Idle` phase, it could indicate the printer is sitting heated for long periods without printing, which is a key area for energy savings.

*   **Key Insights:** A bulleted list of plain-English takeaways automatically generated from the analysis. This section highlights the most important findings, such as the most influential energy driver or the highest-consuming operational phase.

*   **Potential Actions & Suggestions:** Based on the insights, this section provides a list of concrete, actionable suggestions you can take to improve energy efficiency.

#### Advanced Details (For the Curious)

If you click the "Show Advanced Details" button, you will see more technical statistical results. While this section is primarily for technical users, it can provide some interesting information:

*   **Relationship with Power Consumption (Correlation):** This shows how strongly each "driver" you selected is related to power usage. A value close to +1 means as the driver increases, power usage strongly tends to increase. A value close to -1 means the opposite. A value near 0 means there's little to no direct relationship.
*   **Top Influencing Factors:** This shows the top factors that the master AI model (which considers *all* available data, not just what you selected) found to be the most predictive of energy use. This can sometimes reveal surprising relationships you might not have expected.

## 3. Technical Deep Dive

*This section is for developers and data scientists. It details the system architecture, data flows, and the machine learning model that power the analysis feature.*

### System Architecture & Data Flow

The Interactive Analysis feature is powered by a backend API hosted entirely within a Node-RED flow. This flow orchestrates the process of fetching data from the database, executing a complex Python analysis script, and returning the results to the frontend.

Here is a high-level overview of the data flow for a single analysis request:

```
[Frontend: analysis_page.html]
       |
       | (1) User clicks "Run Analysis"
       |
[POST /api/analyze Request]
       |
       | (2) Request with {deviceId, timeRange, selectedDrivers}
       |
[Backend: Node-RED "Analysis API" Flow]
       |
       | (3) Constructs SQL query (High-res or Downsampled)
       |
[Database: PostgreSQL / TimescaleDB]
       |
       | (4) Returns unified time-series dataset
       |
[Backend: Node-RED Python-Function Node]
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

**Step-by-step Flow:**

1.  **Frontend Request:** The user makes selections in the UI (`deviceId`, `timeRange`, `drivers`). Clicking "Run Analysis" sends these as a JSON payload in a `POST` request to the `/api/analyze` endpoint.

2.  **Node-RED Entry Point:** An `http in` node in the "Analysis API" flow receives the request.

3.  **Request Parsing & Routing:** A `function` node parses the request. It validates the inputs and, most importantly, determines whether to use a high-resolution or a downsampled database query based on the `timeRange`. This decision is critical for performance (see the "Performance Optimization" section for details).

4.  **Database Query:** The flow executes one of two SQL queries against the TimescaleDB database. These queries join `energy_data` with the latest `printer_status` and nearest `environment_data` to create a single, rich, unified dataset for analysis.

5.  **Python Analysis:** The entire dataset is passed to a `python-function` node. This node executes a Python script that is the core of the analysis engine. It calculates key metrics, performs phase analysis, runs correlation and regression statistics, and uses a pre-trained machine learning model to derive feature importances.

6.  **Response Formatting:** The results from the Python script are passed to a final `function` node, which formats them into the clean JSON structure the frontend expects and generates dynamic Grafana URLs.

7.  **Frontend Visualization:** The frontend JavaScript receives the JSON response and uses it to populate the various charts, tables, and insight cards on the page.

### Data & Features

The analysis model relies on a rich dataset created by joining multiple time-series tables from the database.

#### Source Tables

*   `public.devices`: A metadata table that stores the configuration for every monitored device, such as its name, model, and API credentials.
*   `public.energy_data`: A hypertable storing raw energy readings from the Shelly smart plugs. This provides the `power_watts` target variable.
*   `public.printer_status`: A hypertable storing periodic snapshots of the printer's operational state, including temperatures, progress, and boolean flags like `is_printing`.
*   `public.environment_data`: A hypertable containing ambient environment readings (temperature, humidity) from the lab's sensor hub.

#### Raw Features

The model is trained on the following raw features extracted from the database:

*   `plug_temp_c`: The temperature of the Shelly smart plug itself.
*   `nozzle_temp_actual`: The actual measured temperature of the printer's nozzle.
*   `bed_temp_actual`: The actual measured temperature of the printer's bed.
*   `nozzle_temp_target`: The target temperature set for the nozzle.
*   `bed_temp_target`: The target temperature set for the bed.
*   `is_printing`: A boolean flag indicating if the printer is actively printing.
*   `z_height_mm`: The current height of the Z-axis.
*   `ambient_temp_c`: The ambient temperature of the room.
*   `material`: The type of filament being used (e.g., 'PLA', 'PETG').

#### Engineered Features

To improve the model's predictive power, the `train_model.py` script creates several new features from the raw data. These engineered features are critical for capturing more complex behaviors.

*   **Temperature Deltas:**
    *   `nozzle_temp_delta`: Calculated as `nozzle_temp_target - nozzle_temp_actual`. This feature directly represents the heating or cooling effort being applied to the nozzle. A large positive value means the nozzle is actively heating, which is a strong predictor of energy consumption.
    *   `bed_temp_delta`: Calculated as `bed_temp_target - bed_temp_actual`. Similarly, this represents the heating effort for the print bed.

*   **One-Hot Encoded Material:**
    *   The `material` column is categorical text data, which most regression models cannot handle directly. To solve this, the script performs **one-hot encoding**.
    *   This process converts the single `material` column into multiple binary (0 or 1) columns, such as `material_PLA`, `material_PETG`, `material_ASA`, etc.
    *   This allows the model to learn a unique energy coefficient for each material type, capturing the different energy requirements for printing with different filaments.

### The Regression Model

The system uses a supervised machine learning regression model to predict `power_watts` based on the features described above.

#### Model Selection

To ensure robustness, the system does not rely on a single, hardcoded model type. Instead, the `train_model.py` script uses **K-Fold Cross-Validation** to automatically test and compare several different regression algorithms, including:
*   `LinearRegression`
*   `RandomForestRegressor`
*   `LightGBM` (if available)
*   `XGBoost` (if available)

The script selects the model type that performs best during cross-validation (based on the lowest Mean Absolute Error) and trains it on the full training dataset. This ensures that the system is always using the most effective algorithm for the given data.

#### Model Artifacts

The training process generates several critical files (`.joblib` artifacts) that are saved to the `models/` directory. This directory is a mounted volume, making the trained models available to the Node-RED service for live analysis.

*   `best_model.joblib`: The final, trained model object (e.g., a `RandomForestRegressor` instance).
*   `scaler.joblib`: The fitted `StandardScaler` object, used to scale live data in the exact same way as the training data.
*   `model_features.joblib`: A list of the exact feature names in the correct order that the model expects. This acts as a "contract" to prevent errors during live prediction.
*   `model_evaluation_metrics.joblib`: A dictionary containing the final evaluation metrics (MAE, RMSE, R²) from the hold-out test set. This data is displayed in the "Overall Model Quality" section of the UI.

### Performance Optimization: Data Downsampling

To ensure a responsive user experience and prevent API timeouts when analyzing large time ranges (e.g., 7 days or more), the Analysis API incorporates a dynamic data downsampling strategy. Instead of querying and processing every single raw data point over a long period, the system intelligently aggregates the data into larger time buckets.

This optimization is handled by the `Parse Analyze Request` node in the "Analysis API" flow, which determines the appropriate aggregation level based on the user's selected time range:

| Time Range | Bucket Interval | Downsampling Enabled |
| :--- | :--- | :--- |
| `1h`, `6h` | (none) | No |
| `24h` | `2 minutes` | Yes |
| `7d` | `10 minutes` | Yes |
| `all` | `30 minutes` | Yes |

#### How It Works

When downsampling is enabled, the backend executes a highly optimized SQL query that leverages the `time_bucket()` function from the TimescaleDB extension. The query aggregates the `energy_data` and `printer_status` tables into the specified time buckets *before* joining them. This is significantly faster than fetching millions of raw rows and then joining.

**Example Downsampling SQL Query:**
```sql
-- High-Performance Downsampling Query (Aggregate First, Join Later)
WITH AggEnergy AS (
    -- Step 1: Bucket and aggregate the energy data first.
    SELECT
        time_bucket($3, timestamp) AS bucket,
        AVG(power_watts) as power_watts,
        -- ... other aggregations
    FROM energy_data
    WHERE device_id = $1 AND timestamp >= $2
    GROUP BY 1
),
AggStatus AS (
    -- Step 2: Independently bucket and aggregate the status data.
    SELECT
        time_bucket($3, timestamp) AS bucket,
        -- Use TimescaleDB's optimized 'last' aggregate to get the final state
        LAST(nozzle_temp_actual, timestamp) as nozzle_temp_actual,
        -- ... other aggregations
    FROM printer_status
    WHERE device_id = $1 AND timestamp >= $2
    GROUP BY 1
)
-- Step 3: Join the two small, pre-aggregated tables together.
SELECT ... FROM AggEnergy ae LEFT JOIN AggStatus ps ON ae.bucket = ps.bucket;
```

For short time ranges where high-resolution detail is important (`1h`, `6h`), downsampling is automatically disabled, and the system falls back to the high-resolution `LATERAL JOIN` query.

## 4. Maintenance Guide

This section provides instructions for system administrators or data scientists on how to maintain and retrain the machine learning model.

### Model Retraining

The machine learning model is trained on a static snapshot of data (`printer_energy_data_raw.csv`). Over time, as you collect more data or if the behavior of your printers changes, you may want to retrain the model to improve its accuracy and ensure the insights it provides are relevant.

#### Why and When to Retrain

You should consider retraining the model if:
*   A significant amount of new data (e.g., several weeks or months of print jobs) has been collected.
*   You have added new printers to the fleet with different energy profiles.
*   You have made significant changes to printer firmware or hardware that could affect energy consumption.
*   You have started using new types of filament not included in the original training data.

#### The Retraining Process

Retraining the model is a two-step process that requires access to the server running the ENMS project.

**Step 1: Export Fresh Training Data**

First, you must generate an updated `printer_energy_data_raw.csv` file from the live database. The `backend/export_training_data.py` script is provided for this purpose.

1.  SSH into the host machine or open a shell in the running `enms-nodered` Docker container.
2.  Navigate to the project directory.
3.  Run the export script:
    ```bash
    # Inside the enms-nodered container
    python /usr/src/node-red/backend/export_training_data.py
    ```
    This will connect to the database, run the query to join `energy_data` and `printer_status`, and overwrite the `backend/printer_energy_data_raw.csv` file with the latest data.

**Step 2: Trigger the Manual Model Training Flow**

Once the new data is in place, you can trigger the training process from the Node-RED UI.

1.  Open the Node-RED editor in your web browser (typically at `http://<host-ip>:1880/`).
2.  Navigate to the **"Manual Model Training"** flow.
3.  Click the square button on the left side of the **"Start Model Retraining"** inject node.


This will execute the `train_model.py` script, which reads the new CSV file, automatically selects the best model type, trains it, and saves the new model artifacts (`best_model.joblib`, `scaler.joblib`, etc.) to the `models/` directory.

The `Analysis API` and `Live Predictor` flows will automatically pick up the new model on their next execution.

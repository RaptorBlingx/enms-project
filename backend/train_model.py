import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn.model_selection import train_test_split, cross_val_score, KFold # Added CV tools
from sklearn.preprocessing import StandardScaler
# --- NEW Model Imports ---
try:
    import lightgbm as lgb
    LGBM_AVAILABLE = True
except ImportError:
    LGBM_AVAILABLE = False
    print("Warning: lightgbm not found. Install with 'pip install lightgbm' to test.")
try:
    import xgboost as xgb
    XGB_AVAILABLE = True
except ImportError:
    XGB_AVAILABLE = False
    print("Warning: xgboost not found. Install with 'pip install xgboost' to test.")
# --- End New Imports ---
import joblib
import os
import sys
import traceback
import warnings

# --- Configuration ---
INPUT_CSV_FILE = 'printer_energy_data_raw.csv'
MODEL_DIR = '/home/ubuntu/monitor_ml/models'
TARGET_COLUMN = 'power_watts'

# --- Preprocessing Constants ---
# Features to use for the final model (7 features)
FINAL_MODEL_FEATURES = [
    'plug_temp_c',
    'nozzle_temp_actual',
    'bed_temp_actual',
    'is_printing',
    'z_height_mm',
    'nozzle_temp_target', # <<< ADDED
    'bed_temp_target'    # <<< ADDED
]
# Features whose NaN indicates API data might be missing (used for deciding imputation)
API_MISSING_INDICATOR_SOURCE_FEATURES = ['nozzle_temp_actual', 'bed_temp_actual', 'z_height_mm', 'is_printing']
# Value to use when imputing missing sensor data (when API was likely offline)
IMPUTE_VALUE_WHEN_API_MISSING = 0

# Ensure model directory exists
os.makedirs(MODEL_DIR, exist_ok=True)

# --- Suppress specific warnings ---
warnings.filterwarnings("ignore", category=FutureWarning) # Ignore pandas fillna/downcasting warnings
warnings.filterwarnings("ignore", category=UserWarning, message="X does not have valid feature names") # Ignore sklearn feature name warnings

print(f"--- Starting Model Training (Features: {FINAL_MODEL_FEATURES}) ---")

# === Load Data ===
print(f"\n=== Loading Data ({INPUT_CSV_FILE}) ===")
try:
    df = pd.read_csv(INPUT_CSV_FILE, parse_dates=['timestamp'], index_col='timestamp')

    # Handle duplicate indices
    initial_rows = len(df)
    duplicates = df.index.duplicated(keep='first')
    if duplicates.sum() > 0:
        df = df[~duplicates]
        print(f"Removed {initial_rows - len(df)} duplicate timestamp entries.")
    print(f"Loaded {len(df)} unique rows.")

    # Basic check for target column
    if TARGET_COLUMN not in df.columns:
        raise ValueError(f"Target column '{TARGET_COLUMN}' not found.")

    # Select only columns needed for processing and target
    cols_to_load = list(set([TARGET_COLUMN] + FINAL_MODEL_FEATURES + API_MISSING_INDICATOR_SOURCE_FEATURES))
    actual_cols = [col for col in cols_to_load if col in df.columns]
    missing_req_cols = [col for col in cols_to_load if col not in df.columns]
    if missing_req_cols:
         print(f"Warning: Columns missing from CSV needed for processing: {missing_req_cols}")
    df = df[actual_cols].copy() # Work with a copy of relevant columns

except FileNotFoundError:
    print(f"Error: Input file not found at {INPUT_CSV_FILE}", file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f"Error loading or filtering data: {e}", file=sys.stderr)
    traceback.print_exc()
    sys.exit(1)

# --- Basic Info ---
print("\n--- Data Info (Relevant Columns) ---")
df.info(verbose=False, memory_usage='deep')
print("\n--- Missing Value Counts (Relevant Columns) ---")
print(df.isnull().sum())

# === Preprocessing ===
print("\n=== Applying Preprocessing Strategy ===")
try:
    # Create DataFrame for processed features
    X_model = pd.DataFrame(index=df.index)

    # 1. Clean z_height_mm (negatives)
    if 'z_height_mm' in df.columns:
        neg_mask = df['z_height_mm'] < 0
        num_negative = neg_mask.sum()
        if num_negative > 0:
             print(f"Cleaning {num_negative} negative 'z_height_mm' values (setting to {IMPUTE_VALUE_WHEN_API_MISSING}).")
             # Use .loc on original df to modify in place before copying/imputing
             df.loc[neg_mask, 'z_height_mm'] = IMPUTE_VALUE_WHEN_API_MISSING

    # 2. Process is_printing
    if 'is_printing' in df.columns:
        # Convert first, then fillna, then add to X_model
        processed_col = pd.to_numeric(df['is_printing'], errors='coerce').fillna(IMPUTE_VALUE_WHEN_API_MISSING).astype(int)
        X_model['is_printing'] = processed_col
        print("Processed 'is_printing'.")
    elif 'is_printing' in FINAL_MODEL_FEATURES: # Expected but missing
         print(f"Warning: 'is_printing' column missing, creating as all {IMPUTE_VALUE_WHEN_API_MISSING}.")
         X_model['is_printing'] = IMPUTE_VALUE_WHEN_API_MISSING

    # 3. Process and impute other FINAL_MODEL_FEATURES
    features_to_process = ['plug_temp_c', 'nozzle_temp_actual', 'bed_temp_actual', 'z_height_mm', 'nozzle_temp_target', 'bed_temp_target']
    for col in features_to_process:
         if col in df.columns: # If column exists in original data
             num_nans = df[col].isnull().sum()
             if num_nans > 0:
                  # Impute NaNs and add to X_model
                  X_model[col] = df[col].fillna(IMPUTE_VALUE_WHEN_API_MISSING)
                  print(f"Imputed {num_nans} NaNs in '{col}' with {IMPUTE_VALUE_WHEN_API_MISSING}.")
             else:
                  # No NaNs, just copy
                  X_model[col] = df[col]
         elif col in FINAL_MODEL_FEATURES: # Expected but missing from CSV
              print(f"Warning: Column '{col}' missing, creating as all {IMPUTE_VALUE_WHEN_API_MISSING}.")
              X_model[col] = IMPUTE_VALUE_WHEN_API_MISSING

    # 4. Ensure Target has no NaNs (Drop rows FROM BOTH X_model and df)
    initial_rows = len(df)
    target_nan_mask = df[TARGET_COLUMN].isnull()
    if target_nan_mask.any():
        print(f"Dropping {target_nan_mask.sum()} rows due to missing target variable '{TARGET_COLUMN}'.")
        df = df[~target_nan_mask]
        X_model = X_model[~target_nan_mask] # Drop corresponding rows in features

    # 5. Final Check & Feature Set Preparation
    missing_final_cols = [f for f in FINAL_MODEL_FEATURES if f not in X_model.columns]
    if missing_final_cols:
        raise ValueError(f"Final model features missing after processing: {missing_final_cols}")

    # Ensure all final columns are numeric and in correct order
    for col in FINAL_MODEL_FEATURES:
         if not pd.api.types.is_numeric_dtype(X_model[col]):
              print(f"Warning: Converting final feature '{col}' to numeric.")
              X_model[col] = pd.to_numeric(X_model[col], errors='coerce').fillna(0)

    # Order columns according to definition
    X = X_model[FINAL_MODEL_FEATURES]
    y = df[TARGET_COLUMN] # Get target from cleaned df

    # Final check for NaNs in X
    if X.isnull().values.any():
        print("WARNING: NaNs still present in final feature matrix X!")
        print(X.isnull().sum())
        print("Attempting final fill with 0 before scaling.")
        X = X.fillna(0)

    print(f"\nPreprocessing complete. Final features: {FINAL_MODEL_FEATURES}")
    print(f"Shape of final feature matrix X: {X.shape}")
    print(f"Shape of final target vector y: {y.shape}")

except Exception as e:
     print(f"FATAL: Error during preprocessing: {e}", file=sys.stderr)
     traceback.print_exc()
     sys.exit(1)


# === Train/Test Split (for final evaluation ONLY) ===
# We use Cross-Validation for model selection/tuning first
print("\n=== Splitting Data (for final hold-out evaluation) ===")
if X.empty or y.empty:
    print("Error: No data available for training after preprocessing. Exiting.")
    sys.exit(1)
try:
    # Split data ONCE into training+validation and final hold-out test set
    # We'll use the train_val set for cross-validation and tuning
    X_train_val, X_test, y_train_val, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    print(f"Training + Validation set size: {len(X_train_val)} rows")
    print(f"Final Hold-out Test set size:  {len(X_test)} rows")
except Exception as e:
    print(f"FATAL: Error during train/test split: {e}", file=sys.stderr)
    traceback.print_exc()
    sys.exit(1)

# === Scaling ===
print("\n=== Scaling Features ===")
try:
    scaler = StandardScaler()
    # Fit scaler ONLY on the training+validation data
    X_train_val_scaled = scaler.fit_transform(X_train_val)
    # Transform the final hold-out test set using the *same* fitted scaler
    X_test_scaled = scaler.transform(X_test)
    print("Features scaled (scaler fit on train+validation set).")

    # Save the scaler and columns
    joblib.dump(scaler, os.path.join(MODEL_DIR, 'scaler.joblib'))
    # Save the columns in the order the scaler expects
    joblib.dump(X_train_val.columns.tolist(), os.path.join(MODEL_DIR, 'scaler_columns.joblib'))
    print(f"Scaler and scaler columns saved (Columns: {X_train_val.columns.tolist()}).")
except Exception as e:
    print(f"FATAL: Error during scaling or saving scaler: {e}", file=sys.stderr)
    traceback.print_exc()
    sys.exit(1)


# === Model Comparison using Cross-Validation ===
print("\n=== Model Comparison via Cross-Validation ===")

models = {
    'LinearRegression': LinearRegression(),
    'RandomForest': RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1),
}
if LGBM_AVAILABLE:
    # Use default parameters for initial comparison
    models['LightGBM'] = lgb.LGBMRegressor(random_state=42, n_jobs=-1, verbosity=-1)
if XGB_AVAILABLE:
    # Use default parameters for initial comparison
    models['XGBoost'] = xgb.XGBRegressor(random_state=42, n_jobs=-1, objective='reg:squarederror')

# Define Cross-validation strategy
cv_strategy = KFold(n_splits=5, shuffle=True, random_state=42)

results_cv = {}
# Focus on MAE as it's more interpretable in Watts
scoring_metric = 'neg_mean_absolute_error'

for name, model in models.items():
    print(f"--- Cross-validating {name} ---")
    try:
        # Perform cross-validation on the scaled training+validation set
        cv_scores = cross_val_score(model, X_train_val_scaled, y_train_val,
                                    scoring=scoring_metric, cv=cv_strategy, n_jobs=-1)
        results_cv[name] = cv_scores
        print(f"CV Scores ({scoring_metric}): {cv_scores}")
        print(f"CV Mean {scoring_metric}: {cv_scores.mean():.3f} +/- {cv_scores.std():.3f}")
    except Exception as e:
        print(f"Error cross-validating {name}: {e}")
        results_cv[name] = [np.nan] # Indicate failure

# === Select Best Model Type Based on CV ===
best_model_name = None
best_cv_score = -np.inf # Maximize negative MAE (i.e., minimize MAE)

print("\n--- CV Results Summary (Mean Negative MAE) ---")
for name, scores in results_cv.items():
    mean_score = np.nanmean(scores) # Use nanmean to handle potential failures
    print(f"{name}: {mean_score:.3f}")
    if mean_score > best_cv_score: # Remember, higher neg_mae is better (closer to 0)
        best_cv_score = mean_score
        best_model_name = name

if best_model_name is None:
    print("FATAL: No model performed successfully in cross-validation. Exiting.")
    sys.exit(1)

print(f"\nSelected best model type based on CV: {best_model_name} (Mean MAE: {-best_cv_score:.3f})")


# === Train Final Model & Evaluate on Hold-Out Test Set ===
print(f"\n=== Training Final {best_model_name} Model on Full Train+Validation Set ===")

# Re-initialize the best model type with default params for final training
# (Tuning would happen here if implemented)
if best_model_name == 'LinearRegression':
     final_model = LinearRegression()
elif best_model_name == 'RandomForest':
     final_model = RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1)
elif best_model_name == 'LightGBM' and LGBM_AVAILABLE:
     final_model = lgb.LGBMRegressor(random_state=42, n_jobs=-1, verbosity=-1)
elif best_model_name == 'XGBoost' and XGB_AVAILABLE:
     final_model = xgb.XGBRegressor(random_state=42, n_jobs=-1, objective='reg:squarederror')
else:
     print(f"Error: Best model '{best_model_name}' not recognized or available. Defaulting to RandomForest.")
     final_model = RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1)


final_model_metrics = {"model_type": best_model_name}
final_feature_importances = None

try:
    # Train the chosen model on the entire training + validation set (scaled)
    final_model.fit(X_train_val_scaled, y_train_val)
    print("Final model training complete.")

    print(f"\n--- Evaluating Final {best_model_name} on Hold-Out Test Set ---")
    y_pred_final = final_model.predict(X_test_scaled)
    y_pred_final = np.maximum(0.0, y_pred_final) # Ensure no negative predictions

    mae_final = mean_absolute_error(y_test, y_pred_final)
    mse_final = mean_squared_error(y_test, y_pred_final)
    rmse_final = np.sqrt(mse_final)
    r2_final = r2_score(y_test, y_pred_final)

    print(f"Final Test MAE:  {mae_final:.2f} W")
    print(f"Final Test RMSE: {rmse_final:.2f} W")
    print(f"Final Test R²:   {r2_final:.3f}")

    final_model_metrics.update({
        "mae": mae_final, "mse": mse_final, "rmse": rmse_final, "r_squared": r2_final,
        "n_test_samples": len(y_test),
        "features_used": X_train_val.columns.tolist() # Use columns from original X_train_val
    })

    # Get Feature Importances / Coefficients
    if hasattr(final_model, 'feature_importances_'):
         print(f"\n--- {best_model_name} Feature Importances ---")
         importances = final_model.feature_importances_
         feature_importance_df = pd.DataFrame({
             'Feature': X_train_val.columns,
             'Importance': importances
         }).sort_values(by='Importance', ascending=False)
         print(feature_importance_df.to_string(index=False))
         final_feature_importances = feature_importance_df
    elif hasattr(final_model, 'coef_'): # For Linear Regression
        print(f"\n--- {best_model_name} Coefficients ---")
        coeff_series = pd.Series(final_model.coef_, index=X_train_val.columns)
        print(coeff_series)
        print(f"Intercept: {final_model.intercept_:.2f}")

except Exception as e:
    print(f"FATAL: Error during final model training or evaluation: {e}", file=sys.stderr)
    traceback.print_exc()
    sys.exit(1)


# === Save Final Model Assets ===
# Save the BEST PERFORMING model and its associated assets
print("\n--- Saving Final Model Assets ---")
# Use a generic name for the model file for consistency in loading,
# but the metrics file will store the actual type.
final_model_filename = os.path.join(MODEL_DIR, 'best_model.joblib') # Changed name
metrics_filename = os.path.join(MODEL_DIR, 'model_evaluation_metrics.joblib') # Keep standard name
features_filename = os.path.join(MODEL_DIR, 'model_features.joblib') # Keep standard name

try:
    # Save Scaler (already saved)
    # Save Feature List (using columns from X_train_val)
    joblib.dump(X_train_val.columns.tolist(), features_filename)
    print(f"Model features list saved to {features_filename}")
    # Save Final Model
    joblib.dump(final_model, final_model_filename)
    print(f"Final model saved to {final_model_filename} (Type: {best_model_name})")
    # Save Metrics
    joblib.dump(final_model_metrics, metrics_filename)
    print(f"Final model metrics saved to {metrics_filename}")

except Exception as e:
    print(f"FATAL: Error saving final model assets: {e}", file=sys.stderr)
    traceback.print_exc()
    sys.exit(1)


print("\n--- Model Training Script Finished ---")

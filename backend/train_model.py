import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn.model_selection import train_test_split, cross_val_score, KFold
from sklearn.preprocessing import StandardScaler
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
import joblib
import os
import sys
import traceback
import warnings

# --- Configuration ---
INPUT_CSV_FILE = 'printer_energy_data_raw.csv'
MODEL_DIR = os.environ.get("MODEL_DIR")
TARGET_COLUMN = 'power_watts'

# --- Preprocessing Constants ---
# MODIFIED: Base features to load from CSV. 'material' will be expanded later.
BASE_MODEL_FEATURES = [
    'plug_temp_c',
    'nozzle_temp_actual',
    'bed_temp_actual',
    'is_printing',
    'z_height_mm',
    'nozzle_temp_target',
    'bed_temp_target',
    'material',             # <<< ADDED
    'ambient_temp_c'        # <<< ADDED
]
IMPUTE_VALUE_WHEN_API_MISSING = 0

# Ensure model directory exists
os.makedirs(MODEL_DIR, exist_ok=True)

# --- Suppress specific warnings ---
warnings.filterwarnings("ignore", category=FutureWarning)
warnings.filterwarnings("ignore", category=UserWarning, message="X does not have valid feature names")

print(f"--- Starting Model Training (Base Features: {BASE_MODEL_FEATURES}) ---")

# === Load Data ===
print(f"\n=== Loading Data ({INPUT_CSV_FILE}) ===")
try:
    df = pd.read_csv(INPUT_CSV_FILE, parse_dates=['timestamp'], index_col='timestamp')
    initial_rows = len(df)
    duplicates = df.index.duplicated(keep='first')
    if duplicates.sum() > 0:
        df = df[~duplicates]
        print(f"Removed {initial_rows - len(df)} duplicate timestamp entries.")
    print(f"Loaded {len(df)} unique rows.")

    if TARGET_COLUMN not in df.columns:
        raise ValueError(f"Target column '{TARGET_COLUMN}' not found.")

    # Load all base features plus the target column
    cols_to_load = list(set([TARGET_COLUMN] + BASE_MODEL_FEATURES))
    actual_cols = [col for col in cols_to_load if col in df.columns]
    missing_req_cols = [col for col in cols_to_load if col not in df.columns]
    if missing_req_cols:
         print(f"Warning: Columns missing from CSV needed for processing: {missing_req_cols}")
    df = df[actual_cols].copy()

except FileNotFoundError:
    print(f"Error: Input file not found at {INPUT_CSV_FILE}", file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f"Error loading or filtering data: {e}", file=sys.stderr)
    traceback.print_exc()
    sys.exit(1)

# === Preprocessing ===
print("\n=== Applying Preprocessing Strategy ===")
try:
    # 1. Clean z_height_mm (negatives)
    if 'z_height_mm' in df.columns:
        neg_mask = df['z_height_mm'] < 0
        if neg_mask.any():
             print(f"Cleaning {neg_mask.sum()} negative 'z_height_mm' values (setting to 0).")
             df.loc[neg_mask, 'z_height_mm'] = 0

    # 2. Impute NaNs in numeric columns before feature engineering
    numeric_features_to_impute = [
        'plug_temp_c', 'nozzle_temp_actual', 'bed_temp_actual', 'z_height_mm',
        'nozzle_temp_target', 'bed_temp_target', 'ambient_temp_c'
    ]
    for col in numeric_features_to_impute:
        if col in df.columns:
            num_nans = df[col].isnull().sum()
            if num_nans > 0:
                print(f"Imputed {num_nans} NaNs in '{col}' with {IMPUTE_VALUE_WHEN_API_MISSING}.")
                df[col].fillna(IMPUTE_VALUE_WHEN_API_MISSING, inplace=True)

    # --- NEW: Feature Engineering ---
    print("\n--- Performing Feature Engineering ---")
    # Create temperature delta features
    df['nozzle_temp_delta'] = df['nozzle_temp_target'] - df['nozzle_temp_actual']
    df['bed_temp_delta'] = df['bed_temp_target'] - df['bed_temp_actual']
    print("Created 'nozzle_temp_delta' and 'bed_temp_delta' features.")
    
    # --- NEW: Handle Categorical Features (One-Hot Encoding) ---
    print("\n--- Handling Categorical Features ---")
    if 'material' in df.columns:
        # Fill missing material values with a placeholder string
        df['material'].fillna('Unknown', inplace=True)
        print(f"Found materials: {df['material'].unique().tolist()}")
        
        # Perform one-hot encoding
        material_dummies = pd.get_dummies(df['material'], prefix='material', dtype=int)
        df = pd.concat([df, material_dummies], axis=1)
        print(f"One-hot encoded 'material' into columns: {material_dummies.columns.tolist()}")
        
        # Drop the original 'material' column as it's no longer needed
        df.drop('material', axis=1, inplace=True)
    else:
        print("Warning: 'material' column not found, skipping one-hot encoding.")

    # 4. Process is_printing (Boolean to Integer)
    if 'is_printing' in df.columns:
        df['is_printing'] = pd.to_numeric(df['is_printing'], errors='coerce').fillna(IMPUTE_VALUE_WHEN_API_MISSING).astype(int)
        print("Processed 'is_printing' column.")

    # 5. Drop rows with missing target variable
    initial_rows = len(df)
    df.dropna(subset=[TARGET_COLUMN], inplace=True)
    if len(df) < initial_rows:
        print(f"Dropped {initial_rows - len(df)} rows due to missing target variable '{TARGET_COLUMN}'.")

    # 6. Define FINAL feature list dynamically
    FINAL_MODEL_FEATURES = [
        'plug_temp_c', 'nozzle_temp_actual', 'bed_temp_actual', 'is_printing',
        'z_height_mm', 'nozzle_temp_target', 'bed_temp_target', 'ambient_temp_c',
        'nozzle_temp_delta', 'bed_temp_delta'  # Engineered features
    ]
    # Add the one-hot encoded material columns to the list
    material_dummy_columns = [col for col in df.columns if col.startswith('material_')]
    FINAL_MODEL_FEATURES.extend(material_dummy_columns)
    
    # Ensure all final features actually exist in the DataFrame, create if missing
    for col in FINAL_MODEL_FEATURES:
        if col not in df.columns:
            print(f"Warning: Expected feature '{col}' not found after processing. Creating as all zeros.")
            df[col] = 0

    # Create final feature matrix (X) and target vector (y)
    X = df[FINAL_MODEL_FEATURES]
    y = df[TARGET_COLUMN]

    print(f"\nPreprocessing complete. Final features count: {len(FINAL_MODEL_FEATURES)}")
    print(f"Shape of final feature matrix X: {X.shape}")
    print(f"Shape of final target vector y: {y.shape}")

except Exception as e:
     print(f"FATAL: Error during preprocessing: {e}", file=sys.stderr)
     traceback.print_exc()
     sys.exit(1)


# === Train/Test Split ===
print("\n=== Splitting Data (for final hold-out evaluation) ===")
if X.empty or y.empty:
    print("Error: No data available for training after preprocessing. Exiting.")
    sys.exit(1)

X_train_val, X_test, y_train_val, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
print(f"Training + Validation set size: {len(X_train_val)} rows")
print(f"Final Hold-out Test set size:  {len(X_test)} rows")


# === Scaling ===
print("\n=== Scaling Features ===")
scaler = StandardScaler()
X_train_val_scaled = scaler.fit_transform(X_train_val)
X_test_scaled = scaler.transform(X_test)
print("Features scaled (scaler fit on train+validation set).")

# Save the scaler and the EXACT column order it was fitted on
joblib.dump(scaler, os.path.join(MODEL_DIR, 'scaler.joblib'))
joblib.dump(X_train_val.columns.tolist(), os.path.join(MODEL_DIR, 'scaler_columns.joblib'))
print(f"Scaler and scaler columns saved. Columns: {X_train_val.columns.tolist()}")


# === Model Comparison using Cross-Validation ===
print("\n=== Model Comparison via Cross-Validation ===")
models = {
    'LinearRegression': LinearRegression(),
    'RandomForest': RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1),
}
if LGBM_AVAILABLE:
    models['LightGBM'] = lgb.LGBMRegressor(random_state=42, n_jobs=-1, verbosity=-1)
if XGB_AVAILABLE:
    models['XGBoost'] = xgb.XGBRegressor(random_state=42, n_jobs=-1, objective='reg:squarederror')

cv_strategy = KFold(n_splits=5, shuffle=True, random_state=42)
results_cv = {}
scoring_metric = 'neg_mean_absolute_error'

for name, model in models.items():
    print(f"--- Cross-validating {name} ---")
    try:
        cv_scores = cross_val_score(model, X_train_val_scaled, y_train_val,
                                    scoring=scoring_metric, cv=cv_strategy, n_jobs=-1)
        results_cv[name] = cv_scores
        print(f"CV Mean {scoring_metric}: {cv_scores.mean():.3f} +/- {cv_scores.std():.3f}")
    except Exception as e:
        print(f"Error cross-validating {name}: {e}")
        results_cv[name] = [np.nan]

# === Select Best Model Type Based on CV ===
best_model_name = None
best_cv_score = -np.inf
print("\n--- CV Results Summary (Mean Negative MAE) ---")
for name, scores in results_cv.items():
    mean_score = np.nanmean(scores)
    print(f"{name}: {mean_score:.3f}")
    if mean_score > best_cv_score:
        best_cv_score = mean_score
        best_model_name = name

if best_model_name is None:
    print("FATAL: No model performed successfully in cross-validation. Exiting.")
    sys.exit(1)
print(f"\nSelected best model type based on CV: {best_model_name} (Mean MAE: {-best_cv_score:.3f})")


# === Train Final Model & Evaluate on Hold-Out Test Set ===
print(f"\n=== Training Final {best_model_name} Model on Full Train+Validation Set ===")
if best_model_name == 'LinearRegression':
     final_model = LinearRegression()
elif best_model_name == 'RandomForest':
     final_model = RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1)
elif best_model_name == 'LightGBM' and LGBM_AVAILABLE:
     final_model = lgb.LGBMRegressor(random_state=42, n_jobs=-1, verbosity=-1)
elif best_model_name == 'XGBoost' and XGB_AVAILABLE:
     final_model = xgb.XGBRegressor(random_state=42, n_jobs=-1, objective='reg:squarederror')
else:
     print(f"Error: Best model '{best_model_name}' not recognized. Defaulting to RandomForest.")
     final_model = RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=-1)

try:
    final_model.fit(X_train_val_scaled, y_train_val)
    print("Final model training complete.")

    print(f"\n--- Evaluating Final {best_model_name} on Hold-Out Test Set ---")
    y_pred_final = final_model.predict(X_test_scaled)
    y_pred_final = np.maximum(0.0, y_pred_final)

    mae_final = mean_absolute_error(y_test, y_pred_final)
    rmse_final = np.sqrt(mean_squared_error(y_test, y_pred_final))
    r2_final = r2_score(y_test, y_pred_final)
    print(f"Final Test MAE:  {mae_final:.2f} W")
    print(f"Final Test RMSE: {rmse_final:.2f} W")
    print(f"Final Test R²:   {r2_final:.3f}")

    final_model_metrics = {
        "model_type": best_model_name,
        "mae": mae_final, "rmse": rmse_final, "r_squared": r2_final,
        "n_test_samples": len(y_test),
        "features_used": X_train_val.columns.tolist()
    }

    # Get Feature Importances
    if hasattr(final_model, 'feature_importances_'):
         print(f"\n--- {best_model_name} Feature Importances ---")
         importances = final_model.feature_importances_
         feature_importance_df = pd.DataFrame({
             'Feature': X_train_val.columns,
             'Importance': importances
         }).sort_values(by='Importance', ascending=False)
         print(feature_importance_df.to_string(index=False))
    elif hasattr(final_model, 'coef_'): # For Linear Regression
        print(f"\n--- {best_model_name} Coefficients ---")
        print(pd.Series(final_model.coef_, index=X_train_val.columns))

except Exception as e:
    print(f"FATAL: Error during final model training or evaluation: {e}", file=sys.stderr)
    traceback.print_exc()
    sys.exit(1)


# === Save Final Model Assets ===
print("\n--- Saving Final Model Assets ---")
try:
    # Use generic names for consistency in loading
    final_model_filename = os.path.join(MODEL_DIR, 'best_model.joblib')
    metrics_filename = os.path.join(MODEL_DIR, 'model_evaluation_metrics.joblib')
    features_filename = os.path.join(MODEL_DIR, 'model_features.joblib') # Will contain ALL final features

    # Save the final list of features the model expects (including one-hot encoded ones)
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

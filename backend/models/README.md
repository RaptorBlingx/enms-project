# ML Models Directory

This directory contains trained machine learning models for anomaly detection.

## Models Not Included

The following model files are excluded from the repository due to their size:
- `best_model.joblib` (394 MB) - Best performing ensemble model
- `random_forest_model.joblib` (103 MB) - Random Forest classifier  
- Other model files (*.joblib, *.pkl, *.h5)

## Training Your Own Models

Models can be trained locally using the provided training scripts.
They are automatically loaded by the `ml_worker` service if present.

Contact repository maintainers for pre-trained model access.

-- Part 5: Convert Tables to Hypertables (MUST RUN LAST)
SELECT create_hypertable('energy_data', 'timestamp');
SELECT create_hypertable('printer_status', 'timestamp');
SELECT create_hypertable('environment_data', 'timestamp');
SELECT create_hypertable('ml_predictions', 'timestamp');

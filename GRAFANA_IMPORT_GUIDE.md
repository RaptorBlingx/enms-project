# DEMO Grafana Dashboard Import Instructions

## Overview
The demo Grafana instance is running on **port 3002** and connects to the isolated `reg_ml_demo` database.

**Demo Grafana URL:** http://localhost:3002

## Default Credentials
- **Username:** admin
- **Password:** admin (you'll be prompted to change on first login)

## Available Dashboards for Import

The following production dashboards have been exported and are ready to import:

### Main Dashboards
1. **Fleet Operations & Machine** (`det3mvjccv6rkb_Fleet_Operations_&_Machine.json`)
   - Overview of all printers in the fleet
   - Device status, performance metrics
   - Will automatically show only DEMO devices due to database isolation

2. **Industrial Hybrid Edge System** (`de3xeh2upz400e_Industrial_Hybrid_Edge_System.json`)
   - Comprehensive system monitoring
   - Energy consumption, print jobs, ML predictions
   - All queries filtered to exclude DEMO_ prefix (production), but in demo shows only DEMO devices

3. **Machine Performance Comparison** (`eetag0y66ornke_Machine_Performance_Comparison.json`)
   - Compare performance across devices
   - Useful for demo scenarios

### Specialized Dashboards
4. **Sensor Data Explorer** (`cetamfgpx9mo0f_Sensor_Data_Explorer.json`)
   - Detailed sensor data visualization
   
5. **Prusa** (`dej62anu0b3swf_Prusa.json`)
   - Prusa-specific monitoring
   
6. **esp32** (`cemgg6la36vi8d_esp32.json`)
   - ESP32 device monitoring

## Import Steps

### Method 1: Via Web UI (Recommended)

1. Access demo Grafana: http://localhost:3002
2. Login with admin credentials
3. Click **+ (Plus icon)** → **Import dashboard**
4. Click **Upload JSON file**
5. Select a dashboard JSON from `/tmp/grafana_exports/`
6. Configure import options:
   - **Name:** Keep default or customize
   - **Folder:** Select or create folder (e.g., "DEMO Dashboards")
   - **UID:** Keep as-is (auto-generated if conflict)
   - **PostgreSQL:** Select the existing `PostgreSQL` data source
7. Click **Import**
8. Repeat for other dashboards

### Method 2: Via API (Batch Import)

```bash
# Set Grafana credentials
GRAFANA_URL="http://localhost:3002"
GRAFANA_USER="admin"
GRAFANA_PASS="admin"  # Change if you updated the password

# Import all dashboards
for file in /tmp/grafana_exports/*.json; do
    echo "Importing $(basename $file)..."
    curl -X POST \
        -H "Content-Type: application/json" \
        -u "$GRAFANA_USER:$GRAFANA_PASS" \
        -d @"$file" \
        "$GRAFANA_URL/api/dashboards/db"
    echo
done
```

## Data Source Configuration

The demo Grafana should already have a PostgreSQL data source configured from the Docker initialization. Verify it:

1. Go to **Configuration** (⚙️) → **Data sources**
2. Click on **PostgreSQL**
3. Verify settings:
   - **Host:** `postgres:5432` (internal Docker network)
   - **Database:** `reg_ml_demo`
   - **User:** `reg_ml_demo`
   - **TLS/SSL Mode:** disable
4. Click **Save & test**

## Post-Import Verification

After importing dashboards, verify they're showing DEMO device data:

1. Open **Fleet Operations & Machine** dashboard
2. Check the device dropdown - it should show:
   - DEMO_PrusaMK4_1 through DEMO_PrusaMK4_4
   - DEMO_PrusaMini_1 through DEMO_PrusaMini_4
   - DEMO_PrusaXL_1, DEMO_PrusaXL_2
   - DEMO_Ender3Pro_1, DEMO_Ender3Pro_2
   - DEMO_Ultimaker2Plus_1, DEMO_Ultimaker2Plus_2
   - DEMO_Voron24_1, DEMO_Voron24_2

3. Select a device and verify:
   - Real-time status updates (every 30 seconds)
   - Historical data from past 7 days
   - Energy consumption graphs
   - Print job history

## Troubleshooting

### No data showing in dashboards
- Check data source connection: Configuration → Data sources → PostgreSQL → Save & test
- Verify demo database has data:
  ```bash
  docker exec enms_demo_postgres psql -U reg_ml_demo -d reg_ml_demo \
    -c "SELECT COUNT(*) FROM printer_status WHERE device_id LIKE 'DEMO_%';"
  ```

### Dropdowns empty or showing wrong devices
- Dashboards may have hardcoded device filters from production
- Edit dashboard → Select panel → Edit query
- Remove any `AND device_id NOT LIKE 'DEMO_%'` filters (not needed in demo)

### Real-time updates not working
- Check demo-data-generator service:
  ```bash
  sudo systemctl status demo-data-generator.service
  ```
- View service logs:
  ```bash
  sudo journalctl -u demo-data-generator.service -f
  ```

## System Architecture

```
DEMO ENVIRONMENT (enms-demo):
├─ Grafana: localhost:3002 → enms_demo_grafana container
├─ PostgreSQL: localhost:5434 → enms_demo_postgres container
│  └─ Database: reg_ml_demo (16 DEMO devices)
├─ Real-time Generator: systemd service (demo-data-generator.service)
│  └─ Updates: Every 30 seconds
└─ Data: 7 days historical + continuous real-time

PRODUCTION ENVIRONMENT (unchanged):
├─ Grafana: localhost:3000 → Native systemd service
├─ PostgreSQL: localhost:5432/5433 → Native + Docker
│  └─ Database: reg_ml (0 DEMO devices)
└─ Real devices only
```

## Next Steps

1. Import the main dashboards (Fleet Operations, Industrial Hybrid Edge)
2. Verify data is displaying correctly
3. Test real-time updates (wait 30-60 seconds, refresh dashboard)
4. Customize dashboards for specific demo scenarios if needed
5. Create demo-specific dashboards focusing on key metrics

## Files Location

- **Dashboard JSONs:** `/tmp/grafana_exports/`
- **Real-time Generator:** `/home/ubuntu/enms-demo/realtime_demo_generator.py`
- **Service Config:** `/etc/systemd/system/demo-data-generator.service`
- **Demo Docker Config:** `/home/ubuntu/enms-demo/docker-compose.yml`

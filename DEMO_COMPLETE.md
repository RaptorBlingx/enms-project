# ✅ DEMO Environment - Complete Setup Summary

## 🎯 Mission Accomplished

**enms-demo** is now fully operational as a standalone simulation environment with 16 virtual 3D printers generating realistic mock data in real-time.

---

## 📊 System Overview

### Production Environment (UNTOUCHED)
- **Grafana:** http://localhost:3000 (native systemd)
- **Web Interface:** http://localhost:80
- **Database:** localhost:5432/5433 → `reg_ml` database
- **Status:** ✅ Clean - 0 DEMO devices, 0 mode-related code

### Demo Environment (FULLY OPERATIONAL)
- **Grafana:** http://localhost:3002
- **Web Interface:** http://localhost:8090
- **Database:** localhost:5434 → `reg_ml_demo` database
- **Status:** ✅ Running - 16 DEMO devices with real-time data

---

## 🖥️ Demo System Components

### 1. Database (PostgreSQL on port 5434)
```
reg_ml_demo database:
├─ 16 DEMO devices created
├─ 32,256 printer_status records (7 days historical)
├─ 32,256 energy_data records (7 days historical)  
├─ 50 print_jobs (completed)
└─ Continuous real-time updates every 30 seconds
```

**DEMO Devices:**
- 4× DEMO_PrusaMK4_1 through DEMO_PrusaMK4_4
- 4× DEMO_PrusaMini_1 through DEMO_PrusaMini_4
- 2× DEMO_PrusaXL_1, DEMO_PrusaXL_2
- 2× DEMO_Ender3Pro_1, DEMO_Ender3Pro_2
- 2× DEMO_Ultimaker2Plus_1, DEMO_Ultimaker2Plus_2
- 2× DEMO_Voron24_1, DEMO_Voron24_2

### 2. Real-Time Data Generator
- **Service:** `demo-data-generator.service` (systemd)
- **Location:** `/home/ubuntu/enms-demo/realtime_demo_generator.py`
- **Update Interval:** 30 seconds
- **Features:**
  - Realistic state transitions (Printing → Cooling → Idle)
  - Random print job starts
  - Variable temperatures during printing/heating
  - Power consumption based on device type and state
  - Occasional offline events for realism

**Check Status:**
```bash
sudo systemctl status demo-data-generator.service
sudo journalctl -u demo-data-generator.service -f
```

### 3. Grafana Dashboards (port 3002)
- **Credentials:** admin/admin (change on first login)
- **Data Source:** reg_ml_demo (PostgreSQL)
- **Dashboards Imported:**
  - Fleet Operations & Machine
  - Industrial Hybrid Edge System

**Access:**
- http://localhost:3002
- http://localhost:3002/d/demo_fleet_ops/fleet-operations-and-machine
- http://localhost:3002/d/demo_industrial_edge/industrial-hybrid-edge-system

### 4. Docker Stack
All containers running with `enms_demo_` prefix:
```bash
docker ps --filter "name=enms_demo"
```

Containers:
- `enms_demo_postgres` → Port 5434
- `enms_demo_grafana` → Port 3002
- `enms_demo_nodered` → Port 1882
- `enms_demo_mosquitto` → Port 1884
- `enms_demo_web_server` → Port 8090
- `enms_demo_device_api` → Port 5001
- `enms_demo_prediction_api` → Port 5002
- `enms_demo_prediction_worker` → Background

---

## 🧪 Verification Steps

### 1. Check Real-Time Data Generation
```bash
# View service logs (should show updates every 30 seconds)
sudo journalctl -u demo-data-generator.service -f

# Expected output:
# [HH:MM:SS] Updated: 3 printing, 7 idle, 6 offline
```

### 2. Query Database Directly
```bash
# Check latest printer statuses
docker exec enms_demo_postgres psql -U reg_ml_demo -d reg_ml_demo -c "
SELECT device_id, state_text, progress_percent, 
       ROUND(nozzle_temp_actual::numeric, 1) as temp,
       to_char(timestamp, 'MM-DD HH24:MI') as last_update
FROM printer_status 
WHERE device_id LIKE 'DEMO_%'
  AND timestamp = (
    SELECT MAX(timestamp) FROM printer_status ps2 
    WHERE ps2.device_id = printer_status.device_id
  )
ORDER BY device_id;"
```

### 3. Test Grafana Dashboards
1. Open http://localhost:3002
2. Login with admin/admin
3. Navigate to "Fleet Operations & Machine" dashboard
4. Verify:
   - Device dropdown shows only DEMO devices
   - Panels display data
   - Timestamps are recent (within last 30 seconds)
5. Wait 1 minute and refresh - data should update

### 4. Check Data Continuity
```bash
# Count records in last hour
docker exec enms_demo_postgres psql -U reg_ml_demo -d reg_ml_demo -c "
SELECT 
  COUNT(*) as total_records,
  COUNT(DISTINCT device_id) as devices,
  MIN(timestamp) as oldest,
  MAX(timestamp) as newest
FROM printer_status 
WHERE timestamp > NOW() - INTERVAL '1 hour'
  AND device_id LIKE 'DEMO_%';"
```

---

## 🔧 Management Commands

### Control Demo Data Generator
```bash
# Stop real-time updates
sudo systemctl stop demo-data-generator.service

# Start real-time updates
sudo systemctl start demo-data-generator.service

# Restart
sudo systemctl restart demo-data-generator.service

# View logs
sudo journalctl -u demo-data-generator.service -n 50
```

### Control Docker Stack
```bash
cd /home/ubuntu/enms-demo

# Stop entire demo environment
docker compose stop

# Start entire demo environment
docker compose up -d

# Restart specific service
docker compose restart grafana

# View logs
docker compose logs -f grafana
```

### Database Maintenance
```bash
# Connect to database
docker exec -it enms_demo_postgres psql -U reg_ml_demo -d reg_ml_demo

# Count all DEMO data
SELECT 
  (SELECT COUNT(*) FROM devices WHERE device_id LIKE 'DEMO_%') as devices,
  (SELECT COUNT(*) FROM printer_status WHERE device_id LIKE 'DEMO_%') as statuses,
  (SELECT COUNT(*) FROM energy_data WHERE device_id LIKE 'DEMO_%') as energy,
  (SELECT COUNT(*) FROM print_jobs WHERE device_id LIKE 'DEMO_%') as jobs;

# Clear old data (optional - keep last 7 days)
DELETE FROM printer_status 
WHERE timestamp < NOW() - INTERVAL '7 days'
  AND device_id LIKE 'DEMO_%';
```

---

## 📁 Important Files

### Configuration
- `/home/ubuntu/enms-demo/docker-compose.yml` - Docker stack definition
- `/home/ubuntu/enms-demo/.env` - Database credentials
- `/home/ubuntu/enms-demo/grafana/provisioning/datasources/datasource.yml` - Grafana data source config

### Scripts
- `/home/ubuntu/enms-demo/realtime_demo_generator.py` - Real-time data generator
- `/tmp/generate_demo_data.py` - Historical data generator (one-time use)

### Documentation
- `/home/ubuntu/enms-demo/GRAFANA_IMPORT_GUIDE.md` - Dashboard import instructions
- `/home/ubuntu/enms-demo/DEMO_CONFIGURATION.md` - Initial setup docs
- `/home/ubuntu/enms-demo/CURRENT_STATUS.md` - This file

### Exports
- `/tmp/grafana_exports/` - All exported production dashboards (for importing more)

### Service Definition
- `/etc/systemd/system/demo-data-generator.service` - Systemd service config

---

## 🎬 Demo Scenarios

### Scenario 1: Fleet Overview
1. Open Fleet Operations dashboard
2. Show 16 virtual printers
3. Point out mix of states (printing, idle, offline)
4. Show real-time progress updates

### Scenario 2: Individual Printer Monitoring
1. Select a printing device from dropdown
2. Show temperature graphs
3. Show power consumption
4. Show print progress

### Scenario 3: Historical Analysis
1. Open Industrial Hybrid Edge dashboard
2. Show 7-day energy consumption trends
3. Show print job history
4. Compare printer performance

### Scenario 4: Real-Time Updates
1. Keep dashboard open
2. Wait 30-60 seconds
3. Show automatic data refresh
4. Point out changing progress bars

---

## 🚨 Troubleshooting

### No data in Grafana
```bash
# Check data source
curl -u admin:admin http://localhost:3002/api/datasources/1/health

# Should return: "Database Connection OK"
```

### Data not updating
```bash
# Check generator service
sudo systemctl status demo-data-generator.service

# If not running:
sudo systemctl start demo-data-generator.service
```

### Grafana not accessible
```bash
# Check container
docker ps --filter "name=enms_demo_grafana"

# If not running:
cd /home/ubuntu/enms-demo
docker compose up -d grafana
```

### Database connection issues
```bash
# Test database connectivity
docker exec enms_demo_postgres psql -U reg_ml_demo -d reg_ml_demo -c "SELECT version();"

# Check PostgreSQL logs
docker logs enms_demo_postgres --tail 50
```

---

## 📈 Current Status

**Last Updated:** 2025-10-31

✅ **All Systems Operational**

| Component | Status | Details |
|-----------|--------|---------|
| Database | 🟢 Running | 16 devices, 64K+ records |
| Data Generator | 🟢 Active | Updating every 30s |
| Grafana | 🟢 Online | 2 dashboards imported |
| Docker Stack | 🟢 Up | All 8 containers running |
| Production | 🟢 Unchanged | Isolated and clean |

**Data Statistics:**
- Printer Status Records: 32,256+
- Energy Data Records: 32,256+
- Print Jobs: 50+
- Continuous Updates: Since 14:54 UTC

---

## 🎯 Next Steps (Optional Enhancements)

1. **Import Additional Dashboards**
   - Machine Performance Comparison
   - Sensor Data Explorer
   - Custom demo-specific dashboards

2. **Customize Data Patterns**
   - Edit `/home/ubuntu/enms-demo/realtime_demo_generator.py`
   - Adjust state transition probabilities
   - Modify power consumption ranges
   - Add more realistic print job patterns

3. **Web Interface Configuration**
   - Configure web server (port 8090) to show demo devices
   - Customize DPP pages for demo scenarios

4. **ML Predictions**
   - Generate mock ML prediction data
   - Show anomaly detection scenarios

5. **Create Demo-Specific Dashboards**
   - Build custom dashboards optimized for presentations
   - Add annotations for key demo points
   - Create time-lapse panels

---

## 🔐 Security Notes

- Demo environment uses separate credentials (`raptorblingx_demo`)
- Completely isolated from production data
- No connection between production and demo databases
- Safe to demo without exposing real device data

---

## 📞 Support

**Key Commands Quick Reference:**
```bash
# Check everything
sudo systemctl status demo-data-generator.service
docker ps --filter "name=enms_demo"
docker exec enms_demo_postgres psql -U reg_ml_demo -d reg_ml_demo -c "SELECT COUNT(*) FROM printer_status WHERE device_id LIKE 'DEMO_%' AND timestamp > NOW() - INTERVAL '5 minutes';"

# Restart everything
sudo systemctl restart demo-data-generator.service
cd /home/ubuntu/enms-demo && docker compose restart

# View real-time logs
sudo journalctl -u demo-data-generator.service -f
docker compose -f /home/ubuntu/enms-demo/docker-compose.yml logs -f grafana
```

---

## ✨ Success Metrics

- ✅ 16 virtual 3D printers operational
- ✅ 7 days of historical data
- ✅ Real-time updates every 30 seconds  
- ✅ 2 production-quality dashboards
- ✅ 100% production isolation
- ✅ Fully automated data generation
- ✅ Zero manual intervention required

**The demo environment is now ready for presentations, testing, and development!** 🎉

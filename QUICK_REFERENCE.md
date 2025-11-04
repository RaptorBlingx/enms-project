# 🚀 Industrial Hybrid Edge Dashboard - Quick Reference

## ✅ Status: FULLY OPERATIONAL

---

## Dashboard Access

**URL:** http://localhost:3002/d/de3xeh2upz400e/industrial-hybrid-edge-system  
**Login:** admin / admin  
**Time Range:** Last 5 minutes (adjustable)

---

## What's Working (100%)

✅ **Power Monitoring** (5 panels)
- Real-time power, voltage, current, power factor
- Instant power + hotend temperature overlay
- Efficiency metrics

✅ **Temperature Sensors** (4 panels)
- MAX6675 hotend temperature (time series + gauge)
- DHT22 ambient temperature
- Generic temperature readings

✅ **Motion Sensors** (4 panels)
- MPU6050 3-axis accelerometer
- MPU6050 3-axis gyroscope
- Vibration analysis with correlations
- Movement pattern recognition

✅ **Environmental** (2 panels)
- DHT22 humidity sensor
- Ambient conditions

✅ **Energy Analysis** (2 panels)
- DEMO printer energy consumption
- Actual vs predicted power (ML)

✅ **Weather Integration** (6 panels)
- Hamburg temperature & humidity
- 264 weather forecasts
- Rain/snow precipitation analysis
- Weather tables and time series

✅ **Smart Plug Metrics** (5 panels)
- Total energy (kWh)
- Current (A)
- Power (W)
- Power factor
- Voltage (V)

---

## Live Data Sources

| Sensor | Device ID | Update Interval | Records |
|--------|-----------|-----------------|---------|
| Hotend Temp | ESP32_SensorHub_Raptor | 30s | 20,160+ |
| Smart Plug | SmartPlug_3DPrinter_01 | 30s | 20,160+ |
| Accelerometer | ESP32_SensorHub_Raptor | 30s | 20,160+ |
| Gyroscope | ESP32_SensorHub_Raptor | 30s | 20,160+ |
| DHT22 | ESP32_SensorHub_Raptor | 30s | 20,160+ |
| Weather | Hamburg | 10min | 264 |
| Energy | DEMO_Printer_01-16 | 30s | 41,232 |

---

## Services Status

```bash
# Check all services
sudo systemctl status demo-iot-generator.service
sudo systemctl status demo-data-generator.service
docker ps | grep enms_demo
```

**Expected:** All RUNNING ✅

---

## Quick Troubleshooting

### No Data Showing?
1. **Check time range** - Set to "Last 5 minutes" or "Last 1 hour"
2. **Refresh page** - Press F5 or click refresh icon
3. **Verify services:**
   ```bash
   sudo systemctl restart demo-iot-generator.service
   ```

### Dashboard Won't Load?
```bash
docker restart enms_demo_grafana
# Wait 10 seconds, then refresh browser
```

### Need to See Logs?
```bash
# IoT sensor logs
sudo journalctl -u demo-iot-generator.service -f

# Printer logs
sudo journalctl -u demo-data-generator.service -f

# Grafana logs
docker logs enms_demo_grafana --tail 50 -f
```

---

## Test Queries

Verify data in database:

```bash
docker exec enms_demo_postgres psql -U reg_ml_demo -d reg_ml_demo -t -c "
SELECT 
  'Hotend: ' || ROUND(temperature_c::numeric, 1) || '°C, ' ||
  'Ambient: ' || ROUND((SELECT temperature_c FROM dht22_data ORDER BY timestamp DESC LIMIT 1)::numeric, 1) || '°C, ' ||
  'Power: ' || ROUND((SELECT power_w FROM smartplug_data ORDER BY timestamp DESC LIMIT 1)::numeric, 1) || 'W'
FROM max6675_temperature_data 
ORDER BY timestamp DESC LIMIT 1;
"
```

---

## Key Files

| File | Purpose |
|------|---------|
| `/home/ubuntu/enms-demo/grafana/dashboards/Industrial-Hybrid-Edge-System.json` | Dashboard config |
| `/home/ubuntu/enms-demo/realtime_iot_generator.py` | Real-time sensor simulator |
| `/etc/systemd/system/demo-iot-generator.service` | IoT service config |
| `/home/ubuntu/enms-demo/DASHBOARD_SYSTEMATIC_FIX.md` | Complete fix documentation |

---

## Data Summary

- **Total Dashboard Panels:** 38 (28 data + 10 rows)
- **Working Panels:** 28/28 (100%)
- **Database Tables:** 10 IoT tables
- **Total Records:** 180,000+
- **Historical Range:** 7 days
- **Real-time Updates:** Every 30 seconds
- **Weather Forecasts:** 264 records (24h rolling)

---

## Issues Fixed

- ❌ 15+ "No data" errors → ✅ All panels showing data
- ❌ 12 datasource errors → ✅ All using PostgreSQL
- ❌ 9 MQTT dependencies → ✅ Converted to SQL queries
- ❌ 2 missing queries → ✅ SQL queries added
- ❌ Weather UID mismatch → ✅ Fixed datasource references

---

## Success Criteria

✅ All 28 data panels displaying values  
✅ No "No data" errors  
✅ No datasource errors  
✅ Real-time updates every 30s  
✅ Historical data accessible (7 days)  
✅ All sensors synchronized with printer activity  
✅ Services running continuously  
✅ Dashboard editable and customizable  

---

## 🎉 READY FOR DEMONSTRATION

**Dashboard Health:** 100%  
**All Systems:** OPERATIONAL  
**Last Updated:** 2025-10-31  

Access now: http://localhost:3002/d/de3xeh2upz400e/industrial-hybrid-edge-system

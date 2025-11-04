# ENMS Demo Environment - Current Status

**Date**: 2025-10-31  
**Status**: ✅ Infrastructure Running

## Services Status

All Docker services are running and healthy:

```
SERVICE                     STATUS              PORTS
enms_demo_postgres          Up (healthy)        0.0.0.0:5434->5432/tcp
enms_demo_grafana           Up                  0.0.0.0:3002->3000/tcp
enms_demo_nodered           Up (healthy)        0.0.0.0:1882->1880/tcp
enms_demo_mosquitto         Up                  0.0.0.0:1884->1883/tcp
enms_demo_python_api        Up                  5000/tcp (internal)
enms_demo_web_server        Up                  0.0.0.0:8090->80/tcp
enms_demo_ml_worker         Restarting          (missing model files - non-critical)
```

## Access URLs

- **Web Interface**: http://localhost:8090
- **Grafana**: http://localhost:3002
- **Node-RED**: http://localhost:1882
- **Database**: localhost:5434 (user: reg_ml_demo, db: reg_ml_demo)

## Database Status

✅ **Schema Initialized**: 20 tables created  
✅ **Devices Loaded**: 17 production devices copied from initialization scripts

Current devices:
- 3x Prusa MK4
- 2x Prusa Mini
- 1x Prusa XL
- 1x Ender 3 Pro
- 3x Ultimaker 2/2+
- 4x Prusa i3 MK2/MK2S
- 1x Voron 2.4
- 1x Environment sensor

## Isolation Verification

✅ **Ports**: All demo ports different from production (5434, 3002, 1882, 1884, 8090)  
✅ **Volumes**: All volumes use `_demo` suffix  
✅ **Containers**: All containers use `enms_demo_` prefix  
✅ **Database**: Separate credentials (reg_ml_demo vs reg_ml)  
✅ **Production**: Original enms-project untouched and running

## Next Steps

1. **Create DEMO devices**
   - Add 16 devices with `DEMO_` prefix
   - Configure device metadata
   
2. **Generate mock data**
   - Implement data generator for DEMO devices
   - Populate historical data
   
3. **Configure Grafana**
   - Import dashboards with mode dropdown
   - Fleet Operations dashboard
   - Industrial Hybrid Edge dashboard
   
4. **Test complete system**
   - Verify DEMO mode functionality
   - Confirm production isolation

## Known Issues

- ML worker container restarting due to missing model files (`/models/best_model.joblib`)
  - **Impact**: Low - not required for basic DEMO functionality
  - **Fix**: Copy model files from production or disable service

## Production Environment

The original production system remains completely untouched:

- Database: PostgreSQL on port 5433 (Docker) + native on 5432
- Grafana: Port 3001
- Node-RED: Port 1881
- Web: Port 8080
- All production data intact
- All services running normally


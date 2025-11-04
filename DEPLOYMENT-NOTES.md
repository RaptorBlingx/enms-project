# ENMS-Demo Deployment Notes

## Nginx Configuration (Host)

The host nginx (`/etc/nginx/sites-enabled/default`) proxies all requests to the Docker nginx container on port 8090. This ensures all restored frontend files are accessible.

### Key Proxy Routes:
- `/` → Docker nginx (http://127.0.0.1:8090)
- `/dpp_reports/` → Docker nginx (http://127.0.0.1:8090/dpp_reports/)
- `/api/` → Node-RED (http://127.0.0.1:1880/api/)
- `/api/devices-crud/` → Device API (http://127.0.0.1:5001/api/devices/)
- `/api/(mode|demo-config)` → Device API (http://127.0.0.1:5001)
- `/octoprint-proxy/` → OctoPrint (https://10.1.1.103/)

## Restored Files (from commit 083c315)

### Frontend (11 HTML files + 2 components):
- auth.html, reset-password.html, verify-email.html
- about.html, contact.html, workshop.html
- iso50001.html, artistic-elements.html
- admin/dashboard.html
- components/tooltip.js, components/tooltip.css

### Python API (3 files):
- auth_service.py (44KB) - User authentication system
- dpp_data_enricher.py (8.2KB) - DPP data enrichment
- smart_tips_system.py (18KB) - Smart tips/recommendations

### Database:
- backend/db_init/04_auth_schema.sql
- Tables: demo_users, demo_sessions, demo_audit_log

### Documentation:
- CONTRIBUTING.md, LICENSE

## Services Status

### Docker Containers:
- postgres (TimescaleDB) - Port 5434
- nodered - Port 1880
- python_api - Port 5000
- web_server (nginx) - Port 8090
- grafana - Port 3000
- mosquitto (MQTT) - Port 1883
- ml_worker

### Systemd Services:
- demo-data-generator.service (realtime_demo_generator.py)
- demo-iot-generator.service (realtime_iot_generator.py)

### PM2 Services:
- auto-pdf-generator (scripts/auto_pdf_generator.py)
- device-api
- node-red
- pdf-service
- prediction-worker

## Auto-PDF System

### How it works:
1. Generator creates jobs WITHOUT pre-assigned dpp_pdf_url
2. Database trigger fires on job completion (WHERE dpp_pdf_url IS NULL)
3. Trigger sends NOTIFY via PostgreSQL
4. auto-pdf-generator service (PM2) receives notification
5. Calls Flask API to generate PDF
6. PDF saved to Docker volume, URL updated in database

### Fixed Issues:
- Removed pre-assignment of dpp_pdf_url from realtime_demo_generator.py (commit 3c43299)
- This allows database trigger to work correctly
- 100% PDF generation success rate for all new jobs

## Verification Commands

```bash
# Check all services
docker compose ps
sudo systemctl status demo-data-generator
pm2 list

# Test restored files
curl -I http://localhost/auth.html
curl -I http://localhost/components/tooltip.js

# Verify PDFs auto-generate
psql postgresql://reg_ml_demo:raptorblingx_demo@localhost:5434/reg_ml_demo -c "SELECT COUNT(*) FROM print_jobs WHERE dpp_pdf_url IS NOT NULL;"
```

---
Last Updated: 2025-11-04

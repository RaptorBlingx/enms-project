# ENMS DEMO Environment Configuration

## Overview
This is the **DEMO** environment clone of the ENMS project, completely isolated from the production system.

## Key Differences from Production

### Database
- **Name**: `reg_ml_demo` (vs `reg_ml`)
- **User**: `reg_ml_demo` (vs `reg_ml`)
- **Password**: `raptorblingx_demo`
- **Port**: 5434 (vs 5433 production, 5432 native)

### Service Ports
| Service | Production | Demo | Notes |
|---------|-----------|------|-------|
| PostgreSQL | 5433 | 5434 | Native PostgreSQL on 5432 |
| Grafana | 3001 | 3002 | |
| Node-RED | 1881 | 1882 | |
| MQTT | 1883 | 1884 | |
| Web Server | 8080 | 8090 | |

### Docker Volumes
All volumes use `_demo` suffix to prevent conflicts:
- `postgres_data_demo`
- `grafana_data_demo`
- `generated_pdfs_demo`
- `mosquitto_data_demo`
- `mosquitto_config_demo`
- `gcode_previews_data_demo`

### Container Names
All containers prefixed with `enms_demo_`:
- `enms_demo_postgres`
- `enms_demo_grafana`
- `enms_demo_nodered`
- `enms_demo_mosquitto`
- `enms_demo_ml_worker`
- `enms_demo_python_api`
- `enms_demo_web_server`

## Access URLs

After starting the stack:
- **Web Interface**: http://localhost:8080
- **Grafana**: http://localhost:3001
- **Node-RED**: http://localhost:1881
- **PostgreSQL**: localhost:5433

## Starting the Demo Environment

```bash
cd /home/ubuntu/enms-demo
docker-compose up -d
```

## Checking Status

```bash
docker-compose ps
docker-compose logs -f [service_name]
```

## Stopping the Demo Environment

```bash
cd /home/ubuntu/enms-demo
docker-compose down
```

## Database Setup

After first start, you'll need to:
1. Create DEMO devices (16 devices with DEMO_ prefix)
2. Migrate mock data
3. Configure dashboards with LIVE/DEMO mode support

## Isolation Verification

The DEMO environment is completely isolated:
- ✅ Separate database (reg_ml_demo)
- ✅ Different ports (no conflicts)
- ✅ Separate Docker volumes
- ✅ Different container names
- ✅ Separate MQTT credentials
- ✅ Independent Node-RED flows

Production system remains untouched and continues running normally.

## Next Steps

1. Start the stack: `docker-compose up -d`
2. Wait for all services to be healthy
3. Create demo database schema
4. Implement DEMO mode features
5. Test isolation


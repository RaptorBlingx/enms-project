# DPP Auto PDF Generation - Permanent Solution

## Problem Solved
Previously, print jobs were created with pre-assigned `dpp_pdf_url` values in the database, but the actual PDF files were never generated. This caused 404 errors when trying to access the PDFs.

## Solution Implemented

### 1. Database Trigger (Automatic)
Created a PostgreSQL trigger that fires when a job is completed:

```sql
CREATE TRIGGER auto_generate_pdf
    AFTER INSERT OR UPDATE OF status
    ON print_jobs
    FOR EACH ROW
    WHEN (NEW.status = 'completed' AND NEW.dpp_pdf_url IS NULL)
    EXECUTE FUNCTION trigger_pdf_generation();
```

- **Trigger Function**: `trigger_pdf_generation()` sends notifications via `pg_notify('pdf_generation_queue', job_id)`
- **Activates**: Only when job status = 'completed' AND dpp_pdf_url IS NULL
- **Result**: Real-time PDF generation requests

### 2. Auto PDF Generator Service (PM2)
Located: `/home/ubuntu/enms-demo/scripts/auto_pdf_generator.py`

**Features:**
- Listens to PostgreSQL LISTEN/NOTIFY channel
- Generates PDFs immediately when notified
- Performs periodic backfill checks (every 30 seconds)
- Auto-reconnects on connection failures
- Managed by PM2 for reliability

**Status:**
```bash
pm2 list | grep auto-pdf-generator
pm2 logs auto-pdf-generator
```

### 3. PDF Service (Docker Container)
- Container: `enms_demo_python_api`
- Endpoint: `http://localhost:5000/api/generate_dpp_pdf`
- Accepts: `{"job_id": <id>}`
- Returns: `{"success": true, "pdf_url": "/dpp_reports/dpp_job_<id>.pdf"}`
- Updates `dpp_pdf_url` in database automatically

## How It Works

1. **Job Completes** → Database trigger fires
2. **Trigger** → Sends notification: `pg_notify('pdf_generation_queue', '1035')`
3. **Auto PDF Generator** → Receives notification → Calls PDF API
4. **PDF Service** → Generates PDF → Saves to Docker volume → Updates database
5. **Result** → PDF accessible at `/dpp_reports/dpp_job_<id>.pdf`

## Benefits

✅ **Real-time**: PDFs generate within seconds of job completion
✅ **Reliable**: Database-driven, survives restarts
✅ **Automatic**: No manual intervention needed
✅ **Scalable**: Can handle multiple concurrent jobs
✅ **Self-healing**: Periodic backfill catches any missed PDFs

## Verification

### Check Trigger Status
```bash
docker exec enms_demo_postgres psql -U reg_ml_demo -d reg_ml_demo -c "\d print_jobs" | grep -A3 "Triggers:"
```

### Check Service Status
```bash
pm2 list | grep auto-pdf
```

### Test PDF Generation
```sql
-- Create test job
INSERT INTO print_jobs (device_id, filename, status, kwh_consumed) 
VALUES ('printer_1', 'test.gcode', 'completed', 0.15) 
RETURNING job_id;

-- Check PDF was generated (wait 5 seconds)
SELECT job_id, dpp_pdf_url FROM print_jobs WHERE job_id = <returned_id>;
```

## Backup Location
Backup of original files: `/home/ubuntu/enms-demo/backups/20251104_074832/`

## Files Modified
1. `scripts/auto_pdf_generator.py` - NEW: Notification listener service
2. `setup_pdf_trigger.sql` - Database trigger definition
3. `python-api/pdf_service.py` - Already working, no changes needed

## Maintenance

### Stop Auto-PDF Generation
```bash
pm2 stop auto-pdf-generator
```

### Start Auto-PDF Generation
```bash
pm2 start auto-pdf-generator
```

### Disable Trigger
```sql
DROP TRIGGER IF EXISTS auto_generate_pdf ON print_jobs;
```

### Re-enable Trigger
```bash
docker exec -i enms_demo_postgres psql -U reg_ml_demo -d reg_ml_demo < setup_pdf_trigger.sql
```

## Troubleshooting

### PDFs Not Generating
1. Check auto-pdf-generator is running: `pm2 status`
2. Check logs: `pm2 logs auto-pdf-generator`
3. Check PDF service: `curl http://localhost:5000/health`
4. Check trigger exists: Query above

### 404 Errors on Old PDFs
Run manual backfill:
```bash
cd /home/ubuntu/monitor_ml
python3 backfill_all_pdfs.py
```

## Next Steps (Optional)

If you want to re-enable demo data generators, you'll need to:
1. Recreate the generator scripts (they were removed)
2. Update them to NOT pre-assign `dpp_pdf_url` values
3. Let the trigger handle PDF generation automatically

---
**Status**: ✅ Production Ready
**Last Updated**: November 4, 2025
**Tested**: Yes - Trigger fires correctly, notifications received

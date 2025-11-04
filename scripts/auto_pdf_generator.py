#!/usr/bin/env python3
"""
Auto PDF Generator - Listens for database notifications and generates PDFs
Uses PostgreSQL LISTEN/NOTIFY for real-time PDF generation
"""

import psycopg2
import psycopg2.extensions
import requests
import time
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

DB_CONFIG = {
    'host': 'localhost',
    'port': 5434,
    'database': 'reg_ml_demo',
    'user': 'reg_ml_demo',
    'password': 'raptorblingx_demo'
}

PDF_API_URL = "http://localhost:5000/api/generate_dpp_pdf"

def generate_pdf(job_id):
    """Generate PDF for a job"""
    try:
        response = requests.post(
            PDF_API_URL,
            json={"job_id": job_id},
            timeout=30
        )
        
        if response.status_code == 200:
            result = response.json()
            if result.get('success'):
                logger.info(f"✅ Generated PDF for job {job_id}: {result.get('pdf_url')}")
                return True
            else:
                logger.error(f"❌ Failed to generate PDF for job {job_id}: {result.get('error')}")
        else:
            logger.error(f"❌ HTTP {response.status_code} for job {job_id}")
        
        return False
    except Exception as e:
        logger.error(f"❌ Exception generating PDF for job {job_id}: {e}")
        return False

def backfill_missing_pdfs(conn):
    """Check for any jobs that need PDFs"""
    try:
        cur = conn.cursor()
        cur.execute("""
            SELECT job_id FROM print_jobs 
            WHERE status = 'completed' 
            AND dpp_pdf_url IS NULL 
            ORDER BY end_time DESC
            LIMIT 50
        """)
        
        missing = cur.fetchall()
        if missing:
            logger.info(f"Found {len(missing)} jobs without PDFs, generating...")
            for (job_id,) in missing:
                generate_pdf(job_id)
                time.sleep(0.5)  # Rate limit
        
        cur.close()
    except Exception as e:
        logger.error(f"Error in backfill: {e}")

def main():
    """Main loop - listens for notifications and generates PDFs"""
    logger.info("🚀 Starting Auto PDF Generator with LISTEN/NOTIFY...")
    
    while True:
        conn = None
        try:
            # Connect to database
            conn = psycopg2.connect(**DB_CONFIG)
            conn.set_isolation_level(psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)
            cur = conn.cursor()
            
            # Listen for notifications
            cur.execute("LISTEN pdf_generation_queue;")
            logger.info("📡 Listening for PDF generation notifications...")
            
            # Do initial backfill
            backfill_missing_pdfs(conn)
            
            # Main notification loop
            while True:
                # Wait for notifications (10 second timeout)
                if conn.poll() == psycopg2.extensions.POLL_OK:
                    while conn.notifies:
                        notify = conn.notifies.pop(0)
                        job_id = int(notify.payload)
                        logger.info(f"📨 Received notification for job {job_id}")
                        generate_pdf(job_id)
                
                # Periodic check every 30 seconds for missed jobs
                time.sleep(30)
                backfill_missing_pdfs(conn)
                
        except KeyboardInterrupt:
            logger.info("🛑 Shutting down...")
            break
        except Exception as e:
            logger.error(f"❌ Error: {e}")
            logger.info("Reconnecting in 10 seconds...")
            time.sleep(10)
        finally:
            if conn:
                conn.close()

if __name__ == "__main__":
    main()

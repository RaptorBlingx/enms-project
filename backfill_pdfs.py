#!/usr/bin/env python3
"""
Backfill script to generate PDFs for all print jobs that are missing them
"""

import requests
import psycopg2
import os
import time

# Database connection
DB_CONFIG = {
    'dbname': 'reg_ml_demo',
    'user': 'reg_ml_demo',
    'password': 'raptorblingx_demo',
    'host': 'localhost',
    'port': 5434
}

API_URL = 'http://localhost:5000/api/generate_dpp_pdf'

def main():
    print("=" * 70)
    print("PDF Backfill Script")
    print("=" * 70)
    
    try:
        # Connect to database
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        # Find all jobs that need PDFs
        cursor.execute("""
            SELECT job_id, device_id, filename, 
                   dpp_pdf_url,
                   TO_CHAR(end_time, 'YYYY-MM-DD HH24:MI:SS') as end_time
            FROM print_jobs
            WHERE status = 'completed'
            ORDER BY end_time DESC
        """)
        
        jobs = cursor.fetchall()
        print(f"\nFound {len(jobs)} completed jobs in database")
        
        # Check which PDFs actually exist
        missing_pdfs = []
        for job in jobs:
            job_id, device_id, filename, pdf_url, end_time = job
            
            # Check if PDF file exists
            if pdf_url:
                pdf_filename = pdf_url.split('/')[-1]
                pdf_path = f'/var/www/html/dpp_reports/{pdf_filename}'
                if not os.path.exists(pdf_path):
                    missing_pdfs.append((job_id, device_id, filename, end_time, pdf_url))
            else:
                missing_pdfs.append((job_id, device_id, filename, end_time, None))
        
        print(f"Found {len(missing_pdfs)} jobs with missing PDFs")
        
        if not missing_pdfs:
            print("\n✅ All jobs have valid PDFs!")
            return
        
        # Generate PDFs for missing jobs
        print(f"\nGenerating PDFs for {len(missing_pdfs)} jobs...")
        print("-" * 70)
        
        success_count = 0
        fail_count = 0
        
        for i, (job_id, device_id, filename, end_time, old_url) in enumerate(missing_pdfs, 1):
            try:
                print(f"[{i}/{len(missing_pdfs)}] Job {job_id} ({device_id} - {filename})...")
                
                response = requests.post(
                    API_URL,
                    json={'job_id': job_id},
                    timeout=30
                )
                
                if response.status_code == 200:
                    result = response.json()
                    if result.get('success'):
                        print(f"  ✅ Generated: {result.get('pdf_url')}")
                        success_count += 1
                    else:
                        print(f"  ❌ Failed: {result.get('error', 'Unknown error')}")
                        fail_count += 1
                else:
                    print(f"  ❌ HTTP {response.status_code}: {response.text[:100]}")
                    fail_count += 1
                
                # Small delay to avoid overwhelming the service
                time.sleep(0.2)
                
            except Exception as e:
                print(f"  ❌ Error: {e}")
                fail_count += 1
        
        print("-" * 70)
        print(f"\n📊 Results:")
        print(f"  ✅ Success: {success_count}")
        print(f"  ❌ Failed: {fail_count}")
        print(f"  📄 Total: {len(missing_pdfs)}")
        
        cursor.close()
        conn.close()
        
    except Exception as e:
        print(f"❌ Fatal error: {e}")
        import traceback
        traceback.print_exc()

if __name__ == '__main__':
    main()

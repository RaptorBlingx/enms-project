#!/usr/bin/env python3
"""
Backfill all PDFs for completed print jobs.
This will regenerate PDFs with the correct plant types and images.
"""
import psycopg2
import requests
import time
import sys

# Database configuration
DB_CONFIG = {
    'host': 'localhost',
    'port': 5434,
    'database': 'reg_ml_demo',
    'user': 'reg_ml_demo',
    'password': 'raptorblingx_demo'
}

# PDF service API endpoint
PDF_SERVICE_URL = 'http://localhost:5000/api/generate_dpp_pdf'

def backfill_pdfs():
    """Regenerate all PDFs for completed jobs"""
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    
    # Get all completed jobs
    cur.execute("""
        SELECT job_id, filename, dpp_pdf_url
        FROM print_jobs 
        WHERE status = 'completed'
        ORDER BY job_id
    """)
    
    jobs = cur.fetchall()
    total_jobs = len(jobs)
    
    print(f"\n{'='*80}")
    print(f"PDF BACKFILL - Regenerating {total_jobs} PDFs")
    print(f"{'='*80}\n")
    
    success_count = 0
    error_count = 0
    errors = []
    
    for idx, (job_id, filename, existing_pdf_url) in enumerate(jobs, 1):
        try:
            response = requests.post(
                PDF_SERVICE_URL,
                json={'job_id': job_id},
                timeout=30
            )
            
            if response.status_code == 200:
                result = response.json()
                if result.get('success'):
                    success_count += 1
                else:
                    error_count += 1
                    errors.append(f"Job {job_id}: {result.get('message', 'Unknown error')}")
            else:
                error_count += 1
                errors.append(f"Job {job_id}: HTTP {response.status_code}")
                
        except Exception as e:
            error_count += 1
            errors.append(f"Job {job_id}: {str(e)}")
        
        # Progress indicator
        if idx % 50 == 0:
            print(f"Progress: {idx}/{total_jobs} ({100*idx/total_jobs:.1f}%)")
        
        # Small delay to avoid overwhelming the service
        time.sleep(0.1)
    
    conn.close()
    
    # Print summary
    print(f"\n{'='*80}")
    print(f"BACKFILL COMPLETE")
    print(f"{'='*80}")
    print(f"✅ Success: {success_count}/{total_jobs}")
    print(f"❌ Errors:  {error_count}/{total_jobs}")
    
    if errors and len(errors) <= 10:
        print(f"\nError details:")
        for error in errors:
            print(f"  - {error}")
    elif errors:
        print(f"\nFirst 10 errors:")
        for error in errors[:10]:
            print(f"  - {error}")
        print(f"  ... and {len(errors) - 10} more errors")
    
    print(f"\n{'='*80}\n")

if __name__ == '__main__':
    print("Starting PDF backfill process...")
    print("This will regenerate ALL PDFs with correct plant images.")
    print("Press Ctrl+C to cancel within 3 seconds...")
    time.sleep(3)
    backfill_pdfs()

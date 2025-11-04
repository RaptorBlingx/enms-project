#!/bin/bash
# Bulk regenerate PDFs for all completed DEMO jobs

echo "=== Bulk PDF Regeneration for DEMO Jobs ==="
echo ""

# Get all completed DEMO job IDs
job_ids=$(docker exec enms_demo_postgres psql -U reg_ml_demo -d reg_ml_demo -t -c \
  "SELECT job_id FROM print_jobs WHERE device_id LIKE 'DEMO%' AND status='completed' ORDER BY job_id ASC")

total=$(echo "$job_ids" | wc -l)
current=0
success=0
failed=0

echo "Found $total jobs to regenerate"
echo ""

for job_id in $job_ids; do
  # Skip empty lines
  if [ -z "$job_id" ]; then
    continue
  fi
  
  current=$((current + 1))
  
  # Generate PDF
  result=$(curl -s -X POST http://localhost:8090/api/generate_dpp_pdf \
    -H "Content-Type: application/json" \
    -d "{\"job_id\": $job_id}")
  
  if echo "$result" | grep -q '"success":true'; then
    success=$((success + 1))
    pdf_url=$(echo "$result" | jq -r '.pdf_url')
    echo "[$current/$total] ✓ Job $job_id -> $pdf_url"
  else
    failed=$((failed + 1))
    echo "[$current/$total] ✗ Job $job_id FAILED"
  fi
  
  # Small delay to avoid overwhelming the API
  sleep 0.1
done

echo ""
echo "=== Summary ==="
echo "Total: $total"
echo "Success: $success"
echo "Failed: $failed"

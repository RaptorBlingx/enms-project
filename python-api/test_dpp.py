#!/usr/bin/env python3
from dpp_simulator import get_live_dpp_data
import json

print("Testing dpp_simulator...")
data = get_live_dpp_data(page=1, limit=2)

print(f"Total printers: {len(data['printers'])}")
print(f"\nFirst printer: {data['printers'][0]['friendlyName']}")
print(f"Status: {data['printers'][0]['currentStatus']}")
print(f"job_details: {json.dumps(data['printers'][0].get('job_details', {}), indent=2)}")

if len(data['printers']) > 1:
    print(f"\nSecond printer: {data['printers'][1]['friendlyName']}")
    print(f"Status: {data['printers'][1]['currentStatus']}")
    print(f"job_details: {json.dumps(data['printers'][1].get('job_details', {}), indent=2)}")

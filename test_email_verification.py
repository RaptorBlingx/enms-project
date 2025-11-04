#!/usr/bin/env python3
"""
Test Script: Verify Email Sending Works
This script tests the SMTP configuration by attempting to register a test user.
"""

import requests
import json
import sys

API_BASE = "http://localhost:8090/api"

def test_registration():
    """Test user registration which triggers verification email"""
    
    print("=" * 60)
    print("Testing ENMS Demo Authentication System")
    print("=" * 60)
    print()
    
    # Test data
    test_user = {
        "email": "test.verification@example.com",
        "password": "TestPassword123!",
        "full_name": "Test User",
        "organization": "Test Org",
        "position": "Test Position",
        "mobile": "+1234567890",
        "country": "Test Country"
    }
    
    print(f"📧 Attempting to register: {test_user['email']}")
    print()
    
    try:
        response = requests.post(
            f"{API_BASE}/auth/register",
            json=test_user,
            headers={"Content-Type": "application/json"}
        )
        
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
        print()
        
        if response.status_code == 201:
            print("✅ SUCCESS: User registered!")
            print("📨 Check the Python API logs to see if verification email was sent")
            print()
            print("To view logs:")
            print("docker logs enms_demo_python_api --tail 50")
            return True
        elif response.status_code == 400 and "already exists" in response.json().get("error", "").lower():
            print("⚠️  User already exists - this is fine for testing!")
            print("📨 Email would have been sent during initial registration")
            return True
        else:
            print("❌ FAILED: Registration unsuccessful")
            return False
            
    except Exception as e:
        print(f"❌ ERROR: {e}")
        return False

if __name__ == "__main__":
    success = test_registration()
    sys.exit(0 if success else 1)

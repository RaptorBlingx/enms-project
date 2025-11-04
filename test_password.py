#!/usr/bin/env python3
"""
Password Verification Test - Check if stored password matches
"""

import bcrypt
import psycopg2
from psycopg2.extras import RealDictCursor

# Database config
DB_CONFIG = {
    'dbname': 'reg_ml_demo',
    'user': 'reg_ml_demo',
    'password': 'raptorblingx_demo',
    'host': 'localhost',
    'port': '5434'
}

def test_password(email, password_to_test):
    """Test if a password matches the stored hash"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        
        cursor.execute("""
            SELECT id, email, password_hash, full_name, role
            FROM demo_users 
            WHERE email = %s
        """, (email,))
        
        user = cursor.fetchone()
        
        if not user:
            print(f"❌ User not found: {email}")
            return False
        
        print(f"\n{'='*60}")
        print(f"User Found:")
        print(f"{'='*60}")
        print(f"ID: {user['id']}")
        print(f"Email: {user['email']}")
        print(f"Name: {user['full_name']}")
        print(f"Role: {user['role']}")
        print(f"Password Hash: {user['password_hash'][:50]}...")
        print(f"\nTesting password: {password_to_test}")
        print(f"{'='*60}")
        
        # Test password
        password_bytes = password_to_test.encode('utf-8')
        hash_bytes = user['password_hash'].encode('utf-8')
        
        matches = bcrypt.checkpw(password_bytes, hash_bytes)
        
        if matches:
            print(f"✅ PASSWORD MATCHES! Login should work.")
        else:
            print(f"❌ PASSWORD DOES NOT MATCH!")
            print(f"\nPossible issues:")
            print(f"1. Wrong password entered")
            print(f"2. Extra spaces in password")
            print(f"3. Different password was set")
        
        print(f"{'='*60}\n")
        
        cursor.close()
        conn.close()
        
        return matches
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

if __name__ == "__main__":
    # Test your credentials
    email = "swe.mohamad.jarad@gmail.com"
    password = "Raptor@321"
    
    print(f"\nTesting credentials for: {email}")
    test_password(email, password)

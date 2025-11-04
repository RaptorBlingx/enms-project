#!/usr/bin/env python3
"""
Direct SMTP Test - Verify Gmail Configuration
"""

import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# Configuration
SMTP_HOST = "smtp.gmail.com"
SMTP_PORT = 587
SMTP_USER = "swe.mohamad.jarad@gmail.com"
SMTP_PASSWORD = "klwb djbz zrwy zryh"
FROM_EMAIL = "swe.mohamad.jarad@gmail.com"
TO_EMAIL = "swe.mohamad.jarad@gmail.com"  # Send to yourself for testing

print("=" * 60)
print("SMTP Configuration Test")
print("=" * 60)
print(f"Host: {SMTP_HOST}:{SMTP_PORT}")
print(f"User: {SMTP_USER}")
print(f"Sending test email to: {TO_EMAIL}")
print()

try:
    # Create message
    msg = MIMEMultipart('alternative')
    msg['Subject'] = 'ENMS Demo - SMTP Test'
    msg['From'] = f"ENMS Demo Platform <{FROM_EMAIL}>"
    msg['To'] = TO_EMAIL
    
    # Simple HTML body
    html_body = """
    <html>
    <body style="font-family: Arial, sans-serif;">
        <h2 style="color: #3b82f6;">✅ SMTP Configuration Successful!</h2>
        <p>This is a test email from the ENMS Demo authentication system.</p>
        <p>If you received this email, your Gmail SMTP configuration is working correctly.</p>
        <hr>
        <p style="font-size: 12px; color: #666;">
            Sent from ENMS Demo Platform<br>
            Timestamp: %(timestamp)s
        </p>
    </body>
    </html>
    """ % {"timestamp": "2025-01-28 19:00:00"}
    
    msg.attach(MIMEText(html_body, 'html'))
    
    # Connect and send
    print("Connecting to SMTP server...")
    with smtplib.SMTP(SMTP_HOST, SMTP_PORT) as server:
        print("Starting TLS...")
        server.starttls()
        
        print("Logging in...")
        server.login(SMTP_USER, SMTP_PASSWORD)
        
        print("Sending message...")
        server.send_message(msg)
    
    print()
    print("=" * 60)
    print("✅ SUCCESS! Email sent successfully.")
    print("📧 Check your inbox: " + TO_EMAIL)
    print("=" * 60)
    
except Exception as e:
    print()
    print("=" * 60)
    print("❌ FAILED! Error occurred:")
    print(str(e))
    print("=" * 60)
    print()
    print("Common issues:")
    print("1. App password might be incorrect")
    print("2. 2-Step Verification might not be enabled on Gmail account")
    print("3. App password might have expired")
    print("4. Network/firewall might be blocking port 587")

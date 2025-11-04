import smtplib
from email.mime.text import MIMEText

try:
    msg = MIMEText("Test from ENMS Demo")
    msg['Subject'] = 'SMTP Test'
    msg['From'] = 'swe.mohamad.jarad@gmail.com'
    msg['To'] = 'swe.mohamad.jarad@gmail.com'
    
    with smtplib.SMTP('smtp.gmail.com', 587) as server:
        server.starttls()
        server.login('swe.mohamad.jarad@gmail.com', 'miuv tazo cgzm tlbs')
        server.send_message(msg)
    
    print("✅ SUCCESS! Email sent.")
except Exception as e:
    print(f"❌ FAILED: {e}")

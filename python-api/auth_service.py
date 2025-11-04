"""
ENMS Demo - Authentication Service
Handles user authentication, session management, and email verification
"""

import os
import jwt
import bcrypt
import secrets
import smtplib
from datetime import datetime, timedelta
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email_validator import validate_email, EmailNotValidError
import psycopg2
from psycopg2.extras import RealDictCursor
from functools import wraps
from flask import request, jsonify

# ====================================================================
# CONFIGURATION
# ====================================================================

JWT_SECRET = os.environ.get('JWT_SECRET', 'enms_demo_secret_key_change_in_production')
JWT_ALGORITHM = 'HS256'
JWT_EXPIRATION_HOURS = 24 * 7  # 7 days

# Email configuration
SMTP_HOST = os.environ.get('SMTP_HOST', 'smtp.gmail.com')
SMTP_PORT = int(os.environ.get('SMTP_PORT', 587))
SMTP_USER = os.environ.get('SMTP_USER', '')
SMTP_PASSWORD = os.environ.get('SMTP_PASSWORD', '')
SMTP_FROM_EMAIL = os.environ.get('SMTP_FROM_EMAIL', 'noreply@enms-demo.local')
SMTP_FROM_NAME = os.environ.get('SMTP_FROM_NAME', 'ENMS Demo')

# Frontend URL for email links
FRONTEND_URL = os.environ.get('FRONTEND_URL', 'http://localhost:8090')

# Database connection
DB_CONFIG = {
    'dbname': os.environ.get('POSTGRES_DB'),
    'user': os.environ.get('POSTGRES_USER'),
    'password': os.environ.get('POSTGRES_PASSWORD'),
    'host': os.environ.get('POSTGRES_HOST'),
    'port': os.environ.get('POSTGRES_PORT')
}

# ====================================================================
# DATABASE UTILITIES
# ====================================================================

def get_db_connection():
    """Get a database connection"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except Exception as e:
        print(f"Database connection error: {e}")
        return None

# ====================================================================
# PASSWORD HASHING
# ====================================================================

def hash_password(password: str) -> str:
    """Hash a password using bcrypt"""
    salt = bcrypt.gensalt(rounds=12)
    hashed = bcrypt.hashpw(password.encode('utf-8'), salt)
    return hashed.decode('utf-8')

def verify_password(password: str, password_hash: str) -> bool:
    """Verify a password against its hash"""
    try:
        return bcrypt.checkpw(password.encode('utf-8'), password_hash.encode('utf-8'))
    except Exception as e:
        print(f"Password verification error: {e}")
        return False

# ====================================================================
# JWT TOKEN MANAGEMENT
# ====================================================================

def generate_token(user_id: int, email: str, role: str = 'user') -> str:
    """Generate a JWT token for a user"""
    payload = {
        'user_id': user_id,
        'email': email,
        'role': role,
        'exp': datetime.utcnow() + timedelta(hours=JWT_EXPIRATION_HOURS),
        'iat': datetime.utcnow()
    }
    token = jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)
    return token

def verify_token(token: str) -> dict:
    """Verify and decode a JWT token"""
    try:
        payload = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        return {'valid': True, 'payload': payload}
    except jwt.ExpiredSignatureError:
        return {'valid': False, 'error': 'Token expired'}
    except jwt.InvalidTokenError as e:
        return {'valid': False, 'error': f'Invalid token: {str(e)}'}

# ====================================================================
# EMAIL VERIFICATION
# ====================================================================

def generate_verification_token() -> str:
    """Generate a secure random verification token"""
    return secrets.token_urlsafe(32)

def send_verification_email(email: str, token: str, full_name: str) -> bool:
    """Send email verification link to user"""
    
    # If SMTP is not configured, just log and return success (for testing)
    if not SMTP_USER or not SMTP_PASSWORD:
        verification_link = f"{FRONTEND_URL}/verify-email.html?token={token}"
        print(f"\n{'='*60}")
        print(f"EMAIL VERIFICATION (SMTP NOT CONFIGURED)")
        print(f"{'='*60}")
        print(f"To: {email}")
        print(f"Name: {full_name}")
        print(f"Verification Link: {verification_link}")
        print(f"{'='*60}\n")
        return True
    
    try:
        verification_link = f"{FRONTEND_URL}/verify-email.html?token={token}"
        
        # Create message
        msg = MIMEMultipart('alternative')
        msg['Subject'] = 'Verify Your ENMS Demo Account'
        msg['From'] = f"{SMTP_FROM_NAME} <{SMTP_FROM_EMAIL}>"
        msg['To'] = email
        
        # Professional HTML email body
        html_body = f"""
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Verify Your ENMS Demo Account</title>
            <style>
                * {{ margin: 0; padding: 0; box-sizing: border-box; }}
                body {{ 
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
                    line-height: 1.6; 
                    color: #1f2937; 
                    background-color: #f3f4f6;
                    padding: 20px;
                }}
                .email-wrapper {{ 
                    max-width: 600px; 
                    margin: 0 auto; 
                    background: #ffffff; 
                    border-radius: 12px; 
                    overflow: hidden;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }}
                .header {{ 
                    background: linear-gradient(135deg, #1e40af 0%, #3b82f6 50%, #60a5fa 100%);
                    color: #ffffff; 
                    padding: 40px 30px; 
                    text-align: center;
                }}
                .header h1 {{ 
                    font-size: 28px; 
                    font-weight: 700; 
                    margin-bottom: 8px;
                    letter-spacing: -0.5px;
                }}
                .header p {{ 
                    font-size: 15px; 
                    opacity: 0.95; 
                    font-weight: 400;
                }}
                .content {{ 
                    padding: 40px 30px; 
                    background: #ffffff;
                }}
                .greeting {{ 
                    font-size: 20px; 
                    font-weight: 600; 
                    color: #111827; 
                    margin-bottom: 20px;
                }}
                .message {{ 
                    font-size: 15px; 
                    color: #4b5563; 
                    margin-bottom: 30px; 
                    line-height: 1.7;
                }}
                .cta-container {{ 
                    text-align: center; 
                    margin: 35px 0;
                }}
                .cta-button {{ 
                    display: inline-block; 
                    padding: 16px 40px; 
                    background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
                    color: #ffffff !important; 
                    text-decoration: none; 
                    border-radius: 8px; 
                    font-weight: 600; 
                    font-size: 16px;
                    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
                    transition: all 0.3s ease;
                }}
                .cta-button:hover {{ 
                    background: linear-gradient(135deg, #1e40af 0%, #2563eb 100%);
                    box-shadow: 0 6px 16px rgba(37, 99, 235, 0.4);
                }}
                .warning-box {{ 
                    margin: 30px 0; 
                    padding: 18px 20px; 
                    background: #fef3c7; 
                    border-left: 5px solid #f59e0b; 
                    border-radius: 6px;
                }}
                .warning-box strong {{ 
                    color: #92400e; 
                    font-weight: 600; 
                    display: block;
                    margin-bottom: 6px;
                }}
                .warning-box p {{ 
                    color: #78350f; 
                    font-size: 14px; 
                    margin: 0;
                    line-height: 1.5;
                }}
                .link-section {{ 
                    margin-top: 30px; 
                    padding: 20px; 
                    background: #f9fafb; 
                    border-radius: 8px;
                    border: 1px solid #e5e7eb;
                }}
                .link-section p {{ 
                    font-size: 13px; 
                    color: #6b7280; 
                    margin-bottom: 10px;
                }}
                .link-code {{ 
                    display: block; 
                    background: #ffffff; 
                    padding: 12px; 
                    border: 1px solid #d1d5db;
                    border-radius: 6px; 
                    word-break: break-all; 
                    font-family: 'Courier New', monospace; 
                    font-size: 12px; 
                    color: #374151;
                    margin-top: 8px;
                }}
                .features {{ 
                    display: table; 
                    width: 100%; 
                    margin: 30px 0;
                    border-collapse: collapse;
                }}
                .feature-item {{ 
                    display: table-cell; 
                    text-align: center; 
                    padding: 15px; 
                    width: 33.33%;
                }}
                .feature-icon {{ 
                    font-size: 32px; 
                    margin-bottom: 8px;
                }}
                .feature-text {{ 
                    font-size: 13px; 
                    color: #6b7280; 
                    font-weight: 500;
                }}
                .divider {{ 
                    height: 1px; 
                    background: #e5e7eb; 
                    margin: 35px 0;
                }}
                .footer {{ 
                    background: #f9fafb; 
                    padding: 30px; 
                    text-align: center; 
                    border-top: 1px solid #e5e7eb;
                }}
                .footer-features {{ 
                    margin-bottom: 20px; 
                    font-size: 14px; 
                    color: #6b7280;
                }}
                .footer-copyright {{ 
                    font-size: 13px; 
                    color: #9ca3af; 
                    margin-top: 15px;
                }}
                .support-info {{ 
                    margin-top: 20px; 
                    padding: 15px; 
                    background: #eff6ff; 
                    border-radius: 6px;
                    border: 1px solid #dbeafe;
                }}
                .support-info p {{ 
                    font-size: 13px; 
                    color: #1e40af; 
                    margin: 5px 0;
                }}
            </style>
        </head>
        <body>
            <div class="email-wrapper">
                <div class="header">
                    <h1>⚡ ENMS Demo Platform</h1>
                    <p>Energy Management & Digital Product Passport System</p>
                </div>
                
                <div class="content">
                    <div class="greeting">Hello {full_name},</div>
                    
                    <p class="message">
                        Thank you for registering with <strong>ENMS Demo Platform</strong>. We're excited to have you join our community of innovators in sustainable manufacturing and Industry 4.0 technology.
                    </p>
                    
                    <p class="message">
                        To complete your registration and gain full access to our demo environment, please verify your email address by clicking the button below:
                    </p>
                    
                    <div class="cta-container">
                        <a href="{verification_link}" class="cta-button">✓ Verify Email Address</a>
                    </div>
                    
                    <div class="features">
                        <div class="feature-item">
                            <div class="feature-icon">📊</div>
                            <div class="feature-text">Real-time Analytics</div>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon">🔐</div>
                            <div class="feature-text">Enterprise Security</div>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon">🌍</div>
                            <div class="feature-text">Sustainability Focus</div>
                        </div>
                    </div>
                    
                    <div class="warning-box">
                        <strong>⚠️ Security Notice</strong>
                        <p>This verification link will expire in 24 hours for your security. If you didn't create an account with ENMS Demo, please disregard this email or contact our support team.</p>
                    </div>
                    
                    <div class="link-section">
                        <p><strong>Alternative Verification Method:</strong></p>
                        <p>If the button above doesn't work, please copy and paste this link into your web browser:</p>
                        <code class="link-code">{verification_link}</code>
                    </div>
                    
                    <div class="divider"></div>
                    
                    <div class="support-info">
                        <p><strong>📧 Need Assistance?</strong></p>
                        <p>Contact our support team at: <strong>mohamad.jarad@aartimuhendislik.com</strong></p>
                    </div>
                </div>
                
                <div class="footer">
                    <div class="footer-features">
                        <strong>🌱 Sustainable Manufacturing</strong> • 
                        <strong>⚙️ Industry 4.0 Ready</strong> • 
                        <strong>🔒 Enterprise-Grade Security</strong>
                    </div>
                    <div class="footer-copyright">
                        &copy; 2025 ENMS Demo Platform. All rights reserved.<br>
                        This is an automated message, please do not reply directly to this email.
                    </div>
                </div>
            </div>
        </body>
        </html>
        """
        
        # Attach HTML body
        msg.attach(MIMEText(html_body, 'html'))
        
        # Send email
        with smtplib.SMTP(SMTP_HOST, SMTP_PORT) as server:
            server.starttls()
            server.login(SMTP_USER, SMTP_PASSWORD)
            server.send_message(msg)
        
        print(f"✓ Verification email sent to {email}")
        return True
        
    except Exception as e:
        print(f"✗ Error sending verification email: {e}")
        return False

# ====================================================================
# EMAIL VALIDATION
# ====================================================================

def validate_email_address(email: str) -> tuple:
    """Validate email address format"""
    try:
        # Validate and normalize
        valid = validate_email(email, check_deliverability=False)
        # Always return lowercase email to match database constraint
        normalized_email = valid.normalized.lower()
        return True, normalized_email
    except EmailNotValidError as e:
        return False, str(e)

# ====================================================================
# USER AUTHENTICATION
# ====================================================================

def register_user(email: str, password: str, organization: str, full_name: str, 
                 position: str, mobile: str, country: str, ip_address: str = None, 
                 user_agent: str = None) -> dict:
    """Register a new user"""
    
    # Validate email
    is_valid, result = validate_email_address(email)
    if not is_valid:
        return {'success': False, 'error': f'Invalid email: {result}'}
    
    email = result  # Use normalized email
    
    # Validate password strength
    if len(password) < 8:
        return {'success': False, 'error': 'Password must be at least 8 characters long'}
    
    conn = get_db_connection()
    if not conn:
        return {'success': False, 'error': 'Database connection failed'}
    
    try:
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        
        # Check if user already exists
        cursor.execute("SELECT id FROM demo_users WHERE email = %s", (email,))
        if cursor.fetchone():
            return {'success': False, 'error': 'Email already registered'}
        
        # Hash password
        password_hash = hash_password(password)
        
        # Generate verification token
        verification_token = generate_verification_token()
        
        # Insert user
        cursor.execute("""
            INSERT INTO demo_users 
            (email, password_hash, organization, full_name, position, mobile, country, 
             verification_token, verification_sent_at, ip_address_signup, user_agent)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, NOW(), %s, %s)
            RETURNING id, email, full_name
        """, (email, password_hash, organization, full_name, position, mobile, country, 
              verification_token, ip_address, user_agent))
        
        user = cursor.fetchone()
        conn.commit()
        
        # Send verification email
        send_verification_email(email, verification_token, full_name)
        
        # Log audit
        cursor.execute("""
            INSERT INTO demo_audit_log (user_id, action, status, ip_address, user_agent)
            VALUES (%s, 'register', 'success', %s, %s)
        """, (user['id'], ip_address, user_agent))
        conn.commit()
        
        return {
            'success': True,
            'message': 'Registration successful. Please check your email to verify your account.',
            'user_id': user['id'],
            'email': user['email']
        }
        
    except Exception as e:
        conn.rollback()
        print(f"Registration error: {e}")
        return {'success': False, 'error': f'Registration failed: {str(e)}'}
    finally:
        cursor.close()
        conn.close()

def login_user(email: str, password: str, ip_address: str = None, 
               user_agent: str = None) -> dict:
    """Authenticate user and create session"""
    
    conn = get_db_connection()
    if not conn:
        return {'success': False, 'error': 'Database connection failed'}
    
    try:
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        
        # Get user
        cursor.execute("""
            SELECT id, email, password_hash, full_name, role, email_verified, is_active
            FROM demo_users WHERE email = %s
        """, (email.lower(),))
        
        user = cursor.fetchone()
        
        if not user:
            # Log failed attempt
            cursor.execute("""
                INSERT INTO demo_audit_log (action, status, ip_address, user_agent, metadata)
                VALUES ('login', 'failure', %s, %s, %s)
            """, (ip_address, user_agent, psycopg2.extras.Json({'reason': 'user_not_found', 'email': email})))
            conn.commit()
            return {'success': False, 'error': 'Invalid email or password'}
        
        # Check if account is active
        if not user['is_active']:
            return {'success': False, 'error': 'Account is deactivated'}
        
        # Check if email is verified
        if not user['email_verified']:
            return {'success': False, 'error': 'Please verify your email before logging in'}
        
        # Verify password
        if not verify_password(password, user['password_hash']):
            # Log failed attempt
            cursor.execute("""
                INSERT INTO demo_audit_log (user_id, action, status, ip_address, user_agent, metadata)
                VALUES (%s, 'login', 'failure', %s, %s, %s)
            """, (user['id'], ip_address, user_agent, psycopg2.extras.Json({'reason': 'invalid_password'})))
            conn.commit()
            return {'success': False, 'error': 'Invalid email or password'}
        
        # Generate session token
        session_token = generate_token(user['id'], user['email'], user['role'])
        expires_at = datetime.utcnow() + timedelta(hours=JWT_EXPIRATION_HOURS)
        
        # Create session
        cursor.execute("""
            INSERT INTO demo_sessions 
            (user_id, session_token, expires_at, ip_address, user_agent)
            VALUES (%s, %s, %s, %s, %s)
            RETURNING id
        """, (user['id'], session_token, expires_at, ip_address, user_agent))
        
        session_id = cursor.fetchone()['id']
        
        # Update last login
        cursor.execute("""
            UPDATE demo_users SET last_login = NOW() WHERE id = %s
        """, (user['id'],))
        
        # Log successful login
        cursor.execute("""
            INSERT INTO demo_audit_log (user_id, action, status, ip_address, user_agent)
            VALUES (%s, 'login', 'success', %s, %s)
        """, (user['id'], ip_address, user_agent))
        
        conn.commit()
        
        return {
            'success': True,
            'token': session_token,
            'user': {
                'id': user['id'],
                'email': user['email'],
                'full_name': user['full_name'],
                'role': user['role']
            }
        }
        
    except Exception as e:
        conn.rollback()
        print(f"Login error: {e}")
        return {'success': False, 'error': 'Login failed'}
    finally:
        cursor.close()
        conn.close()

def verify_email_token(token: str) -> dict:
    """Verify email with token"""
    
    conn = get_db_connection()
    if not conn:
        return {'success': False, 'error': 'Database connection failed'}
    
    try:
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        
        # Find user with this token
        cursor.execute("""
            SELECT id, email, full_name, email_verified, verification_sent_at
            FROM demo_users 
            WHERE verification_token = %s
        """, (token,))
        
        user = cursor.fetchone()
        
        if not user:
            return {'success': False, 'error': 'Invalid verification token'}
        
        if user['email_verified']:
            return {'success': True, 'message': 'Email already verified', 'already_verified': True}
        
        # Check if token expired (24 hours)
        if user['verification_sent_at']:
            token_age = datetime.now(user['verification_sent_at'].tzinfo) - user['verification_sent_at']
            if token_age.total_seconds() > 24 * 3600:
                return {'success': False, 'error': 'Verification link expired. Please request a new one.'}
        
        # Verify email
        cursor.execute("""
            UPDATE demo_users 
            SET email_verified = TRUE, 
                verified_at = NOW(),
                verification_token = NULL
            WHERE id = %s
        """, (user['id'],))
        
        # Log verification
        cursor.execute("""
            INSERT INTO demo_audit_log (user_id, action, status)
            VALUES (%s, 'verify_email', 'success')
        """, (user['id'],))
        
        conn.commit()
        
        return {
            'success': True,
            'message': 'Email verified successfully! You can now log in.',
            'user': {
                'email': user['email'],
                'full_name': user['full_name']
            }
        }
        
    except Exception as e:
        conn.rollback()
        print(f"Email verification error: {e}")
        return {'success': False, 'error': 'Verification failed'}
    finally:
        cursor.close()
        conn.close()

def send_password_reset_email(email: str, token: str, full_name: str) -> bool:
    """Send password reset link to user"""
    
    # If SMTP is not configured, just log and return success (for testing)
    if not SMTP_USER or not SMTP_PASSWORD:
        reset_link = f"{FRONTEND_URL}/reset-password.html?token={token}"
        print(f"\n{'='*60}")
        print(f"PASSWORD RESET (SMTP NOT CONFIGURED)")
        print(f"{'='*60}")
        print(f"To: {email}")
        print(f"Name: {full_name}")
        print(f"Reset Link: {reset_link}")
        print(f"{'='*60}\n")
        return True
    
    try:
        reset_link = f"{FRONTEND_URL}/reset-password.html?token={token}"
        
        # Create message
        msg = MIMEMultipart('alternative')
        msg['Subject'] = 'Reset Your ENMS Demo Password'
        msg['From'] = f"{SMTP_FROM_NAME} <{SMTP_FROM_EMAIL}>"
        msg['To'] = email
        
        # Professional HTML email body
        html_body = f"""
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Reset Your ENMS Demo Password</title>
            <style>
                * {{ margin: 0; padding: 0; box-sizing: border-box; }}
                body {{ 
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
                    line-height: 1.6; 
                    color: #1f2937; 
                    background-color: #f3f4f6;
                    padding: 20px;
                }}
                .email-wrapper {{ 
                    max-width: 600px; 
                    margin: 0 auto; 
                    background: #ffffff; 
                    border-radius: 12px; 
                    overflow: hidden;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }}
                .header {{ 
                    background: linear-gradient(135deg, #1e40af 0%, #3b82f6 50%, #60a5fa 100%);
                    color: #ffffff; 
                    padding: 40px 30px; 
                    text-align: center;
                }}
                .header h1 {{ 
                    font-size: 28px; 
                    font-weight: 700; 
                    margin-bottom: 8px;
                    letter-spacing: -0.5px;
                }}
                .header p {{ 
                    font-size: 15px; 
                    opacity: 0.95; 
                    font-weight: 400;
                }}
                .content {{ 
                    padding: 40px 30px; 
                    background: #ffffff;
                }}
                .greeting {{ 
                    font-size: 20px; 
                    font-weight: 600; 
                    color: #111827; 
                    margin-bottom: 20px;
                }}
                .message {{ 
                    font-size: 15px; 
                    color: #4b5563; 
                    margin-bottom: 30px; 
                    line-height: 1.7;
                }}
                .cta-container {{ 
                    text-align: center; 
                    margin: 35px 0;
                }}
                .cta-button {{ 
                    display: inline-block; 
                    padding: 16px 40px; 
                    background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
                    color: #ffffff !important; 
                    text-decoration: none; 
                    border-radius: 8px; 
                    font-weight: 600; 
                    font-size: 16px;
                    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
                    transition: all 0.3s ease;
                }}
                .cta-button:hover {{ 
                    background: linear-gradient(135deg, #1e40af 0%, #2563eb 100%);
                    box-shadow: 0 6px 16px rgba(37, 99, 235, 0.4);
                }}
                .warning-box {{ 
                    margin: 30px 0; 
                    padding: 18px 20px; 
                    background: #fef3c7; 
                    border-left: 5px solid #f59e0b; 
                    border-radius: 6px;
                }}
                .warning-box strong {{ 
                    color: #92400e; 
                    font-weight: 600; 
                    display: block;
                    margin-bottom: 6px;
                }}
                .warning-box p {{ 
                    color: #78350f; 
                    font-size: 14px; 
                    margin: 0;
                    line-height: 1.5;
                }}
                .link-section {{ 
                    margin-top: 30px; 
                    padding: 20px; 
                    background: #f9fafb; 
                    border-radius: 8px;
                    border: 1px solid #e5e7eb;
                }}
                .link-section p {{ 
                    font-size: 13px; 
                    color: #6b7280; 
                    margin-bottom: 10px;
                }}
                .link-code {{ 
                    display: block; 
                    background: #ffffff; 
                    padding: 12px; 
                    border: 1px solid #d1d5db;
                    border-radius: 6px; 
                    word-break: break-all; 
                    font-family: 'Courier New', monospace; 
                    font-size: 12px; 
                    color: #374151;
                    margin-top: 8px;
                }}
                .divider {{ 
                    height: 1px; 
                    background: #e5e7eb; 
                    margin: 35px 0;
                }}
                .footer {{ 
                    background: #f9fafb; 
                    padding: 30px; 
                    text-align: center; 
                    border-top: 1px solid #e5e7eb;
                }}
                .footer-copyright {{ 
                    font-size: 13px; 
                    color: #9ca3af; 
                    margin-top: 15px;
                }}
                .support-info {{ 
                    margin-top: 20px; 
                    padding: 15px; 
                    background: #eff6ff; 
                    border-radius: 6px;
                    border: 1px solid #dbeafe;
                }}
                .support-info p {{ 
                    font-size: 13px; 
                    color: #1e40af; 
                    margin: 5px 0;
                }}
            </style>
        </head>
        <body>
            <div class="email-wrapper">
                <div class="header">
                    <h1>🔐 Password Reset Request</h1>
                    <p>ENMS Demo Platform</p>
                </div>
                
                <div class="content">
                    <div class="greeting">Hello {full_name},</div>
                    
                    <p class="message">
                        We received a request to reset the password for your <strong>ENMS Demo Platform</strong> account. If you made this request, click the button below to create a new password:
                    </p>
                    
                    <div class="cta-container">
                        <a href="{reset_link}" class="cta-button">🔑 Reset Password</a>
                    </div>
                    
                    <div class="warning-box">
                        <strong>⚠️ Security Notice</strong>
                        <p>This password reset link will expire in 1 hour for your security. If you didn't request a password reset, please ignore this email or contact our support team immediately.</p>
                    </div>
                    
                    <div class="link-section">
                        <p><strong>Alternative Method:</strong></p>
                        <p>If the button above doesn't work, please copy and paste this link into your web browser:</p>
                        <code class="link-code">{reset_link}</code>
                    </div>
                    
                    <div class="divider"></div>
                    
                    <div class="support-info">
                        <p><strong>📧 Need Assistance?</strong></p>
                        <p>Contact our support team at: <strong>mohamad.jarad@aartimuhendislik.com</strong></p>
                    </div>
                </div>
                
                <div class="footer">
                    <div class="footer-copyright">
                        &copy; 2025 ENMS Demo Platform. All rights reserved.<br>
                        This is an automated message, please do not reply directly to this email.
                    </div>
                </div>
            </div>
        </body>
        </html>
        """
        
        # Attach HTML body
        msg.attach(MIMEText(html_body, 'html'))
        
        # Send email
        with smtplib.SMTP(SMTP_HOST, SMTP_PORT) as server:
            server.starttls()
            server.login(SMTP_USER, SMTP_PASSWORD)
            server.send_message(msg)
        
        print(f"✓ Password reset email sent to {email}")
        return True
        
    except Exception as e:
        print(f"✗ Error sending password reset email: {e}")
        return False

def request_password_reset(email: str, ip_address: str = None) -> dict:
    """Request a password reset"""
    
    conn = get_db_connection()
    if not conn:
        return {'success': False, 'error': 'Database connection failed'}
    
    try:
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        
        # Find user by email
        cursor.execute("""
            SELECT id, email, full_name, is_active
            FROM demo_users 
            WHERE email = %s
        """, (email.lower(),))
        
        user = cursor.fetchone()
        
        # Always return success to prevent email enumeration
        if not user or not user['is_active']:
            print(f"Password reset requested for non-existent/inactive user: {email}")
            return {'success': True, 'message': 'If an account exists with that email, a password reset link has been sent.'}
        
        # Generate reset token
        reset_token = generate_verification_token()
        
        # Store reset token
        cursor.execute("""
            UPDATE demo_users 
            SET password_reset_token = %s,
                password_reset_sent_at = NOW()
            WHERE id = %s
        """, (reset_token, user['id']))
        
        # Log password reset request
        cursor.execute("""
            INSERT INTO demo_audit_log (user_id, action, status, ip_address)
            VALUES (%s, 'password_reset_request', 'success', %s)
        """, (user['id'], ip_address))
        
        conn.commit()
        
        # Send reset email
        send_password_reset_email(user['email'], reset_token, user['full_name'])
        
        return {
            'success': True,
            'message': 'If an account exists with that email, a password reset link has been sent.'
        }
        
    except Exception as e:
        conn.rollback()
        print(f"Password reset request error: {e}")
        return {'success': False, 'error': 'Failed to process password reset request'}
    finally:
        cursor.close()
        conn.close()

def reset_password_with_token(token: str, new_password: str, ip_address: str = None) -> dict:
    """Reset password using reset token"""
    
    # Validate password strength
    if len(new_password) < 8:
        return {'success': False, 'error': 'Password must be at least 8 characters long'}
    
    conn = get_db_connection()
    if not conn:
        return {'success': False, 'error': 'Database connection failed'}
    
    try:
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        
        # Find user with this reset token
        cursor.execute("""
            SELECT id, email, full_name, password_reset_sent_at
            FROM demo_users 
            WHERE password_reset_token = %s
        """, (token,))
        
        user = cursor.fetchone()
        
        if not user:
            return {'success': False, 'error': 'Invalid or expired reset token'}
        
        # Check if token expired (1 hour)
        if user['password_reset_sent_at']:
            token_age = datetime.now(user['password_reset_sent_at'].tzinfo) - user['password_reset_sent_at']
            if token_age.total_seconds() > 3600:  # 1 hour
                return {'success': False, 'error': 'Reset link expired. Please request a new one.'}
        
        # Hash new password
        password_hash = hash_password(new_password)
        
        # Update password and clear reset token
        cursor.execute("""
            UPDATE demo_users 
            SET password_hash = %s,
                password_reset_token = NULL,
                password_reset_sent_at = NULL,
                updated_at = NOW()
            WHERE id = %s
        """, (password_hash, user['id']))
        
        # Invalidate all existing sessions for security
        cursor.execute("""
            UPDATE demo_sessions 
            SET is_active = FALSE
            WHERE user_id = %s
        """, (user['id'],))
        
        # Log password reset
        cursor.execute("""
            INSERT INTO demo_audit_log (user_id, action, status, ip_address)
            VALUES (%s, 'password_reset', 'success', %s)
        """, (user['id'], ip_address))
        
        conn.commit()
        
        return {
            'success': True,
            'message': 'Password reset successfully! You can now log in with your new password.',
            'user': {
                'email': user['email'],
                'full_name': user['full_name']
            }
        }
        
    except Exception as e:
        conn.rollback()
        print(f"Password reset error: {e}")
        return {'success': False, 'error': 'Failed to reset password'}
    finally:
        cursor.close()
        conn.close()

def logout_user(token: str, ip_address: str = None) -> dict:
    """Logout user and invalidate session"""
    
    # Verify token first
    token_data = verify_token(token)
    if not token_data['valid']:
        return {'success': False, 'error': 'Invalid session'}
    
    conn = get_db_connection()
    if not conn:
        return {'success': False, 'error': 'Database connection failed'}
    
    try:
        cursor = conn.cursor()
        user_id = token_data['payload']['user_id']
        
        # Invalidate session
        cursor.execute("""
            UPDATE demo_sessions 
            SET is_active = FALSE, logged_out_at = NOW()
            WHERE session_token = %s AND user_id = %s
        """, (token, user_id))
        
        # Log logout
        cursor.execute("""
            INSERT INTO demo_audit_log (user_id, action, status, ip_address)
            VALUES (%s, 'logout', 'success', %s)
        """, (user_id, ip_address))
        
        conn.commit()
        
        return {'success': True, 'message': 'Logged out successfully'}
        
    except Exception as e:
        conn.rollback()
        print(f"Logout error: {e}")
        return {'success': False, 'error': 'Logout failed'}
    finally:
        cursor.close()
        conn.close()

# ====================================================================
# AUTHENTICATION DECORATORS
# ====================================================================

def require_auth(f):
    """Decorator to require authentication for routes"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        # Get token from header
        auth_header = request.headers.get('Authorization', '')
        
        if not auth_header.startswith('Bearer '):
            return jsonify({'error': 'No authorization token provided'}), 401
        
        token = auth_header.split(' ')[1]
        
        # Verify token
        token_data = verify_token(token)
        if not token_data['valid']:
            return jsonify({'error': token_data['error']}), 401
        
        # Add user info to request context
        request.user = token_data['payload']
        
        return f(*args, **kwargs)
    
    return decorated_function

def require_admin(f):
    """Decorator to require admin role"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        # First check authentication
        auth_header = request.headers.get('Authorization', '')
        
        if not auth_header.startswith('Bearer '):
            return jsonify({'error': 'No authorization token provided'}), 401
        
        token = auth_header.split(' ')[1]
        token_data = verify_token(token)
        
        if not token_data['valid']:
            return jsonify({'error': token_data['error']}), 401
        
        # Check admin role
        if token_data['payload'].get('role') != 'admin':
            return jsonify({'error': 'Admin access required'}), 403
        
        # Add user info to request context
        request.user = token_data['payload']
        
        return f(*args, **kwargs)
    
    return decorated_function

# ====================================================================
# SESSION MANAGEMENT
# ====================================================================

def check_session(token: str) -> dict:
    """Check if session is valid"""
    
    # Verify token
    token_data = verify_token(token)
    if not token_data['valid']:
        return {'valid': False, 'error': token_data['error']}
    
    conn = get_db_connection()
    if not conn:
        return {'valid': False, 'error': 'Database connection failed'}
    
    try:
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        
        # Check if session exists and is active
        cursor.execute("""
            SELECT s.id, s.user_id, s.expires_at, s.is_active,
                   u.email, u.full_name, u.role, u.is_active as user_active
            FROM demo_sessions s
            JOIN demo_users u ON s.user_id = u.id
            WHERE s.session_token = %s
        """, (token,))
        
        session = cursor.fetchone()
        
        if not session:
            return {'valid': False, 'error': 'Session not found'}
        
        if not session['is_active']:
            return {'valid': False, 'error': 'Session expired'}
        
        if not session['user_active']:
            return {'valid': False, 'error': 'User account deactivated'}
        
        if datetime.now(session['expires_at'].tzinfo) > session['expires_at']:
            # Session expired, mark as inactive
            cursor.execute("""
                UPDATE demo_sessions SET is_active = FALSE WHERE id = %s
            """, (session['id'],))
            conn.commit()
            return {'valid': False, 'error': 'Session expired'}
        
        # Update last activity
        cursor.execute("""
            UPDATE demo_sessions SET last_activity = NOW() WHERE id = %s
        """, (session['id'],))
        conn.commit()
        
        return {
            'valid': True,
            'user': {
                'id': session['user_id'],
                'email': session['email'],
                'full_name': session['full_name'],
                'role': session['role']
            }
        }
        
    except Exception as e:
        print(f"Session check error: {e}")
        return {'valid': False, 'error': 'Session validation failed'}
    finally:
        cursor.close()
        conn.close()

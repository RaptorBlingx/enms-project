# ENMS Demo - Email Configuration Guide

## Current Status
✅ **Your account is now configured:**
- Email: swe.mohamad.jarad@gmail.com
- Role: **ADMIN**
- Email Verified: **YES**
- You can now login at: http://localhost:8090/auth.html

## Email Verification Notes

### Console Mode (Current - SMTP Not Configured)
- Verification emails print to console instead of sending
- Check with: `docker logs enms_demo_python_api | grep "Verification Link"`
- Emails won't show in gunicorn logs due to output buffering (known issue)
- **Solution**: Accounts can be verified manually in database (already done for you)

### Production Mode - Configure Real SMTP

To send real verification emails, add to `/home/ubuntu/enms-demo/.env`:

```bash
# Gmail Example (Requires App Password)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-specific-password
SMTP_FROM_EMAIL=noreply@your-domain.com
SMTP_FROM_NAME=ENMS Demo
```

#### Gmail App Password Setup:
1. Go to Google Account Settings
2. Security → 2-Step Verification (enable if not already)
3. Search for "App passwords"
4. Generate app password for "Mail"
5. Use that password in SMTP_PASSWORD

#### After Configuration:
```bash
cd /home/ubuntu/enms-demo
docker compose restart python_api
```

## Admin Dashboard Access

**You're all set!** Just login and go to:
- Login: http://localhost:8090/auth.html
- Admin Dashboard: http://localhost:8090/admin/dashboard.html

## Manual User Verification (For Testing)

If you need to verify other test users manually:
```bash
docker exec enms_demo_postgres psql -U reg_ml_demo -d reg_ml_demo -c \
  "UPDATE demo_users SET email_verified = TRUE, verified_at = NOW() \
   WHERE email = 'user@example.com';"
```

## API Endpoints

All authentication endpoints are working:
- POST /api/auth/register - User registration
- POST /api/auth/login - User login  
- POST /api/auth/verify-email - Email verification
- POST /api/auth/logout - Logout
- GET /api/auth/check-session - Check if logged in
- GET /api/admin/users - List all users (admin only)
- GET /api/admin/stats - User statistics (admin only)
- GET /api/admin/export-users - Export CSV (admin only)

## Ready to Use!
Your authentication system is fully functional. Login credentials:
- **Email**: swe.mohamad.jarad@gmail.com
- **Password**: Raptor@321
- **Role**: Admin

-- ====================================================================
-- ENMS DEMO - Authentication & User Management Schema
-- Created: 2025-11-02
-- Purpose: User authentication, session management, and admin tracking
-- ====================================================================

-- Drop tables if they exist (for clean reinstall)
DROP TABLE IF EXISTS public.demo_audit_log CASCADE;
DROP TABLE IF EXISTS public.demo_sessions CASCADE;
DROP TABLE IF EXISTS public.demo_users CASCADE;

-- ====================================================================
-- 1. USERS TABLE
-- ====================================================================
CREATE TABLE public.demo_users (
    id SERIAL PRIMARY KEY,
    
    -- Core Authentication
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    
    -- User Information
    organization VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    position VARCHAR(255) NOT NULL,
    mobile VARCHAR(50),
    country VARCHAR(100) NOT NULL,
    
    -- Email Verification
    email_verified BOOLEAN DEFAULT FALSE,
    verification_token VARCHAR(255),
    verification_sent_at TIMESTAMP WITH TIME ZONE,
    verified_at TIMESTAMP WITH TIME ZONE,
    
    -- Password Reset
    password_reset_token VARCHAR(255),
    password_reset_sent_at TIMESTAMP WITH TIME ZONE,
    
    -- Role Management (for admin access)
    role VARCHAR(50) DEFAULT 'user', -- 'user', 'admin'
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_login TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Account Status
    is_active BOOLEAN DEFAULT TRUE,
    deactivated_at TIMESTAMP WITH TIME ZONE,
    
    -- Additional tracking
    ip_address_signup VARCHAR(50),
    user_agent TEXT,
    
    CONSTRAINT email_lowercase CHECK (email = LOWER(email))
);

-- Indexes for performance
CREATE INDEX idx_demo_users_email ON public.demo_users(email);
CREATE INDEX idx_demo_users_verification_token ON public.demo_users(verification_token);
CREATE INDEX idx_demo_users_password_reset_token ON public.demo_users(password_reset_token);
CREATE INDEX idx_demo_users_created_at ON public.demo_users(created_at);
CREATE INDEX idx_demo_users_role ON public.demo_users(role);

-- ====================================================================
-- 2. SESSIONS TABLE
-- ====================================================================
CREATE TABLE public.demo_sessions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES public.demo_users(id) ON DELETE CASCADE,
    
    -- Session Data
    session_token VARCHAR(500) UNIQUE NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    
    -- Session Metadata
    ip_address VARCHAR(50),
    user_agent TEXT,
    last_activity TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Session Status
    is_active BOOLEAN DEFAULT TRUE,
    logged_out_at TIMESTAMP WITH TIME ZONE
);

-- Indexes for performance
CREATE INDEX idx_demo_sessions_user_id ON public.demo_sessions(user_id);
CREATE INDEX idx_demo_sessions_token ON public.demo_sessions(session_token);
CREATE INDEX idx_demo_sessions_expires_at ON public.demo_sessions(expires_at);

-- ====================================================================
-- 3. AUDIT LOG TABLE
-- ====================================================================
CREATE TABLE public.demo_audit_log (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES public.demo_users(id) ON DELETE SET NULL,
    
    -- Action Details
    action VARCHAR(100) NOT NULL, -- 'login', 'logout', 'register', 'verify_email', 'password_reset', 'profile_update'
    status VARCHAR(50) NOT NULL, -- 'success', 'failure', 'pending'
    
    -- Request Details
    ip_address VARCHAR(50),
    user_agent TEXT,
    
    -- Additional Data (JSON for flexibility)
    metadata JSONB,
    
    -- Error tracking
    error_message TEXT,
    
    -- Timestamp
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_demo_audit_log_user_id ON public.demo_audit_log(user_id);
CREATE INDEX idx_demo_audit_log_action ON public.demo_audit_log(action);
CREATE INDEX idx_demo_audit_log_created_at ON public.demo_audit_log(created_at);
CREATE INDEX idx_demo_audit_log_ip_address ON public.demo_audit_log(ip_address);

-- ====================================================================
-- 4. FUNCTIONS & TRIGGERS
-- ====================================================================

-- Function to update 'updated_at' timestamp automatically
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update 'updated_at' on demo_users
CREATE TRIGGER trigger_demo_users_updated_at
    BEFORE UPDATE ON public.demo_users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ====================================================================
-- 5. CREATE DEFAULT ADMIN USER (Optional - for testing)
-- ====================================================================
-- Password: 'AdminDemo2025!' (hashed with bcrypt)
-- This will be updated by the Python application on first run
INSERT INTO public.demo_users (
    email, 
    password_hash, 
    organization, 
    full_name, 
    position, 
    mobile, 
    country, 
    email_verified, 
    role,
    verified_at,
    ip_address_signup
) VALUES (
    'admin@enms-demo.local',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LQv3c1yqBWVHxkd0L', -- Placeholder, update with real hash
    'ENMS Demo Team',
    'System Administrator',
    'Administrator',
    '+1234567890',
    'United States',
    TRUE,
    'admin',
    NOW(),
    '127.0.0.1'
) ON CONFLICT (email) DO NOTHING;

-- ====================================================================
-- 6. HELPFUL VIEWS
-- ====================================================================

-- View: Active users with last login info
CREATE OR REPLACE VIEW public.v_demo_active_users AS
SELECT 
    u.id,
    u.email,
    u.organization,
    u.full_name,
    u.position,
    u.country,
    u.email_verified,
    u.role,
    u.created_at,
    u.last_login,
    (SELECT COUNT(*) FROM public.demo_sessions s 
     WHERE s.user_id = u.id AND s.is_active = TRUE) as active_sessions
FROM public.demo_users u
WHERE u.is_active = TRUE
ORDER BY u.created_at DESC;

-- View: User login statistics
CREATE OR REPLACE VIEW public.v_demo_user_stats AS
SELECT 
    COUNT(*) as total_users,
    COUNT(CASE WHEN email_verified = TRUE THEN 1 END) as verified_users,
    COUNT(CASE WHEN email_verified = FALSE THEN 1 END) as unverified_users,
    COUNT(CASE WHEN role = 'admin' THEN 1 END) as admin_users,
    COUNT(CASE WHEN last_login >= NOW() - INTERVAL '7 days' THEN 1 END) as active_7_days,
    COUNT(CASE WHEN last_login >= NOW() - INTERVAL '30 days' THEN 1 END) as active_30_days,
    COUNT(CASE WHEN created_at >= NOW() - INTERVAL '24 hours' THEN 1 END) as new_today,
    COUNT(CASE WHEN created_at >= NOW() - INTERVAL '7 days' THEN 1 END) as new_this_week
FROM public.demo_users
WHERE is_active = TRUE;

-- ====================================================================
-- 7. CLEANUP FUNCTIONS (for maintenance)
-- ====================================================================

-- Function to delete expired sessions
CREATE OR REPLACE FUNCTION cleanup_expired_sessions()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM public.demo_sessions
    WHERE expires_at < NOW() AND is_active = TRUE;
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Function to delete old unverified users (older than 7 days)
CREATE OR REPLACE FUNCTION cleanup_unverified_users()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM public.demo_users
    WHERE email_verified = FALSE 
    AND created_at < NOW() - INTERVAL '7 days';
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- ====================================================================
-- END OF SCHEMA
-- ====================================================================

-- Grant permissions (if needed for specific users)
-- GRANT SELECT, INSERT, UPDATE ON public.demo_users TO your_app_user;
-- GRANT SELECT, INSERT, UPDATE ON public.demo_sessions TO your_app_user;
-- GRANT INSERT ON public.demo_audit_log TO your_app_user;

-- Success message
DO $$
BEGIN
    RAISE NOTICE '✓ ENMS Demo Authentication Schema Created Successfully';
    RAISE NOTICE '✓ Tables: demo_users, demo_sessions, demo_audit_log';
    RAISE NOTICE '✓ Views: v_demo_active_users, v_demo_user_stats';
    RAISE NOTICE '✓ Functions: cleanup_expired_sessions, cleanup_unverified_users';
    RAISE NOTICE '✓ Default admin user created: admin@enms-demo.local';
END $$;

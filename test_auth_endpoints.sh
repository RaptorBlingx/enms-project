#!/bin/bash

# Test Authentication System - Local vs Cloudflare
# This script tests if auth works on both direct IP and through Cloudflare domain

echo "=========================================="
echo "ENMS Demo Authentication Test"
echo "=========================================="
echo ""

# Test credentials
EMAIL="test@example.com"
PASSWORD="TestPassword123"

# Test URLs
LOCAL_URL="http://10.33.10.109:8090/api/auth/login"
DOMAIN_URL="https://lauds-demo.intel50001.com/api/auth/login"

echo "1️⃣  Testing DIRECT IP (should work)..."
echo "URL: $LOCAL_URL"
echo ""

RESPONSE_LOCAL=$(curl -s -w "\n%{http_code}" -X POST "$LOCAL_URL" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")

HTTP_CODE_LOCAL=$(echo "$RESPONSE_LOCAL" | tail -n1)
BODY_LOCAL=$(echo "$RESPONSE_LOCAL" | sed '$d')

echo "HTTP Status: $HTTP_CODE_LOCAL"
echo "Response: $BODY_LOCAL"
echo ""

if [ "$HTTP_CODE_LOCAL" = "200" ] || [ "$HTTP_CODE_LOCAL" = "401" ]; then
    echo "✅ Direct IP: API is responding"
else
    echo "❌ Direct IP: API is NOT responding correctly"
fi

echo ""
echo "=========================================="
echo ""

echo "2️⃣  Testing CLOUDFLARE DOMAIN..."
echo "URL: $DOMAIN_URL"
echo ""

RESPONSE_DOMAIN=$(curl -s -w "\n%{http_code}\n%{header_cf_cache_status}" -X POST "$DOMAIN_URL" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")

HTTP_CODE_DOMAIN=$(echo "$RESPONSE_DOMAIN" | tail -n2 | head -n1)
CF_CACHE=$(echo "$RESPONSE_DOMAIN" | tail -n1)
BODY_DOMAIN=$(echo "$RESPONSE_DOMAIN" | head -n-2)

echo "HTTP Status: $HTTP_CODE_DOMAIN"
echo "Cloudflare Cache: $CF_CACHE"
echo "Response: $BODY_DOMAIN"
echo ""

if [ "$HTTP_CODE_DOMAIN" = "200" ] || [ "$HTTP_CODE_DOMAIN" = "401" ]; then
    echo "✅ Cloudflare Domain: API is responding"
    
    if [ "$CF_CACHE" = "DYNAMIC" ] || [ "$CF_CACHE" = "BYPASS" ]; then
        echo "✅ Cloudflare: Cache is BYPASSED (correct!)"
    elif [ "$CF_CACHE" = "HIT" ]; then
        echo "⚠️  Cloudflare: Response is CACHED (needs fix!)"
        echo "   → Admin should create cache bypass rule for /api/*"
    else
        echo "ℹ️  Cloudflare: Cache status: $CF_CACHE"
    fi
else
    echo "❌ Cloudflare Domain: API is NOT responding correctly"
    echo "   → Admin should check Cloudflare WAF/Security rules"
fi

echo ""
echo "=========================================="
echo ""

# Compare results
if [ "$HTTP_CODE_LOCAL" = "$HTTP_CODE_DOMAIN" ]; then
    echo "✅ RESULT: Both endpoints return same status code"
    echo "   Authentication system is working correctly!"
else
    echo "❌ RESULT: Different responses detected"
    echo "   Local: $HTTP_CODE_LOCAL | Domain: $HTTP_CODE_DOMAIN"
    echo "   → Cloudflare configuration needs adjustment"
    echo "   → See: CLOUDFLARE_CONFIG_GUIDE.md"
fi

echo ""
echo "=========================================="

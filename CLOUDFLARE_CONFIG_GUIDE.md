# 🔐 Cloudflare Configuration for ENMS Demo Authentication

**Issue:** Login/Registration failing through `https://lauds-demo.intel50001.com` but works on direct IP `10.33.10.109:8090`

**Root Cause:** Cloudflare is caching or blocking API authentication requests

---

## ⚡ Quick Fix (Recommended)

### Step 1: Purge Cloudflare Cache
1. Log into Cloudflare Dashboard
2. Select domain: `intel50001.com`
3. Go to: **Caching** → **Configuration**
4. Click: **Purge Everything**
5. Confirm and wait 30 seconds

### Step 2: Create Cache Rule for API
1. Go to: **Caching** → **Cache Rules**
2. Click: **Create Rule**
3. **Rule Name:** `Bypass API Authentication`
4. **When incoming requests match:**
   - Field: `URI Path`
   - Operator: `starts with`
   - Value: `/api/auth`
5. **Then:**
   - **Cache eligibility:** `Bypass cache`
   - **Origin Cache Control:** `Off`
6. Click: **Deploy**

### Step 3: Add Another Rule for All APIs
1. Create another rule: `Bypass All API Endpoints`
2. **When incoming requests match:**
   - Field: `URI Path`
   - Operator: `starts with`
   - Value: `/api`
3. **Then:**
   - **Cache eligibility:** `Bypass cache`
4. Click: **Deploy**

---

## 🛡️ Optional: WAF Security Rules

If you have WAF enabled:

1. Go to: **Security** → **WAF** → **Custom Rules**
2. Create rule: `Allow API Authentication`
3. **When incoming requests match:**
   - Field: `URI Path`
   - Operator: `starts with`
   - Value: `/api/auth`
4. **Then:**
   - Action: `Skip` → `All remaining custom rules`
5. **Deploy**

---

## 🚇 If Using Cloudflare Tunnel (cloudflared)

Update your tunnel configuration file (usually `/etc/cloudflared/config.yml`):

```yaml
tunnel: <your-tunnel-id>
credentials-file: /path/to/credentials.json

ingress:
  # Rule 1: API endpoints - No caching, direct pass-through
  - hostname: lauds-demo.intel50001.com
    path: /api/*
    service: http://localhost:8090
    originRequest:
      noTLSVerify: true
      disableChunkedEncoding: false
      connectTimeout: 30s
      noHappyEyeballs: false
      
  # Rule 2: Everything else (frontend, static files)
  - hostname: lauds-demo.intel50001.com
    service: http://localhost:8090
    
  # Catch-all
  - service: http_status:404
```

Then restart the tunnel:
```bash
sudo systemctl restart cloudflared
```

---

## 📋 Current Port Mappings

| Service | Local Port | Public URL Path | Purpose |
|---------|-----------|-----------------|---------|
| Web (nginx) | 8090 | / | Frontend + API gateway |
| Grafana | 3002 | /grafana | Monitoring dashboards |
| Node-RED | 1882 | /nodered | IoT flow editor |

**Important:** All API requests should go through port **8090** (nginx), not directly to Python API on port 5000.

---

## ✅ Verification Steps

After applying the changes:

1. **Clear Cloudflare cache** (as described above)
2. **Test the API directly:**
   ```bash
   curl -X POST https://lauds-demo.intel50001.com/api/auth/login \
     -H "Content-Type: application/json" \
     -d '{"email":"test@example.com","password":"TestPass123"}'
   ```
3. **Expected response:** Either success with token OR clear error message (not 401 Unauthorized)
4. **Test in browser:** Open DevTools (F12), try logging in, check Network tab for status codes

---

## 🔍 Debugging

If issues persist, check:

1. **Cloudflare Cache Status:**
   - Open browser DevTools → Network tab
   - Login attempt → Check response headers
   - Look for: `cf-cache-status: HIT` ← This means cached (BAD for API!)
   - Should be: `cf-cache-status: DYNAMIC` or `BYPASS`

2. **Check WAF Logs:**
   - Cloudflare Dashboard → Security → Events
   - Look for blocked requests to `/api/auth/*`

3. **Tunnel Status:**
   ```bash
   sudo systemctl status cloudflared
   sudo journalctl -u cloudflared -f
   ```

---

## 📞 Contact

If you need assistance:
- **Server Admin:** Check nginx logs: `docker logs enms_demo_web_server`
- **API Logs:** `docker logs enms_demo_python_api`
- **Test Direct IP:** `http://10.33.10.109:8090/auth.html` (should work)

---

## 🎯 Summary

**What we did on the server:**
- ✅ Added Cache-Control headers to nginx (tells Cloudflare not to cache)
- ✅ Added CORS headers for cross-origin requests
- ✅ Configured proper API routing

**What YOU need to do on Cloudflare:**
1. Purge cache
2. Create cache bypass rules for `/api/*`
3. (Optional) Adjust WAF rules if blocking requests

**Expected result:** Login/registration will work perfectly on `https://lauds-demo.intel50001.com` just like it does on the direct IP!

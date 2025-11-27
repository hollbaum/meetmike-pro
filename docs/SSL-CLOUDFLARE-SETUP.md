# Meet Mike SSL Setup via Cloudflare

**Date:** 2025-11-27
**Status:** Recommended Solution
**Author:** Claude (Team Lead)

---

## Problem Summary

The meetmike.pro site deployed on Coolify is experiencing SSL certificate issues:

- **Root Cause:** Traefik's ACME HTTP-01 challenge is failing
- **Error:** `ERR Unable to obtain ACME certificate for domains: [meetmike.pro] invalid authorization: 403 :: Invalid response from http://meetmike.pro/.well-known/acme-challenge/... : 404`
- **Why:** The HTTP router routes ACME challenge requests to the Next.js app instead of letting Traefik handle them internally

---

## Recommended Solution: Cloudflare

Cloudflare provides free SSL certificates and proxying, bypassing the Traefik ACME issue entirely.

### Step 1: Add Domain to Cloudflare

1. Create free Cloudflare account at https://cloudflare.com
2. Add site: `meetmike.pro`
3. Cloudflare will scan existing DNS records

### Step 2: Update Nameservers

At your domain registrar (where meetmike.pro is registered), update nameservers to Cloudflare's:
- `*.ns.cloudflare.com` (provided during setup)

### Step 3: Configure DNS Records

In Cloudflare DNS settings, add:

```
Type: A
Name: @
Value: 136.243.148.151
Proxy: ON (orange cloud)

Type: A
Name: www
Value: 136.243.148.151
Proxy: ON (orange cloud)
```

### Step 4: SSL/TLS Settings

In Cloudflare dashboard → SSL/TLS:
- **Mode:** Full (not Full Strict, since Coolify has self-signed cert)
- **Always Use HTTPS:** ON
- **Automatic HTTPS Rewrites:** ON

### Step 5: Coolify Configuration

In Coolify, update the application:
1. Keep domain as `https://meetmike.pro`
2. **Disable** Force HTTPS (Cloudflare handles this)
3. The self-signed Traefik cert is fine - Cloudflare encrypts visitor traffic

---

## Alternative Solutions (More Complex)

### Option B: Traefik DNS Challenge
- Requires DNS provider API credentials
- More complex setup in Coolify
- Not recommended for simple sites

### Option C: Manual Certificate
- Use certbot externally
- Upload to Coolify
- Requires manual renewal every 90 days

---

## Verification Steps

After Cloudflare setup (allow 24-48h for DNS propagation):

1. Visit https://meetmike.pro - should show Cloudflare SSL cert
2. Check SSL Labs: https://www.ssllabs.com/ssltest/analyze.html?d=meetmike.pro
3. Verify redirect: http://meetmike.pro → https://meetmike.pro

---

## Current Status

- [x] Site deployed to Coolify
- [x] SSL issue diagnosed (ACME 404)
- [ ] Cloudflare setup (needs domain registrar access)
- [ ] DNS propagation
- [ ] SSL verification

---

## Notes

The Coolify v4 beta (4.0.0-beta.450) has known issues with Traefik ACME challenges. Cloudflare is the cleanest workaround and adds CDN/DDoS protection as a bonus.

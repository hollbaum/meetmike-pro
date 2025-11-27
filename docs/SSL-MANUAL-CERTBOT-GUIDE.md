# SSL Manual Certbot Guide for Meet Mike

**Created:** 2025-11-27
**Status:** Proposed - Awaiting Founder Approval
**Context:** Christian requested "old school way" with direct filesystem + DNS access

---

## Problem Summary

Coolify's Traefik ACME HTTP-01 challenge fails with 404 because:
- Coolify apps intercept `/.well-known/acme-challenge/` requests
- Traefik never receives the validation request
- Let's Encrypt can't verify domain ownership

---

## Recommended Solution: DNS-01 Challenge

**Why DNS-01:**
- Bypasses HTTP routing entirely
- Uses DNS TXT records for validation
- Works regardless of web server configuration
- We have direct DNS access (per Christian)

---

## Option A: Manual Certbot with DNS-01

### Step 1: Install certbot on server
```bash
sudo apt update && sudo apt install certbot
```

### Step 2: Run manual DNS challenge
```bash
sudo certbot certonly --manual --preferred-challenges dns -d meetmike.pro -d www.meetmike.pro
```

### Step 3: When prompted, add DNS TXT record
Certbot will display something like:
```
Please deploy a DNS TXT record under the name:
_acme-challenge.meetmike.pro
with the following value:
<random-string>
```

### Step 4: Add the TXT record in DNS provider
- Record type: TXT
- Host: `_acme-challenge`
- Value: `<the string certbot gave you>`
- TTL: 300 (or lowest available)

### Step 5: Wait for DNS propagation, then press Enter
Certbot will verify and issue certificate.

### Step 6: Certificate locations
```
/etc/letsencrypt/live/meetmike.pro/fullchain.pem
/etc/letsencrypt/live/meetmike.pro/privkey.pem
```

### Step 7: Configure Coolify to use custom cert
In Coolify UI:
1. Go to meetmike.pro service
2. Settings → SSL
3. Choose "Custom Certificate"
4. Point to cert files or paste contents

---

## Option B: Configure Traefik DNS-01 (Automated)

If DNS provider has API support, Traefik can auto-renew.

### Supported providers:
- Cloudflare (API key)
- Route53 (AWS)
- Google Cloud DNS
- DigitalOcean
- Many others

### Traefik config addition:
```yaml
certificatesResolvers:
  letsencrypt:
    acme:
      email: your@email.com
      storage: /etc/traefik/acme.json
      dnsChallenge:
        provider: <your-provider>
        delayBeforeCheck: 60
```

**Note:** Requires knowing which DNS provider hosts meetmike.pro

---

## Renewal

**Manual certbot:** Run same command before expiry (90 days)
**Traefik DNS-01:** Automatic renewal

---

## Recommendation

Start with **Option A (Manual Certbot)** - simple, no dependencies, we control timing.

Consider **Option B** later if we want automated renewal.

---

## Next Steps (Pending Approval)

1. Confirm DNS provider for meetmike.pro
2. SSH to Coolify server
3. Run certbot manual DNS challenge
4. Add TXT record when prompted
5. Import cert to Coolify

---

**Questions for Christian:**
- Which DNS provider hosts meetmike.pro?
- Do you want me to SSH and run certbot, or should we do it together?

# Meet Mike - VM100/Coolify Deployment Plan

**Project:** Meet Mike Personal Website
**Target:** meetmike.pro
**Infrastructure:** Hetzner VM100 (Proxmox LXC) + Coolify
**Created:** 2025-11-25T18:20Z
**Status:** Active

---

## Executive Summary

Deploy Meet Mike website to VM100 using Coolify for Docker orchestration. This approach provides self-hosted infrastructure control while maintaining easy deployment workflows.

**Key Decision:** Use Docker/Coolify for web apps (like Meet Mike), reserve LXC for complex multi-service Eidolons (VM200+).

---

## Phase 1: Infrastructure Setup (Codex Lead)

**Owner:** Codex
**Duration:** 2-4 hours
**Prerequisites:** VM100 running, root access via SSH

### 1.1 Coolify Installation
- [ ] SSH into VM100 as root
- [ ] Install Coolify using official script: `curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash`
- [ ] Verify Coolify dashboard accessible (typically http://VM100_IP:8000)
- [ ] Configure initial admin user
- [ ] Document Coolify admin credentials in shared/secrets/

### 1.2 Coolify Configuration
- [ ] Create new project: "MeasAI Web Apps"
- [ ] Configure Docker network settings
- [ ] Set up persistent storage volumes for logs
- [ ] Configure automatic SSL/TLS via Let's Encrypt integration
- [ ] Test basic "hello world" deployment to verify Coolify operational

**Current state (2025-11-26 @10:45Z post-compose run):**
- Installer generated `/data/coolify/source/.env` with seeded secrets:
  - `DB_USERNAME=coolify`
  - `DB_PASSWORD=KBH/di4Gq9r6Oj2c+Yl1kZ8Pjr8zKpPPm0/k8PymeTA=`
  - `REDIS_PASSWORD=wLXsbuD50MUbnJz2MKpQbI6WSY2xLvJKXAVHgpXi8aA=`
  - `PUSHER_APP_ID=d028cb82486606a85355afaa991346d1a3b8e46c371d0319c18deff140df7b35`
  - `PUSHER_APP_KEY=da102f71f40f8afc626f5f5f4f652f89a6077b3f05aacd98ad8ad00a2b699384`
  - `PUSHER_APP_SECRET=ad21ac23a1b1ad9398e3ea11728221b29d53d7d49ea790740d17fdb75d914a04`
  - `REGISTRY_URL=ghcr.io`
  - `DOCKER_ADDRESS_POOL_BASE=10.0.0.0/8`, `DOCKER_ADDRESS_POOL_SIZE=24`
- Admin root user/email/password remain blank; set after UI accessible. Capture these + DB/Redis/Pusher secrets into `AI_Agents/shared/secrets/meet-mike/` once Docker containers start.
- Docker compose stack now running (`docker ps` shows `coolify`, `coolify-db`, `coolify-redis`, `coolify-realtime` healthy). Access UI at `http://136.243.148.151:8000` to create the initial admin user once ready.

### 1.3 GitHub Integration
- [ ] Connect Coolify to GitHub (may need GitHub App or PAT)
- [ ] Configure webhook for auto-deploy on push
- [ ] Test webhook with dummy repository

**Deliverable:** Coolify operational on VM100 with GitHub integration confirmed

---

## Phase 2: Application Preparation (Gemini Lead)

**Owner:** Gemini
**Duration:** 1-2 hours
**Prerequisites:** Phase 1 complete

### 2.1 Repository Setup
- [ ] Verify Meet Mike source in workspace or create new repo
- [ ] Review sections 1-3 implementation status (completed Nov 21)
- [ ] Add `Dockerfile` for Next.js production build
- [ ] Add `docker-compose.yml` if needed for local dev
- [ ] Create `.env.production` template with required variables
- [ ] Add Coolify-specific configuration (if any)

### 2.2 Environment Configuration
- [x] Define environment variables needed:
  - `NEXT_PUBLIC_SITE_URL=https://meetmike.pro`
  - `NODE_ENV=production`
  # Add other production environment variables here as needed
  # EXAMPLE_API_KEY=your_api_key
- [x] Document environment variables in `deployment-plan-vm100-coolify.md`
- [x] Created `projects/meet-mike/.env.production.example` template.

### 2.3 Build Testing
- [x] Run production build locally: `npm run build`
- [x] Verify no build errors (Build successful, with a warning about inferred workspace root - `Detected multiple lockfiles and selected the directory of /workspaces/Measai-Maestro/package-lock.json as the root directory.`)
- [ ] Test Docker build locally if possible (NOT VERIFIED LOCALLY - `docker` command not found in environment)
- [x] Document any build warnings/issues

**Deliverable:** Meet Mike repository production-ready with Docker configuration

---

## Phase 3: Coolify Deployment (Codex + Gemini)

**Owner:** Codex (lead), Gemini (support)
**Duration:** 1-2 hours
**Prerequisites:** Phase 1 & 2 complete

### 3.1 Create Coolify Application
- [ ] In Coolify dashboard, create new application
- [ ] Connect to Meet Mike GitHub repository
- [ ] Configure build settings:
  - Build command: `npm install && npm run build`
  - Start command: `npm start`
  - Port: 3000 (or Next.js default)
- [ ] Set environment variables from Phase 2.2
- [ ] Configure resource limits (CPU/RAM)

### 3.2 Initial Deployment
- [ ] Trigger first deployment
- [ ] Monitor build logs for errors
- [ ] Verify application starts successfully
- [ ] Test application via VM100 IP:port (before DNS)
- [ ] Verify all pages load correctly

### 3.3 SSL/TLS Configuration
- [ ] Configure Let's Encrypt certificate for meetmike.pro
- [ ] Verify HTTPS redirect working
- [ ] Test certificate validity

**Deliverable:** Meet Mike running on VM100, accessible via HTTPS (after DNS configured)

---

## Phase 4: DNS Configuration (Claude + Christian)

**Owner:** Claude (lead), Christian (nordicway.dk access)
**Duration:** 30 minutes - 2 hours (includes propagation)
**Prerequisites:** Phase 3 complete, VM100 IP confirmed

### 4.1 DNS Records Setup
- [x] Log into nordicway.dk admin panel *(Christian, 2025-11-26 15:23 UTC)*
- [x] Configure A record:
  - Host: `@` (root domain)
  - Value: `136.243.148.151` (VM100 IP)
  - TTL: 3600 (1 hour)
- [x] Configure A record for www:
  - Host: `www`
  - Value: `136.243.148.151`
  - TTL: 3600

### 4.2 DNS Verification
- [x] Wait for propagation (15 mins - 2 hours) *(~10 minutes)*
- [x] Test DNS resolution: `meetmike.pro → 136.243.148.151` ✅ *(Claude, 2025-11-26 15:37 UTC)*
- [x] Test www subdomain: `www.meetmike.pro → 136.243.148.151` ✅
- [x] Verify both resolve to VM100 IP ✅
- [x] **Re-verified 2025-11-27 10:35 UTC:** DNS confirmed working. All ports (80, 443, 8000, 3000) refusing connections - confirms VM100 services need to be started (Coolify/Docker not running yet).

### 4.3 Final Testing
- [ ] Access https://meetmike.pro in browser
- [ ] Verify all sections load correctly
- [ ] Test all interactive features
- [ ] Verify SSL certificate shows valid

**Deliverable:** meetmike.pro fully accessible and operational

---

## Phase 5: Testing & Documentation (Copilot Lead)

**Owner:** Copilot
**Duration:** 1-2 hours
**Prerequisites:** Phase 4 complete

### 5.1 Comprehensive Testing
- [ ] Test all navigation links
- [ ] Test contact form (if implemented)
- [ ] Test PDF upload functionality
- [ ] Test responsive design (mobile/tablet/desktop)
- [ ] Test browser compatibility (Chrome, Firefox, Safari, Edge)
- [ ] Performance testing (page load times)
- [ ] SEO validation (meta tags, sitemap)

### 5.2 Monitoring Setup
- [ ] Configure Coolify monitoring/alerts
- [ ] Set up uptime monitoring (if available)
- [ ] Document how to access application logs
- [ ] Document restart/rollback procedures

### 5.3 Documentation
- [ ] Update project README with deployment info
- [ ] Document Coolify deployment process
- [ ] Create troubleshooting guide
- [ ] Document environment variables reference
- [ ] Create handoff document for Christian

**Deliverable:** Fully tested deployment with comprehensive documentation

---

## Risk Mitigation

### Risk: Coolify installation fails
- **Mitigation:** Follow official docs exactly, check VM100 has sufficient resources
- **Fallback:** Use Vercel (already approved by Christian)

### Risk: Docker build failures
- **Mitigation:** Test builds locally first, review Next.js production requirements
- **Fallback:** Adjust Dockerfile, simplify build process

### Risk: DNS propagation delays
- **Mitigation:** Set low TTL initially (300s), test with direct IP first
- **Fallback:** Use hosts file for local testing while waiting

### Risk: SSL/TLS certificate issues
- **Mitigation:** Verify DNS resolution before requesting cert, use Let's Encrypt staging first
- **Fallback:** Manual certificate setup or proxy through Cloudflare

---

## Timeline Estimate

**Total Duration:** 6-12 hours (excluding DNS propagation)

- **Phase 1:** 2-4 hours (Codex)
- **Phase 2:** 1-2 hours (Gemini)
- **Phase 3:** 1-2 hours (Codex + Gemini)
- **Phase 4:** 0.5-2 hours (Claude + Christian)
- **Phase 5:** 1-2 hours (Copilot)

**Target Completion:** Within 24-48 hours from start

---

## Success Criteria

1. ✅ Coolify operational on VM100
2. ✅ Meet Mike deployed and running
3. ✅ meetmike.pro accessible via HTTPS
4. ✅ All website features functional
5. ✅ Monitoring and documentation complete
6. ✅ Christian can access and manage deployment

---

## Next Steps

1. **Immediate:** Codex begins Phase 1 (Coolify installation)
2. **Parallel:** Gemini begins Phase 2 (repository preparation)
3. **Sequential:** Phase 3-5 after prerequisites met
4. **Coordination:** Daily check-ins via signals, escalate blockers immediately

---

**Plan Status:** Ready for execution
**Approval:** Pending Christian confirmation
**Start Date:** TBD (awaiting green light)

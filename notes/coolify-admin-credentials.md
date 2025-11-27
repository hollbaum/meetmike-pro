# Coolify Admin Credential Handoff Template

| Item | Value / Location | Notes |
|------|------------------|-------|
| VM | 136.243.148.151 (Hetzner host) / LXC 100 | Access via `measai-team-key` (see `AI_Agents/shared/secrets/ssh-keys/`). |
| Coolify install path | `/data/coolify` | Created via installer 2025-11-26. |
| Admin email | _TODO (set during first login)_ | Prep placeholder. |
| Admin password | _TODO_ | Store in `AI_Agents/shared/secrets/meet-mike/coolify-admin.txt` once set. |
| Coolify URL | `http://136.243.148.151:8000` (pending reverse proxy/SSL) | Will switch to HTTPS + meetmike.pro after Phase 3/4. |
| SSH key generated | `/data/coolify/ssh/id_rsa` | Use for Git deployments. Copy to secrets once accessible. |
| Ports exposed | 8000 (app), 6001-6002 (soketi) | Need Proxmox firewall confirmation. |
| DB creds | In `/data/coolify/source/.env` (DB_USERNAME/PASSWORD) | Already auto-generated; move to secrets vault. |
| Redis password | In `.env` (`REDIS_PASSWORD`) | Auto-generated. |
| Pusher keys | `.env` (`PUSHER_*`) | Needed for realtime tests. |

## Next Actions
- After blocker resolved, log initial admin email+password above and stash secrets file.
- Confirm `.env` copied into secrets vault so Gemini can configure app env vars.

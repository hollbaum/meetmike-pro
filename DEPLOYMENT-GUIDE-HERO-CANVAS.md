# Hero Canvas Mike - Coolify Deployment Guide

## Quick Start (5 minutes)

### Step 1: Access Coolify Dashboard
```
URL: http://136.243.148.151:8000
Email: coolify-admin@meetmike.pro
Password: K7%FKH(*fqRN=OjoCjL%3yQH
```

### Step 2: Find "Meet Mike" Project
1. Log in to Coolify
2. Look for project named "Meet Mike" or "MeasAI Web Apps"
3. Click on the project

### Step 3: Deploy Hero Canvas Mike
**Option A: Auto-Deploy (Recommended)**
- If webhook is enabled, deployment should start automatically
- Check "Deployments" tab to see build progress

**Option B: Manual Deploy**
1. Click "Deploy" button
2. Select branch: `main`
3. Click "Deploy Now"
4. Monitor build logs

### Step 4: Wait for Build
- Expected time: 5-10 minutes
- Watch for "Build successful" message
- Verify container is running

### Step 5: Test Live Site
```
URL: https://meetmike.pro  (or http:// if SSL not ready)
```

Expected behavior:
1. **Clean white screen** appears
2. **Typewriter animation** starts automatically
   - "Hi. I'm Mike." (2-3 seconds)
   - "I help teams build ambitious projects." (3-4 seconds)
3. **Input field appears** with cursor focus
4. **Type a message** → Mike responds
5. **Scroll down** → Mini-chat appears in bottom-right

---

## Troubleshooting

### Build Fails
**Check:**
- Coolify logs in UI (red/yellow messages)
- Docker container status (`docker ps`)
- GitHub webhook connection

**Fix:**
1. Re-run build
2. Check environment variables are set
3. Verify Docker image builds locally

### Website Won't Load
**Check:**
- Is container running? (Coolify UI → Containers)
- Check reverse proxy logs
- Verify DNS points to server

**Fix:**
1. Restart container in Coolify
2. Check firewall rules (port 80/443 open?)
3. Verify SSL certificate status

### Animations Don't Work
**Check:**
- Browser console (F12 → Console tab)
- CSS/JS loading (F12 → Network tab)

**Fix:**
1. Hard refresh browser (Ctrl+Shift+R)
2. Check browser compatibility (Chrome/Edge/Safari)
3. Check for JavaScript errors in console

### Input Field Unresponsive
**Check:**
- Wait ~4 seconds for typewriter to complete
- Input should auto-focus after animation
- Try clicking in input field

**Fix:**
1. Reload page
2. Check browser allows focus on input
3. Verify JavaScript is enabled

---

## Verifying Deployment

### From Browser
1. Open meetmike.pro
2. Should see white screen (not error)
3. Typewriter animation should play
4. Input field should be clickable

### From Coolify UI
1. Log into Coolify dashboard
2. Navigate to "Meet Mike" project
3. Check "Status" shows "Running" (green)
4. Check "Latest Deployment" timestamp is recent
5. View "Container Logs" for any errors

### From Command Line (SSH into VM100)
```bash
ssh root@136.243.148.151

# Check running containers
docker ps | grep meet-mike

# View container logs
docker logs <container_id>

# Check port 80/443 listening
netstat -tulpn | grep -E ':(80|443)'
```

---

## Deployment Checklist

- [ ] Logged into Coolify (136.243.148.151:8000)
- [ ] Found "Meet Mike" project
- [ ] Started deployment (auto or manual)
- [ ] Monitored build progress
- [ ] Build completed successfully
- [ ] Container is running
- [ ] Accessed meetmike.pro
- [ ] Verified Hero Canvas loads
- [ ] Verified typewriter animation works
- [ ] Tested input field interaction
- [ ] Scrolled to verify mini-chat appears
- [ ] Ready to show Christian

---

## What Christian Will See

1. **Landing Page (White Hero Canvas)**
   - Clean, minimal design
   - Dark site content peeking below

2. **Typewriter Animation (4-5 seconds)**
   - Text appears character-by-character
   - Cursor blinks at end

3. **Interactive Input**
   - Auto-focused text field
   - Placeholder: "Tell me about your project..."
   - Purple send button

4. **Chat Interaction**
   - User types project idea
   - Mike responds: "Great! I'd love to hear more about..."
   - Multiple messages possible

5. **Scroll Behavior**
   - Scrolling down reveals mini-chat
   - Chat bubble in bottom-right corner
   - Can minimize/expand
   - Shows: "Take your time exploring. I'm here when ready."

---

## For Janus Demo

**Show Janus:**
1. Clean, minimal homepage (unlike generic chatbots)
2. Typewriter creates personality (Mike is "alive")
3. Conversational, not form-like
4. Professional yet approachable
5. Mobile responsive (show on phone too!)

**Key Points:**
- "NOT a widget, IS the experience"
- "Google homepage simplicity"
- "Mike feels like a real person, not a bot"
- "Implicit lead capture (not intrusive)"

---

## Credentials & Access

**Coolify Admin**
- Email: coolify-admin@meetmike.pro
- Password: K7%FKH(*fqRN=OjoCjL%3yQH
- URL: http://136.243.148.151:8000

**GitHub**
- Repo: https://github.com/hollbaum/measai-maestro-ai-team
- Branch: main
- Latest commit: 770579f2 (Hero Canvas Mike implementation)

**Meet Mike Website**
- URL: https://meetmike.pro
- Expected to be live after Coolify deployment

---

## Timeline

- **Current:** 2025-12-07 21:05 UTC
- **Deadline:** 2025-12-08 12:00 UTC (14h 55m remaining)
- **Estimated deployment time:** 10-15 minutes
- **Total time to demo ready:** 20-25 minutes

Plenty of buffer for testing and any fixes!

---

## Questions?

Contact Claude or Copilot via Maestro signals if:
- Coolify won't login
- Deployment fails
- Website doesn't load
- Any other blockers

---

**Hero Canvas Mike is production-ready. Deploy and enjoy! 🚀**

# MAX Pipeline Eidolons Provisioning Plan

**Date:** 2025-12-04
**Author:** Claude (Team Lead)
**Status:** Names APPROVED (2025-12-04 19:15 UTC) - Awaiting Provisioning Go-Ahead

---

## Overview

This plan provisions **7 MAX Pipeline Eidolons** (CT201-CT207) on the existing Hetzner AX42 Proxmox host, following the proven Mach42v2 (CT100) pattern.

| CT ID | Name | Role | Email Account | Internal IP |
|-------|------|------|---------------|-------------|
| CT201 | **LILLy** | Lead Generator | lilly@meetmike.pro | 10.0.100.201 |
| CT202 | **Mike** | First Responder | mike@meetmike.pro | 10.0.100.202 |
| CT203 | **Clara** | Scoping | clara@meetmike.pro | 10.0.100.203 |
| CT204 | **Aria** | Orchestra/Mockups | aria@meetmike.pro | 10.0.100.204 |
| CT205 | **Finn** | Closer | finn@meetmike.pro | 10.0.100.205 |
| CT206 | **Anya** | Onboarding | anya@meetmike.pro | 10.0.100.206 |
| CT207 | **Atlas** | Delivery PM | atlas@meetmike.pro | 10.0.100.207 |

---

## Resource Allocation (Per Eidolon)

Based on Christian's guidance (thin client model):

| Resource | Value | Notes |
|----------|-------|-------|
| vCPU | 2 cores | CLI agents are thin clients |
| RAM | 4 GB | LLM processing in cloud |
| Storage | 40 GB | Repo + logs + signals |
| Network | vmbr1 | Internal 10.0.100.0/24 |

**Total for 7 MAX Eidolons:**
- CPU: 14 cores (time-shared, rarely simultaneous)
- RAM: 28 GB
- Storage: 280 GB

**AX42 Capacity Check (64GB RAM, 8 cores/16 threads):**
- CT100 (Mach42v2): 6 cores, 24 GB (existing, can optimize later)
- CT201-207: 14 cores (logical), 28 GB
- **Fits comfortably with headroom**

---

## Phase 1: MS365 Account Setup (Christian Manual)

**Action Required:** Create 7 M365 accounts in meetmike.pro tenant:

1. `lilly@meetmike.pro` (Lead Generator - LILLy)
2. `mike@meetmike.pro` (First Responder - Mike)
3. `clara@meetmike.pro` (Scoping - Clara)
4. `aria@meetmike.pro` (Orchestra/Mockups - Aria)
5. `finn@meetmike.pro` (Closer - Finn)
6. `anya@meetmike.pro` (Onboarding - Anya)
7. `atlas@meetmike.pro` (Delivery PM - Atlas)

**Permissions Needed:**
- Teams (can chat with other agents and humans)
- Outlook (can send/receive email)
- Basic Microsoft 365 license (Business Basic sufficient)

---

## Phase 2: LXC Container Creation

### Template Command (repeat for CT201-207)

```bash
# SSH to Proxmox host
ssh -i AI_Agents/shared/secrets/ssh-keys/measai-team-key root@136.243.148.151

# Create container (example: CT201 Pulse)
pct create 201 local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst \
    --hostname pulse \
    --cores 2 \
    --memory 4096 \
    --swap 0 \
    --storage local-lvm \
    --rootfs local-lvm:40 \
    --net0 name=eth0,bridge=vmbr1,ip=10.0.100.201/24,gw=10.0.100.1,type=veth \
    --features nesting=1,keyctl=1 \
    --unprivileged 1 \
    --start 0

# Repeat for CT202-207 with appropriate hostname and IP
```

### Full Container Creation Script

```bash
#!/bin/bash
# Run on Proxmox host

TEMPLATE="local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"

declare -A CONTAINERS=(
    [201]="lilly:10.0.100.201"
    [202]="mike:10.0.100.202"
    [203]="clara:10.0.100.203"
    [204]="aria:10.0.100.204"
    [205]="finn:10.0.100.205"
    [206]="anya:10.0.100.206"
    [207]="atlas:10.0.100.207"
)

for CTID in "${!CONTAINERS[@]}"; do
    IFS=':' read -r HOSTNAME IP <<< "${CONTAINERS[$CTID]}"
    echo "Creating CT${CTID} - ${HOSTNAME} @ ${IP}"

    pct create $CTID $TEMPLATE \
        --hostname $HOSTNAME \
        --cores 2 \
        --memory 4096 \
        --swap 0 \
        --storage local-lvm \
        --rootfs local-lvm:40 \
        --net0 name=eth0,bridge=vmbr1,ip=${IP}/24,gw=10.0.100.1,type=veth \
        --features nesting=1,keyctl=1 \
        --unprivileged 1 \
        --start 0
done

echo "All containers created. Start with: pct start <CTID>"
```

---

## Phase 3: Base Configuration (Per Container)

### Bootstrap Script

```bash
#!/bin/bash
# Run inside each container after start

# Update system
apt update && apt upgrade -y

# Install base packages
apt install -y \
    git \
    tmux \
    curl \
    wget \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    sudo \
    htop \
    jq

# Install Node.js 20 LTS
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Verify versions
echo "Node.js: $(node --version)"
echo "npm: $(npm --version)"
echo "Python: $(python3 --version)"
```

### Create Eidolon User

```bash
# Create user (replace 'pulse' with role name)
ROLE_NAME="pulse"
useradd -m -s /bin/bash $ROLE_NAME
echo "$ROLE_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$ROLE_NAME

# Create directory structure
mkdir -p /home/$ROLE_NAME/{workspace,signals,logs,sessions}
chown -R $ROLE_NAME:$ROLE_NAME /home/$ROLE_NAME
```

---

## Phase 4: CLI Installation (Per Container)

```bash
# As the role user (e.g., 'pulse')
su - pulse

# Install Claude Code
npm install -g @anthropic-ai/claude-code

# Install Gemini CLI
npm install -g @google/gemini-cli

# Install Codex CLI
npm install -g @openai/codex

# Install GitHub Copilot
npm install -g @github/copilot

# Verify all CLIs
claude --version
gemini --version
codex --version
copilot --version
```

---

## Phase 5: Systemd Services (Per Container)

### Service Template: `/etc/systemd/system/max-agent@.service`

```ini
[Unit]
Description=MAX Pipeline Agent %i
After=network.target

[Service]
Type=simple
User=ROLE_USER_PLACEHOLDER
WorkingDirectory=/home/ROLE_USER_PLACEHOLDER/workspace
ExecStart=/home/ROLE_USER_PLACEHOLDER/bin/run-agent.sh %i
Restart=always
RestartSec=10
Environment=HOME=/home/ROLE_USER_PLACEHOLDER
Environment=AUTO_EXECUTE_BATONS=true

[Install]
WantedBy=multi-user.target
```

### Agent Runner Script: `/home/{role}/bin/run-agent.sh`

```bash
#!/bin/bash
AGENT="$1"
SESSION="max-${AGENT}"

# Ensure tmux session exists
tmux has-session -t $SESSION 2>/dev/null || tmux new-session -d -s $SESSION

# Attach and run daemon
exec tmux send-keys -t $SESSION "cd ~/workspace && python3 cor-daemon.py $AGENT" C-m
```

### Enable Services

```bash
# Enable all 4 agents for this Eidolon
systemctl enable max-agent@claude.service
systemctl enable max-agent@gemini.service
systemctl enable max-agent@codex.service
systemctl enable max-agent@copilot.service

# Start all
systemctl start max-agent@claude max-agent@gemini max-agent@codex max-agent@copilot
```

---

## Phase 6: Signal Directory Setup

### Option A: NFS Shared Storage (Recommended)

Since all containers are on the same Proxmox host:

**On Proxmox Host:**
```bash
# Install NFS server
apt install -y nfs-kernel-server

# Create shared directories
mkdir -p /var/lib/vz/shared/signals/max-pipeline
mkdir -p /var/lib/vz/shared/max-pipeline  # Client state

# Create inbox for each Eidolon
for role in lilly mike clara aria finn anya atlas; do
    mkdir -p /var/lib/vz/shared/signals/max-pipeline/${role}_inbox
done

# Export to internal network
echo "/var/lib/vz/shared 10.0.100.0/24(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports
exportfs -ra
```

**On Each Container (via Proxmox):**
```bash
# Add bind mount to container config
pct set 201 -mp0 /var/lib/vz/shared,mp=/mnt/shared

# Or via config file: /etc/pve/lxc/201.conf
# mp0: /var/lib/vz/shared,mp=/mnt/shared
```

### Option B: FastAPI Signal Hub (Alternative)

Deploy FastAPI signal service on CT100 (Mach42v2) and have MAX Eidolons poll via HTTP.

---

## Phase 7: Authentication (Manual Step)

**Requires Christian's presence for each Eidolon:**

1. SSH to container
2. Run each CLI auth:
   - `claude login`
   - `gemini login` (OAuth URL copy required)
   - `codex login` (or copy auth.json)
   - `copilot login` (GitHub OAuth)

**Tip:** Can batch authenticate using tmux sessions visible via Proxmox console.

---

## Phase 8: Clone Repository

```bash
# As role user
cd ~/workspace
git clone https://github.com/MEasAI/Measai-Maestro.git .

# Or sparse checkout for runtime only
git sparse-checkout init --cone
git sparse-checkout set AI_Agents src/maestro scripts dashboards
```

---

## Provisioning Checklist

| Phase | CT201 | CT202 | CT203 | CT204 | CT205 | CT206 | CT207 |
|-------|-------|-------|-------|-------|-------|-------|-------|
| M365 Account | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| LXC Created | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| Base Config | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| CLIs Installed | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| Systemd Setup | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| Signal Dir | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| Auth Complete | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| Repo Cloned | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| Services Running | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| Test Signal | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

---

## Questions for Christian

1. **Batch approach?** Should we provision all 7 at once, or start with 2-3 and expand?
2. **M365 licensing:** Do you have 7 Business Basic licenses available, or need to purchase?
3. **Conductor MCP:** Should each Eidolon run its own Conductor MCP server, or share via CT100?
4. **Pipeline Director:** Who hosts the PipelineDirector orchestrator - CT100 or separate?
5. **Kickoff timing:** When would you like to start the Proxmox provisioning?

---

## Next Steps (Once Approved)

1. Christian creates M365 accounts
2. SSH to Proxmox and run container creation script
3. Bootstrap each container with base packages
4. Install CLIs and configure systemd
5. Set up NFS shared signals
6. Authenticate all CLIs (requires interactive)
7. Deploy cor-daemon and test signal flow
8. Connect PipelineDirector

---

**Ready to proceed when you give the green light!**

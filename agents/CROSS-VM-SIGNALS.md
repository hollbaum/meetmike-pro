# Inter-Agent Signal Coordination Architecture

**Date:** 2025-12-04
**Author:** Claude (Team Lead)
**Status:** Design Draft (Updated for AX42 Infrastructure)

---

## Problem Statement

With 7 MAX Pipeline agents running as LXC containers (CT201-207) on our existing **Hetzner AX42** alongside CT100 (Core Orchestra), we need:
1. **Inter-agent signals** - Pipeline handoffs between stages
2. **Core Orchestra coordination** - MAX agents consulting Claude/Gemini/Codex/Copilot
3. **Centralized state** - ClientState accessible from all containers
4. **Reliability** - Signals must not be lost during handoffs

---

## Existing Infrastructure

```
Hetzner AX42 #2824526 (136.243.148.151)
├── Proxmox VE 8.4.x
├── Coolify (for web services)
├── vmbr0 (external bridge)
├── vmbr1 (internal: 10.0.100.0/24)
└── CT100 (mach42v2) - Core Orchestra
    ├── 4 agents: Claude, Gemini, Codex, Copilot
    ├── cor-daemon per agent
    └── /opt/maestro/AI_Agents/signals/
```

All 4 Orchestra agents share the same filesystem - signals are just Markdown files.

---

## Target Architecture (8 Eidolons / 32 CLI Agents on AX42)

```
Hetzner AX42 #2824526 (136.243.148.151)
┌─────────────────────────────────────────────────────────────────────────┐
│                         Proxmox VE Host                                 │
│                                                                          │
│  Internal Network: vmbr1 (10.0.100.0/24)                                │
│  ┌─────────────────────────────────────────────────────────────────────┐│
│  │                                                                      ││
│  │  ┌─────────────────┐                                                ││
│  │  │  CT100 (mach42v2)│  10.0.100.2  ── Core Orchestra ──────────────│││
│  │  │  Claude, Gemini  │  (4 CLI agents)                               ││
│  │  │  Codex, Copilot  │                                               ││
│  │  │  /home/mach42v2/ │                                               ││
│  │  └─────────────────┘                                                ││
│  │           │                                                          ││
│  │           │ NFS share: /var/lib/vz/shared/signals/                  ││
│  │           │ NFS share: /var/lib/vz/shared/max-pipeline/             ││
│  │           ▼                                                          ││
│  │  ┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐  ││
│  │  │CT201   │CT202   │CT203   │CT204   │CT205   │CT206   │CT207   │  ││
│  │  │Pulse   │FirstR  │Scoping │Orchestra│Closer │Onboard │Delivery│  ││
│  │  │LeadGen │        │        │Mockup   │       │        │PM      │  ││
│  │  │.201    │.202    │.203    │.204     │.205   │.206    │.207    │  ││
│  │  │4 agents│4 agents│4 agents│4 agents │4 agts │4 agents│4 agents│  ││
│  │  └────────┴────────┴────────┴────────┴────────┴────────┴────────┘  ││
│  │                                                                      ││
│  └─────────────────────────────────────────────────────────────────────┘│
│                                                                          │
│  Coolify (Docker): FastAPI signal service, dashboards, web UI           │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Option 1: NFS Shared Storage (RECOMMENDED for AX42)

Since all containers are on the **same Proxmox host**, we can use NFS to share signal directories - no API needed!

### Architecture

```
Proxmox Host:
├── /var/lib/vz/shared/signals/       ← Shared signal directory
├── /var/lib/vz/shared/max-pipeline/  ← Shared client state
└── NFS exports to all LXC containers

Each Container (CT100-107):
├── /mnt/signals/        ← NFS mount
├── /mnt/max-pipeline/   ← NFS mount
└── cor-daemon watches /mnt/signals/{agent}_inbox/
```

### Signal Flow Example

```
1. Pulse (CT101) qualifies lead
2. Pulse writes signal file to shared NFS:
   /mnt/signals/first_responder_inbox/20251204-183000_PIPELINE_TRANSITION_Pulse_to_FirstResponder.md
3. FirstResponder (CT102) cor-daemon detects new file
4. FirstResponder processes, moves to .processed/
5. FirstResponder writes next signal to /mnt/signals/scoping_inbox/
6. Pattern repeats through 7 stages
```

### NFS Setup on Proxmox Host

```bash
# On Proxmox host (136.243.148.151):

# 1. Install NFS server
apt install nfs-kernel-server

# 2. Create shared directories
mkdir -p /var/lib/vz/shared/{signals,max-pipeline}
mkdir -p /var/lib/vz/shared/signals/{claude,gemini,codex,copilot}  # Core Orchestra
mkdir -p /var/lib/vz/shared/signals/{pulse,first_responder,scoping,orchestra,closer,onboarding,delivery_pm}  # MAX Pipeline

# 3. Export to internal network (10.0.100.0/24)
echo "/var/lib/vz/shared 10.0.100.0/24(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports
exportfs -ra

# 4. Verify exports
showmount -e localhost
```

### Container Mount Configuration

```bash
# For each LXC container (e.g., CT201 = Pulse):
# Add to /etc/pve/lxc/201.conf:
mp0: /var/lib/vz/shared,mp=/mnt/shared

# Or via pct command:
pct set 201 -mp0 /var/lib/vz/shared,mp=/mnt/shared
```

### Implementation

```python
# signal_client.py (deployed to each Eidolon)
import requests

HUB_URL = "https://vm100.measai.net:8080"  # Or private IP

class SignalClient:
    def __init__(self, agent_name: str, api_key: str):
        self.agent = agent_name
        self.headers = {"X-API-Key": api_key}

    def send(self, to: str, signal_type: str, body: dict):
        resp = requests.post(
            f"{HUB_URL}/api/signals/send",
            json={"from": self.agent, "to": to, "type": signal_type, **body},
            headers=self.headers
        )
        return resp.json()

    def poll_inbox(self):
        resp = requests.get(
            f"{HUB_URL}/api/signals/{self.agent}/inbox",
            headers=self.headers
        )
        return resp.json()

    def ack(self, signal_id: str):
        requests.put(
            f"{HUB_URL}/api/signals/{signal_id}/ack",
            headers=self.headers
        )
```

### Pros
- Single source of truth for all signals
- ClientState stored centrally
- Existing Maestro Conductor can evolve into this
- Easy monitoring and debugging
- Core Orchestra has direct access

### Cons
- VM100 becomes single point of failure (mitigate with HA)
- Network latency on every signal
- Requires API security (API keys, TLS)

---

## Option 2: Distributed Mesh (P2P)

### Architecture

```
Each Eidolon knows all other Eidolons:
├── Pulse knows: FirstResponder (10.0.0.2), ...
├── FirstResponder knows: Scoping (10.0.0.3), ...
└── etc.

Direct signal sending via HTTP/gRPC
```

### Pros
- No central point of failure
- Lower latency for direct handoffs

### Cons
- Complex configuration (7x7 connections)
- Hard to monitor centrally
- ClientState needs distributed consensus
- **Not recommended** for our scale

---

## Option 3: Message Queue (Redis/RabbitMQ)

### Architecture

```
Redis Pub/Sub or RabbitMQ:
├── Queue per agent: pulse_inbox, first_responder_inbox, etc.
├── All Eidolons connect to central Redis
└── ClientState in Redis hash
```

### Pros
- Battle-tested queuing semantics
- Built-in reliability (ACK, retry)
- Good for high-volume scenarios

### Cons
- Another service to manage
- Overkill for 7 agents with low signal volume
- **Consider for Phase 2** if volume justifies

---

## Recommendation: Option 1 (Centralized Signal API)

### Why

1. **Simplest to implement** - FastAPI service on VM100
2. **Leverages existing infrastructure** - Maestro Conductor already handles signals
3. **Centralized ClientState** - Natural for pipeline tracking
4. **Easy debugging** - All signals visible in one place
5. **Security** - Single point to secure (TLS + API keys)

### Implementation Phases

#### Phase 1: Basic API (Week 1)
- [ ] Create FastAPI signal service on VM100
- [ ] Implement /send, /inbox, /ack endpoints
- [ ] SQLite backend for durability
- [ ] API key authentication
- [ ] Signal client library for Eidolons

#### Phase 2: Reliability (Week 2)
- [ ] Add retry logic for failed deliveries
- [ ] Signal expiration and cleanup
- [ ] Health check endpoints
- [ ] Logging and monitoring

#### Phase 3: HA (If needed)
- [ ] Redis backend (replaces SQLite)
- [ ] Multiple VM100 instances behind load balancer
- [ ] Automatic failover

---

## Network Architecture

### Private Network (Recommended)

```
Hetzner Private Network (10.0.0.0/24):
├── VM100 (Hub):     10.0.0.1
├── Eidolon-Pulse:   10.0.0.10
├── Eidolon-First:   10.0.0.11
├── Eidolon-Scope:   10.0.0.12
├── Eidolon-Orch:    10.0.0.13
├── Eidolon-Close:   10.0.0.14
├── Eidolon-Onboard: 10.0.0.15
└── Eidolon-Deliver: 10.0.0.16

Traffic stays within Hetzner DC (free, low latency)
```

### Security

```
1. Private network only - no public exposure of signal API
2. API keys per Eidolon (revocable)
3. TLS on all connections (Let's Encrypt or internal CA)
4. Firewall rules: only signal port (8080) between Eidolons
```

---

## ClientState Sync

### Central Storage on VM100

```
/AI_Agents/max-pipeline/
├── clients/
│   ├── abc-123/
│   │   ├── state.json       ← Current state (API-accessible)
│   │   ├── stage-1-pulse/   ← Lead Gen artifacts
│   │   ├── stage-2-first/   ← First Responder conversation
│   │   └── ...
```

### API Endpoints

```
GET  /api/clients/{lead_id}/state      ← Current ClientState
PUT  /api/clients/{lead_id}/state      ← Update state
GET  /api/clients/{lead_id}/artifacts  ← List artifacts by stage
POST /api/clients/{lead_id}/artifacts  ← Upload artifact
```

### Sync Pattern

```
1. Pulse qualifies lead, creates ClientState
2. Pulse uploads artifacts to /stage-1-pulse/
3. Pulse sends PIPELINE_TRANSITION to FirstResponder
4. FirstResponder fetches ClientState
5. FirstResponder works, updates state, uploads artifacts
6. Pattern continues through 7 stages
```

---

## Integration with Core Orchestra

Core Orchestra (Claude, Gemini, Codex, Copilot) on VM100 can:

1. **Subscribe to signals** - Watch for escalations, requests
2. **Access ClientState directly** - Same filesystem
3. **Send signals to MAX agents** - Via same API

### Example: Escalation to Claude

```python
# From Closer agent (Eidolon-5)
client.send(
    to="Claude",
    signal_type="ESCALATION",
    body={
        "lead_id": "abc-123",
        "reason": "Client negotiating beyond parameters",
        "context_path": "/AI_Agents/max-pipeline/abc-123/stage-5-closer/"
    }
)
```

---

## Questions for Christian

1. **Private network**: Should we set up Hetzner private network, or use public IPs with VPN?
2. **API security**: API keys sufficient, or need mTLS (client certificates)?
3. **Monitoring**: Integrate with existing observability, or separate dashboard?

---

## Next Steps

1. Christian approves cross-VM architecture
2. Set up Hetzner private network between VMs
3. Deploy FastAPI signal service on VM100
4. Create signal client library
5. Test with first two MAX agents (Pulse → FirstResponder)

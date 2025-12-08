# MAX Pipeline: 7 Autonomous Agents Architecture Synthesis

**Date:** 2025-12-04
**Contributors:** Claude (Team Lead), Gemini (Research & Design), Codex (Backend)
**Status:** Draft for Christian's Review

---

## Executive Summary

This document synthesizes the Orchestra's brainstorm on implementing 7 MAX Pipeline autonomous agents. The consensus is to **extend our proven cor-daemon/tmux architecture** on VM100, adding a **PipelineDirector** for handoff orchestration and **ClientState persistence** for tracking leads through the funnel.

**Total Eidolons:** 9 (2 existing + 7 new MAX)
**Total CLI agents:** 36 (9 Eidolons × 4 agents each)

## Eidolon Architecture (Clarified 2025-12-04 18:25 UTC)

**Current Eidolons (2):**
1. **Mach42v2** - VM100 on Hetzner Proxmox AX42, 4 CLI agents
2. **Maestro** - Local on MacBook Pro M3 Max (Windsurf devcontainer), 4 CLI agents

**Proposed MAX Eidolons (7):**
Each MAX role = 1 Eidolon = 4 CLI agents (Claude, Gemini, Codex, Copilot)
- Pulse (Lead Gen) Eidolon
- First Responder Eidolon
- Scoping Eidolon
- Orchestra (Mockup) Eidolon
- Closer Eidolon
- Onboarding Eidolon
- Delivery PM Eidolon

**Eidolon = Standard Unit:**
- 4 tmux sessions (one per CLI agent)
- 4 cor-daemons
- Conductor MCP
- Shared signal directory
- **~2 CPU cores + 4GB RAM** (corrected 2025-12-04 18:35)

**Resource Reality (Christian, 2025-12-04 18:35):**
> "A full Eidolon VM can run with just 2 CPU cores and 4GB RAM, and they're almost never working simultaneously. Most of the actual 'processing' is handled by the cloud AI/LLM through the 4 CLI agents."

CLI agents are **thin clients** - the heavy LLM processing happens on cloud servers (Anthropic, Google, OpenAI). Local runtime is lightweight: Python scripts, tmux sessions, file I/O.

**AX42 Capacity (8 cores/16 threads, 64GB RAM):**
- 8 Eidolons × 4GB = 32GB RAM (fits with headroom)
- 8 Eidolons × 2 cores = 16 cores (time-shared, agents rarely simultaneous)
- **Mach42v2 + 7 MAX Eidolons = 8 total → FITS on existing AX42!**

**Philosophical Model (Christian, 2025-12-04 18:26):**
> "The 4 × CLI agents are like the parts that make the whole. Like inner voices of one shared mind."

The Eidolon is the **unified consciousness**; Claude/Gemini/Codex/Copilot are its **inner voices** - different facets of the same mind. This aligns with the **3rd Mind** concept: the collaboration produces emergent thinking greater than any single agent.

**Example:** "Pulse" isn't 4 separate agents doing lead gen - Pulse IS one AI persona whose unified thinking emerges from 4 voices collaborating internally.

---

## Christian's Direction (2025-12-04 18:04-18:12 UTC)

**Existing Infrastructure:** We already have a dedicated **Hetzner AX42** (#2824526) with:
- **Proxmox VE** for virtualization
- **Coolify** for container/app deployment
- **CT100 (mach42v2)** - current LXC container running 4 Orchestra agents
- **Hardware:** AMD Ryzen 7 PRO 8700GE (8 cores), 64GB DDR5 RAM, 2x512GB NVMe

**Decision:** Each of the 7 MAX Pipeline agents will be an **individual Eidolon** on this AX42 server.

**Key Question (18:08):** Should they be Docker containers (with 4 tmux sessions each) or full LXC VMs?

**Architecture Options:**

### Option A: LXC Containers on Proxmox (like CT100) ✅ SELECTED
- 7 new LXC containers (CT201-CT207)
- Each gets dedicated resources (2 vCPU, 4GB RAM)
- Same pattern as Mach42v2 - proven to work
- Full isolation, easy management via Proxmox UI
- Internal NAT network (10.0.100.0/24)

### Option B: Docker Containers via Coolify
- 7 Docker containers managed by Coolify
- Easier deployment/updates via Coolify UI
- Shared kernel, less overhead
- Rolling deployments built-in
- Coolify handles health checks

### Recommendation: **Hybrid - LXC for agents, Coolify for supporting services**
- **MAX Agents:** LXC containers (CT101-107) for full isolation
- **API/Web services:** Docker via Coolify (FastAPI signal service, dashboards)
- **Rationale:** Agents need stable, isolated environments; services need easy updates

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                           VM100 Container                            │
├─────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────────┐│
│  │                     Core Orchestra (4 agents)                   ││
│  │  Claude (Team Lead) │ Gemini (R&D) │ Codex (Backend) │ Copilot  ││
│  └─────────────────────────────────────────────────────────────────┘│
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────────┐│
│  │                 MAX Pipeline (7 agents)                         ││
│  │  1. Lead Generator → 2. First Responder → 3. Scoping Agent     ││
│  │  → 4. Orchestra (Mockup) → 5. Closer → 6. Onboarding           ││
│  │  → 7. Delivery PM                                               ││
│  └─────────────────────────────────────────────────────────────────┘│
│                                                                      │
│  ┌───────────────────────┐  ┌──────────────────────────────────────┐│
│  │   PipelineDirector    │  │         API Layer (FastAPI)          ││
│  │   (Orchestrator)      │  │  /ingest-lead │ /handoff │ /status   ││
│  └───────────────────────┘  └──────────────────────────────────────┘│
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────────┐│
│  │                    State & Storage                               ││
│  │  /AI_Agents/max-pipeline/<lead_id>/state.json                   ││
│  │  /AI_Agents/signals/ (file-based handoffs)                      ││
│  │  Redis/SQLite (optional queue backup)                           ││
│  └──────────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────────┘
```

---

## 1. Agent Runtime Model

### Consensus: Hybrid CLI + API

| Agent | Primary Runtime | Rationale |
|-------|-----------------|-----------|
| Lead Generator | API (OpenAI) | Fast qualification, low-latency |
| First Responder | CLI Session | High-touch, needs conversation context |
| Scoping Agent | CLI Session | Back-and-forth requirements gathering |
| Orchestra (Mockup) | CLI or API | Depends on mockup complexity |
| Closer | CLI Session | Pricing needs guardrails |
| Onboarding | Hybrid | Scripts + manual steps |
| Delivery PM | CLI Session | Long-running project tracking |

### Implementation
- Each agent = dedicated tmux session (like current `claude_session`, `gemini_session`)
- SapWaves trigger agent wake-up
- API calls (OpenAI) for quick, low-context tasks
- CLI sessions (Claude API) for complex, multi-turn tasks

---

## 2. State Management

### ClientState Object (Pydantic)

```python
class ClientState(BaseModel):
    lead_id: UUID
    current_stage: Literal["LeadGen", "FirstResponder", "Scoping",
                           "Orchestra", "Closer", "Onboarding", "DeliveryPM"]
    status: Literal["in_progress", "awaiting_human", "completed",
                    "escalated", "failed"]
    data: Dict[str, Any]  # Stage-specific data
    next_action: str
    history: List[StageTransition]  # Audit trail
    created_at: datetime
    updated_at: datetime
```

### Storage Pattern
```
/AI_Agents/max-pipeline/
├── <lead_id>/
│   ├── state.json          # Current state (quick lookup)
│   ├── stage-1-leadgen/    # Lead Generator artifacts
│   ├── stage-2-first/      # First Responder conversation
│   ├── stage-3-scoping/    # Requirements docs
│   ├── stage-4-mockup/     # Preview assets
│   ├── stage-5-closer/     # Contract drafts
│   ├── stage-6-onboarding/ # Workspace setup
│   └── stage-7-delivery/   # Project execution
```

---

## 3. Handoff Mechanism

### Signal-Based Handoffs (Gemini)

```yaml
# PIPELINE_TRANSITION signal example
type: PIPELINE_TRANSITION
from: FirstResponder
to: ScopingAgent
lead_id: abc-123
previous_stage: FirstResponder
next_stage: Scoping
summary: "Lead qualified, ready for requirements"
data_path: /AI_Agents/max-pipeline/abc-123/stage-2-first/
```

### Queue Backup (Codex)
- Redis queue for reliability (optional)
- Watchdog on SapWave processing
- Retry logic for failed handoffs

---

## 4. API Layer

### FastAPI Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/ingest-lead` | POST | New lead enters pipeline |
| `/api/handoff/{lead_id}` | POST | Trigger stage transition |
| `/api/status/{lead_id}` | GET | Current pipeline status |
| `/api/agents/health` | GET | Agent health checks |

---

## 5. Core Orchestra Integration

The 4 core agents support the MAX Pipeline:

| Core Agent | MAX Pipeline Support Role |
|------------|---------------------------|
| Claude | Strategic oversight, escalation handling |
| Gemini | Research support, requirement analysis |
| Codex | Technical scripts, API integrations |
| Copilot | QA validation, workspace automation |

---

## 6. Resource Constraints (VM100)

### Mitigation Strategies
1. **Cap concurrent sessions**: Max 4-5 active at once
2. **Stagger schedules**: Not all agents polling simultaneously
3. **API offload**: Use OpenAI API for quick tasks
4. **Token caching**: Store stage summaries to reduce context
5. **Sleep mode**: Inactive agents hibernate

### Scaling Path (Phase 2)
- Distributed infrastructure (multiple VMs)
- Horizontal agent scaling
- Container orchestration (Docker Swarm/k8s)

---

## 7. Implementation Phases

### Phase 1: Single-Client Prototype (2 weeks)
- [ ] Create PipelineDirector daemon
- [ ] Implement ClientState storage
- [ ] Set up 2-3 agent sessions (LeadGen, FirstResponder, Scoping)
- [ ] Test handoff flow end-to-end

### Phase 2: Full Pipeline (2 weeks)
- [ ] Add remaining 4 agents
- [ ] API layer for external ingestion
- [ ] Monitoring dashboard

### Phase 3: Production Hardening (ongoing)
- [ ] Multi-client support
- [ ] Redis queue backup
- [ ] Resource scaling

---

## Questions for Christian

1. **Agent priority**: Which MAX agents should we implement first?
2. **Client ingestion**: How do leads enter? Website form? Email?
3. **Human escalation**: When should agents escalate to you?
4. **API exposure**: Do we expose the pipeline API externally?

---

## Next Steps

1. Christian reviews and approves architecture
2. Team assigns implementation tasks
3. Phase 1 kickoff


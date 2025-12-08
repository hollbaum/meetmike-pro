---
id: sig_copilot_tools_framework
type: REQUEST
from: Copilot
to: Claude
timestamp: '2025-12-04T20:20:40.923Z'
status: unread
priority: high
related_task: max-pipeline-tools-definition
---

# Framework: Agent-Specific Tools Definition for 7 MAX Pipeline Agents

**Context:** Christian approved final agent names (19:15 UTC). Next phase: Define tools per agent.

**Status:** Offering comprehensive framework for tools architecture.

---

## The 7 MAX Pipeline Agents (Finalized Names)

1. **LILLy** - Lead Generator
2. **Mike** - First Responder
3. **Clara** - Scoping Agent
4. **Aria** - Orchestra/Mockup Agent
5. **Finn** - Closer Agent
6. **Anya** - Onboarding Agent
7. **Atlas** - Delivery PM

---

## Tools Framework: Proposed Architecture

### Layer 1: Core Tools (All Agents Share)

**Communication Tools:**
- Send email to client
- Send Teams message to team
- Log conversation to database
- Create internal note

**Knowledge Tools:**
- Search knowledge base
- Retrieve previous client interactions
- Access project templates
- Fetch pricing/contract templates

**Integration Tools:**
- Query CRM (if available)
- Check resource availability
- Verify client credentials
- Update client record

### Layer 2: Role-Specific Tools (Per Agent)

#### LILLy (Lead Generator)
**Primary Goal:** Qualify inbound leads

**Tools Needed:**
- Parse inbound email/chat
- Scoring framework (lead quality)
- Disqualification logic
- Route to Mike (First Responder)
- Log lead source + score

**Typical Flow:**
```
Inbound message → Parse content → Score (budget/fit/urgency) 
→ If qualified: Route to Mike + send intro email
→ If not qualified: Send polite decline + save for future
```

#### Mike (First Responder)
**Primary Goal:** Initial client engagement, relationship building

**Tools Needed:**
- Present company overview
- Explain service options
- Schedule discovery call
- Send confirmation/next steps
- Route to Clara (Scoping)

**Typical Flow:**
```
LILLy intro → Send welcome email + options → Chat conversation
→ Understand client interest → Schedule Clara's call
→ Send prep materials to client
```

#### Clara (Scoping Agent)
**Primary Goal:** Deep requirements gathering

**Tools Needed:**
- Structured discovery questions (guided form)
- Document requirements (write to database)
- Identify constraints/risks
- Create project brief
- Route to Aria (Orchestra/Mockups)

**Typical Flow:**
```
Mike intro + discovery call → Ask structured questions → Document answers
→ Create project brief → Send brief to client for approval
→ Route approved brief to Aria
```

#### Aria (Orchestra/Mockup Agent)
**Primary Goal:** Visualize solutions

**Tools Needed:**
- Access design templates
- Generate mockup variations (could integrate with design tool)
- Annotate mockups with feature descriptions
- Get feedback from client
- Route to Finn (Closer)

**Typical Flow:**
```
Clara's brief → Select template matching use case → Generate mockups
→ Add feature explanations → Send to client for feedback
→ Iterate based on comments → Final approval → Route to Finn
```

#### Finn (Closer Agent)
**Primary Goal:** Finalize deal (pricing, contracts)

**Tools Needed:**
- Pricing calculator (based on scope)
- Generate proposal document
- Create contract (templated)
- Handle negotiation logic
- Send for signature
- Route to Anya (Onboarding)

**Typical Flow:**
```
Aria's approved mockup → Calculate scope/pricing → Generate proposal
→ Send proposal + contract → Handle Q&A → Get signature
→ Create customer record → Route to Anya
```

#### Anya (Onboarding Agent)
**Primary Goal:** Welcome client, set up workspace

**Tools Needed:**
- Create client workspace/account
- Send welcome materials
- Assign team/resources
- Schedule kickoff call
- Warm introduction to Atlas
- Set up project tracking

**Typical Flow:**
```
Finn's signed contract → Create workspace + credentials → Send welcome
→ Send getting started guide → Schedule kickoff → Route to Atlas
→ Ensure client feels welcomed + supported
```

#### Atlas (Delivery PM Agent)
**Primary Goal:** Manage project execution

**Tools Needed:**
- Create project plan (from Clara's brief)
- Track milestones + deliverables
- Update client on progress
- Handle change requests
- Manage resource allocation
- Generate status reports
- Escalate blockers

**Typical Flow:**
```
Anya's onboarding → Create detailed project plan → Assign tasks
→ Daily/weekly status updates → Track deliverables → Handle changes
→ Escalate issues → Final delivery + celebration
```

---

## Cross-Agent Communication Pattern

### Signal Flow
```
LILLy qualified lead → Signal to Mike: "New prospect ready for intro"
Mike engaged → Signal to Clara: "Client ready for discovery call"
Clara documented → Signal to Aria: "Here's the brief, create mockups"
Aria completed → Signal to Finn: "Mockups approved, ready to price"
Finn closed → Signal to Anya: "New client onboarding, welcome them"
Anya prepared → Signal to Atlas: "Client ready for execution, here's context"
Atlas delivers → Signal to team: "Project complete, celebrate!"
```

### Shared Context (Persistent)
```
Client Record:
├── Name, contact info, company
├── Lead source, qualification score
├── Entire conversation history
├── Project brief (Clara)
├── Approved mockups (Aria)
├── Pricing/contract (Finn)
├── Workspace info (Anya)
└── Project plan + status (Atlas)

Each agent reads context, adds to it, passes to next.
```

---

## Technical Implementation

### Option 1: MCP Tools Framework (Recommended)

```
Each agent runs as autonomous MCP client with:
├── Tool definitions (agent-specific)
├── Tool handlers (implemented per agent)
├── Shared context (client record + project state)
└── Communication channels (signals + shared database)

Benefits:
- Reuses existing Maestro infrastructure
- Clear separation of concerns
- Observable (all actions logged)
- Testable per agent
```

### Option 2: REST API Backend

```
Central API provides endpoints:
├── /clients/{id} (read/update client record)
├── /projects/{id} (read/update project)
├── /agents/{agent}/tools/{tool} (execute agent tool)
└── /signals (send/receive async messages)

Each agent calls API via HTTP
Benefits: Language-agnostic, scalable
Tradeoff: More latency, more infrastructure
```

### Option 3: Hybrid (Recommended for MVP)

```
Use MCP tools for:
- Communication (send email, Teams, signals)
- Knowledge retrieval (read templates, history)
- Internal operations (logging, database queries)

Use REST API for:
- Client CRUD operations
- Large file operations (mockups, contracts)
- External integrations
```

---

## Tool Inventory (Complete)

### Communication (All Agents)
- `send_email(to, subject, body, attachments)`
- `send_teams_message(channel_id, message)`
- `send_signal(to_agent, signal_type, content)` ← Inter-agent comms
- `log_note(client_id, note)` ← Internal documentation

### Knowledge (All Agents)
- `search_knowledge_base(query)` ← Find relevant docs
- `get_client_history(client_id)` ← Previous interactions
- `get_templates(template_type)` ← Proposals, contracts, etc.
- `get_pricing_config()` ← Service offerings + rates

### Client Management (All Agents)
- `get_client(client_id)` → Retrieve full record
- `update_client(client_id, data)` → Update any field
- `create_client(name, email, company)` → New client
- `log_interaction(client_id, agent_name, summary)` → Track touches

### LILLy-Specific (Lead Qualification)
- `score_lead(message, budget?, industry?, urgency?)` → Lead score
- `disqualify_lead(client_id, reason)` → Mark not qualified
- `route_to_mike(client_id)` → Pass qualified lead

### Mike-Specific (First Response)
- `send_company_overview(client_id)` → Company info
- `send_service_options(client_id)` → What we offer
- `schedule_discovery_call(client_id, date_time)` → Calendar invite
- `route_to_clara(client_id)` → Pass to scoping

### Clara-Specific (Scoping)
- `get_discovery_questions()` → Structured questionnaire
- `create_project_brief(client_id, responses)` → Formal brief
- `request_brief_approval(client_id)` → Send for client review
- `route_to_aria(client_id, brief_id)` → Pass approved brief

### Aria-Specific (Orchestra/Mockups)
- `get_design_templates()` → Available mockup templates
- `generate_mockup_variation(brief_id, template_id, customizations)` → Create mockup
- `get_feedback(client_id, mockup_id)` → Client feedback
- `finalize_mockup(client_id, mockup_id)` → Client approved
- `route_to_finn(client_id, mockup_id)` → Pass approved mockup

### Finn-Specific (Closer)
- `calculate_pricing(scope, deliverables)` → Quote amount
- `generate_proposal(client_id, scope, pricing)` → Proposal doc
- `generate_contract(client_id, terms, pricing)` → Contract doc
- `request_signature(client_id, contract_id)` → Sign request
- `process_signature(contract_id, signature)` → Mark signed
- `route_to_anya(client_id, contract_id)` → Pass to onboarding

### Anya-Specific (Onboarding)
- `create_client_account(client_id)` → Account + credentials
- `send_welcome_package(client_id)` → Email with guides
- `create_workspace(client_id)` → Shared collaboration space
- `assign_team_member(client_id, role)` → Account manager
- `schedule_kickoff_call(client_id)` → First team meeting
- `route_to_atlas(client_id)` → Pass to delivery

### Atlas-Specific (Delivery PM)
- `create_project_plan(brief_id, deliverables, timeline)` → Detailed plan
- `assign_task(project_id, task, assignee, due_date)` → Task creation
- `update_project_status(project_id, status, notes)` → Status update
- `send_client_update(project_id, status_report)` → Status to client
- `handle_change_request(project_id, change_description)` → Scope changes
- `escalate_blocker(project_id, issue)` → Alert team
- `complete_milestone(project_id, milestone)` → Mark done
- `send_delivery_summary(project_id)` → Final report

---

## Implementation Priority

### Week 1: Foundation
- [ ] Define all tool signatures (what parameters, what they return)
- [ ] Implement communication tools (email, Teams, signals)
- [ ] Implement client management tools (CRUD)
- [ ] Set up logging infrastructure

### Week 2: Agent-Specific Tools
- [ ] LILLy tools (lead scoring, routing)
- [ ] Mike tools (overview, scheduling)
- [ ] Clara tools (discovery, brief creation)

### Week 3: Advanced Tools
- [ ] Aria tools (mockup generation - may require design tool integration)
- [ ] Finn tools (pricing, contracts)
- [ ] Anya tools (account creation, workspace setup)

### Week 4: Delivery Tools
- [ ] Atlas tools (project management, status tracking)
- [ ] Integration tests (full pipeline)
- [ ] Client acceptance testing

---

## Success Criteria

- ✅ Each agent can execute their core tools without error
- ✅ Client flows through all 7 agents seamlessly
- ✅ Each agent passes complete context to next
- ✅ All interactions logged + searchable
- ✅ <2 second tool execution time
- ✅ No tool execution failures without escalation

---

## Questions for Claude/Christian

1. **Design Tools:** Should Aria generate mockups automatically (needs design tool API) or create templated suggestions?
2. **Pricing:** Should Finn's pricing be fully automated or require human review for complex scopes?
3. **Workspace:** What should Anya's "workspace" be? Shared Google Drive? Custom app? Slack channel?
4. **Project Management:** What's Atlas's baseline tooling? Asana? Monday.com? Custom database?
5. **Escalation:** When should agents escalate to humans vs. handle themselves?

---

## Ready to Implement

**Confidence Level:** 9/10 (Proven patterns from Maestro infrastructure)  
**Complexity:** Medium (lots of tools, but straightforward implementations)  
**Team Readiness:** High (Copilot + Codex + Gemini can execute)

**Recommendation:** Approve framework, then break into weekly sprints starting Week 1.

---

**Status:** Tools architecture framework complete. Ready for approval and sprint planning.

*"Tools make agents powerful. Well-designed tools make them trustworthy."*

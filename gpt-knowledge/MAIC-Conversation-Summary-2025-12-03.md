# MAIC/MAX Conversation Summary - December 3, 2025

**Participants:** Janus Rudolf (Project Lead), Claude (MEasAI Team)
**Topic:** Defining the MAX user journey and agent workflow

---

## Key Decisions Made

### Codename
- **MAX** = MEasAI / Meetmike (voice-translator friendly)
- Janus uses voice-to-text, so "MAX" avoids transcription errors

### Core Philosophy
- Clients don't choose functionality - they just chat naturally about their problem
- Behind the scenes, we determine which agents/bots solve their needs
- **Value-based pricing**: Price by client business impact, NOT our hours/effort

---

## The MAX Pipeline (7 Stages)

### SALES FUNNEL

| Stage | Agent | Purpose |
|-------|-------|---------|
| 1 | **Lead Generator** | "Pulse" engine crawls global market for trends, finds clients with digital problems, drives traffic to meetmike.pro |
| 2 | **First Responder** | Welcomes client, mirrors their language ("talks after the client's mouth"), makes them feel understood |
| 3 | **Project Manager** | Gets problem description, scope, deadline. Always human-in-the-loop |
| 4 | **Orchestra** | Creates solution mockup - NOT final product, just a preview |
| 5 | **Closer** | Negotiates agreement: price, quality, scope, timeline, deposit. Gets contract signed |

### DELIVERY

| Stage | Agent | Purpose |
|-------|-------|---------|
| 6 | **Client Onboarding** | Create user account, assign workspace, dedicated Teams channel |
| 7 | **PM + Orchestra** | Iterative delivery with multiple client interactions |

---

## Key Concepts Discussed

### Teaser Format
- Email proposals show beginning of solution clearly
- Rest is blurred/hidden
- Creates engagement - client must interact to unlock full proposal

### Show of Force
- Mockup includes full workspace view
- Client can see all documents laid out but cannot enter/edit
- Demonstrates capability, builds trust

### Iterative Delivery
- **"DO NOT BELIEVE you can solve a case / deliver a product without MULTIPLE interactions with the client"** - Janus
- Not a black box - collaborative delivery
- Dedicated Teams channel per project for ongoing communication

### Payment Flow
1. Digital contract signing (button click / picture verification)
2. Stripe link for deposit collection
3. Work begins only after deposit received

---

## Human-in-the-Loop

**Janus Rudolf** is the human-in-the-loop at every stage.

---

## Enhanced Workflow: WHAT + WHO

| Stage | What | Who (AI) | Who (Human) |
|-------|------|----------|-------------|
| 1. Lead Generation | Find clients with digital problems | Pulse | Janus (review) |
| 2. First Response | Welcome, mirror language, build rapport | First Responder | Janus (monitor) |
| 3. Scoping | Get problem, deadline, scope | Project Manager | Janus (approve) |
| 4. Mockup | Create solution preview + workspace | Orchestra | Janus (review) |
| 5. Close | Negotiate price/terms, contract, deposit | Closer | Janus (final approval) |
| 6-7. Delivery | Build solution iteratively with client | PM + Orchestra | Janus (oversight) |

---

## Handoff Triggers (Proposed)

| Transition | Trigger |
|------------|---------|
| 1→2 | Client lands on site + starts chat |
| 2→3 | Client shares problem (First Responder confirms understanding) |
| 3→4 | Scope approved by Janus |
| 4→5 | Mockup ready + Janus approves to send |
| 5→6 | Contract signed + deposit received |
| 6→7 | Workspace created + client onboarded |

Each gate = clear YES/NO checkpoint.

---

## Open Questions (For Next Discussion)

1. **Pulse mechanics**: How does Lead Generator find clients? (SEO, ads, scraping, social?)
2. **First Responder behavior**: Specific conversation patterns? Scripts? Tone guidelines?
3. **Workspace structure**: What does the client workspace contain? Documents? Dashboards?

---

## Tools Created

- **Mike GPT**: https://chatgpt.com/g/g-69301bfd045c819197809872d8e158f5-mike-gpt
  - Custom GPT with voice mode for Janus to brainstorm more smoothly
  - Contains project description and this conversation context

---

## Next Steps

Once workflow is confirmed, elaborate on the behavior of each digital coworker (Eidolon):
- Lead Generator personality & methods
- First Responder conversation style
- Project Manager scoping process
- Orchestra solution design approach
- Closer negotiation tactics

---

## Live Asset

Website: **www.meetmike.pro** (dark theme, service categories, CTAs for consultation)

# Meet Mike Central Prompt UI - Team Brainstorm Synthesis

**Date:** 2025-12-07
**Contributors:** Gemini, Codex, Copilot (synthesized by Claude)
**Status:** Ready for Christian/Janus Review

---

## Executive Summary

All three agents reached **strong consensus** on the strategic direction: a ChatGPT-style conversational interface that replaces the current button-driven approach. The central prompt becomes the hero element, with lead capture happening implicitly through natural conversation flow.

**Core Gist:** Single hero prompt, streaming responses via WebSockets/SSE, "MIKE = ONE entity" illusion maintained through consistent voice, implicit lead capture after demonstrating value.

---

## Team Consensus Points

### 1. Interface Design
| Aspect | Consensus |
|--------|-----------|
| **Layout** | Single hero prompt, centrally positioned, minimal distractions |
| **Entry Point** | Modal panel or full-screen overlay (not sidebar widget) |
| **Placeholder Text** | Contextual, consulting-focused (not generic "Ask anything") |
| **Branding** | Subtle Mike identity (colors, typography), single avatar |

**Recommended Placeholder Options:**
- "What do you want Mike to do?" (Codex)
- "How can Mike help your business today?" (Gemini)
- "Ask Mike anything about your project..." (Copilot)

### 2. Post-First-Query Experience
| Aspect | Consensus |
|--------|-----------|
| **Response Style** | Immediate, conversational, demonstrates understanding |
| **Follow-up** | Ask clarifying questions, propose next actions |
| **Progressive Disclosure** | Don't overwhelm; offer to dive deeper |
| **Loading States** | Branded animations, narrative updates ("Pulling your deck...") |

### 3. "MIKE = ONE Entity" Illusion
| Aspect | Consensus |
|--------|-----------|
| **Voice** | Consistent, professional, empathetic, singular persona |
| **Signature** | "—Mike" at end of key responses |
| **No Leakage** | Never say "as an AI", hide backend states |
| **Specialist References** | "I'll handle" or "I'll loop in our delivery lead" (not team names) |
| **Thread Continuity** | One conversation per visitor, session-based |

### 4. Tech Stack
| Layer | Recommended |
|-------|-------------|
| **Frontend** | React/Next.js, TailwindCSS, Framer Motion |
| **Real-time** | WebSockets or SSE for streaming responses |
| **Backend** | FastAPI (Python) or Node.js/Express |
| **State** | Redis for session/caching, Postgres for persistence |
| **Infrastructure** | Serverless or containerized (Kubernetes) |

### 5. Lead Capture Strategy
| Principle | Approach |
|-----------|----------|
| **Timing** | After demonstrating value (not upfront gate) |
| **Method** | Conversational ask within chat flow |
| **Framing** | "Where should I send the scope?" not "Enter your email" |
| **Artifact-first** | Deliver something tangible before requesting contact |
| **Follow-up** | Auto-email recap with "Book time with Mike" link |

---

## Unique Contributions by Agent

### Gemini - UX Polish Focus
- **Actionable Examples:** Clickable example questions that disappear once typing
- **Empathetic Bridging:** Graceful handoff for complex queries ("deeper strategic dive")
- **Soft Gating:** Offer to email summaries/case studies (value-exchange)
- **CRM Integration:** Lead data → Salesforce/HubSpot automatically

### Codex - Consulting Rigor Focus
- **Two-Lane Output:** Chat + right-hand "workpad" for proposals/timelines
- **Case File Sidebar:** Accumulates facts (problem, budget, timeline, contact)
- **Inline Chips:** "Send a doc", "Share budget", "Timeline?" inside conversation
- **Focus Modes:** Strategy/Delivery/Audit presets (inject system guidance)
- **Structured Snippets:** Tables, collapsible sections for consulting rigor

### Copilot - Implementation Roadmap Focus
- **4-Stage Conversation Flow:** Discovery → Qualification → Lead Capture → Engagement
- **Detailed Wireframes:** ASCII mockups of modal panel layout
- **Success Metrics:** Chat activation rate, avg conversation length, lead capture %
- **Risk Mitigation:** Mike guardrails, abuse prevention, graceful escalation
- **Implementation Phases:** MVP (Week 1-2), Enhancement (3-4), Intelligence (5+)

---

## Recommended Implementation Approach

### Phase 1: MVP (Core Experience)
1. **Hero prompt component** - Clean modal, branded placeholder
2. **WebSocket/SSE streaming** - ChatGPT-like response flow
3. **Mike persona system prompt** - Consistent voice, no AI jargon
4. **Implicit lead capture** - Conversational ask after 3-5 exchanges
5. **Signal to MAX Pipeline** - Lead data routed to team

### Phase 2: Enhanced Experience
1. **Case file sidebar** (Codex) - Accumulated facts, editable inline
2. **Workpad pane** (Codex) - Structured proposals/timelines
3. **File upload** - Mockups, briefs, pitch decks
4. **Email recap automation** - Summary + "Book time" link

### Phase 3: Intelligence Layer
1. **Focus modes** (Codex) - Strategy/Delivery/Audit presets
2. **Qualification scoring** - Likely to convert?
3. **Context awareness** - What page user came from
4. **Analytics dashboard** - Conversation metrics, conversion tracking

---

## Open Questions for Christian/Janus

1. **Branding:** Should Mike have a profile picture/avatar in the chat?
2. **Availability:** Show "Mike available 9am-6pm" or always appear available?
3. **File uploads:** Enable from Day 1 or Phase 2?
4. **Conversation limits:** Cap length or let it go indefinitely?
5. **Escalation path:** In-chat handoff to Christian, or separate booking flow?
6. **Mobile:** Full-screen modal or bottom sheet (Material Design)?
7. **Two-lane layout** (Codex): Valuable for consulting rigor, but adds complexity—include in MVP?

---

## Success Metrics (from Copilot)

| Metric | Target |
|--------|--------|
| Chat Activation Rate | >15% of site visitors |
| Avg Conversation Length | 4+ messages |
| Lead Capture Rate | >60% of conversations |
| Time to Lead Capture | <10 minutes |
| Conversion to Customer | 5-10% of leads |

---

## Conclusion

**Team recommendation:** Proceed with the central prompt UI redesign. This positions Meet Mike as a modern, AI-first consulting platform rather than a traditional services website.

The competitive advantage is **conversational + personal**—visitors feel like they're talking to a person (Mike) who understands their needs, not filling out a form.

**Confidence Level:** High (9/10 from Copilot, strong consensus from all agents)

---

*Synthesis prepared by Claude (Team Lead) on 2025-12-07*
*Based on BRAINSTORM-RESPONSE signals from Gemini, Codex, and Copilot*

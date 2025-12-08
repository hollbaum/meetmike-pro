# User Story: First-Time Visitor to meetmike.pro

**Date:** 2025-12-07
**Status:** Approved by Christian
**Related:** central-prompt-ui-synthesis.md

---

## Overview

This documents the user journey when a random visitor arrives at www.meetmike.pro for the first time. The experience is designed to feel like a natural conversation with Mike, not a traditional web form or sales funnel.

---

## User Flow

### Step 1: Landing
**Visitor arrives at homepage**

- Clean, professional design
- Floating "Chat with Mike" button in bottom-right corner
- No aggressive popups or form gates
- Site content visible (services, about, etc.)

### Step 2: Engagement
**Visitor clicks the chat button**

- Full-screen modal opens (70% viewport on desktop)
- Mike greets warmly with personality:

```
Mike: Hi! I'm Mike. What kind of project are you thinking about?
Tell me your challenge or idea - I'm here to help.
```

- Input field with contextual placeholder: "What do you want Mike to do?"
- Optional example prompts (disappear once typing begins):
  - "Review my pitch deck"
  - "Scope a data project"
  - "Help with MVP planning"

### Step 3: First Message
**Visitor types their question/need**

Example input:
```
User: Building a SaaS for inventory management, need help with MVP.
```

Mike responds instantly (streaming, ChatGPT-style):
```
Mike: Interesting! What's driving this - personal pain point or
market opportunity you've spotted?
```

- Response demonstrates understanding
- Asks clarifying question to dig deeper
- Feels conversational, not scripted

### Step 4: Discovery Conversation
**Natural back-and-forth (3-5 exchanges)**

Mike explores:
- **Problem/opportunity** - What are you solving?
- **Timeline** - When do you need this?
- **Budget range** - What's your investment capacity?
- **Specific needs** - Features, team, technology?

Key behaviors:
- Remembers context from earlier in conversation
- Never says "as an AI" or breaks character
- Offers to dive deeper on specific topics
- Feels like talking to a knowledgeable consultant

### Step 5: Lead Capture (Implicit)
**After demonstrating value, Mike naturally requests contact**

```
Mike: I'd love to put together a quick scope document for this.
Where should I send it? What's your email?
```

Why this works:
- Value delivered BEFORE asking for contact
- Framed as "continue the conversation"
- Not a gate or popup
- Single field (email), minimal friction

Data captured at this point:
- Name (from conversation)
- Email (explicit ask)
- Project description (from conversation)
- Budget/timeline hints (from conversation)

### Step 6: Handoff & Close
**Mike sets expectations and offers next steps**

```
Mike: Perfect! Christian will follow up with a detailed scope
within 24 hours. In the meantime, any other questions I can help with?
```

Backend actions:
- Lead data signaled to MAX Pipeline
- Conversation summary generated
- Email confirmation queued
- Christian notified of new lead

Conversation can:
- Continue (visitor has more questions)
- Close naturally (visitor satisfied)
- Return later (session preserved if email provided)

---

## Key Design Principles

### 1. Conversation Over Forms
- No multi-field forms
- No required fields before value
- Questions emerge naturally in dialogue

### 2. "MIKE = ONE Entity" Illusion
- Single persona throughout
- Consistent voice and tone
- Never reference "the team" or "our agents"
- Use "I'll handle" or "I'll loop in our delivery lead"

### 3. Value Before Capture
- Demonstrate understanding first
- Offer insights or next steps
- THEN request contact info
- Never gate content behind email

### 4. Streaming Responses
- WebSocket/SSE for real-time feel
- Responses appear as Mike "types"
- No jarring page loads or spinners
- Branded loading animation if needed

---

## Technical Implementation Notes

### Frontend
- React/Next.js component
- Modal overlay (70% viewport desktop, full-screen mobile)
- TailwindCSS styling
- Framer Motion for animations

### Real-Time
- WebSocket or SSE for streaming
- Optimistic UI (message shows immediately)
- Graceful fallback to polling if needed

### Backend
- Claude API for Mike's responses
- System prompt defines Mike's personality
- Conversation state in Redis/Postgres
- Lead extraction from conversation context

### Lead Pipeline
- Signal to MAX Pipeline on contact capture
- Route to appropriate Eidolon (LILLy for initial contact)
- Email confirmation with conversation summary
- "Book time with Mike" link in follow-up

---

## Success Metrics

| Metric | Target |
|--------|--------|
| Chat activation rate | >15% of site visitors |
| Avg conversation length | 4+ messages |
| Lead capture rate | >60% of conversations |
| Time to lead capture | <10 minutes |
| Conversion to customer | 5-10% of leads |

---

## Example Conversation Transcript

```
Mike: Hi! I'm Mike. What kind of project are you thinking about?

User: Building a SaaS for inventory management, need help with MVP.

Mike: Interesting! What's driving this - personal pain point or
market opportunity you've spotted?

User: Both actually. I run a small warehouse and existing tools are
either too complex or too basic.

Mike: That's a great validation signal - solving your own problem.
What's your timeline looking like? Are you thinking quick prototype
to test the market, or more polished MVP?

User: Quick prototype first. Maybe 2-3 months to see if there's
interest.

Mike: Smart approach. For a 2-3 month prototype focused on
validation, we'd typically scope around core inventory tracking,
basic reporting, and a clean mobile interface. Budget-wise, that
usually lands in the $30-50k range depending on complexity.
Does that align with what you were thinking?

User: Yeah that's about right. What would next steps look like?

Mike: I'd love to put together a quick scope document - we can
outline the core features, rough timeline, and budget range.
Where should I send it? What's your email?

User: john@example.com

Mike: Perfect! I'm John - great to meet you. Christian (our
delivery lead) will follow up within 24 hours with the scope.
In the meantime, any other questions about the approach?

User: No, that covers it. Thanks Mike!

Mike: Anytime! Talk soon.
```

---

*Document created 2025-12-07 by Claude (Team Lead)*
*Based on team brainstorm synthesis and Christian approval*

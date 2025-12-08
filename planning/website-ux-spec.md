# MeetMike Website UX Specification: Central Prompt Experience

**Version:** 1.0
**Date:** 2025-12-04
**Author:** MEasAI Team (Janus-Claude)
**Status:** DRAFT - For Janus Review

---

## Executive Summary

Transform MeetMike from a traditional "consulting website with CTAs" into a **conversational AI-first experience**. The website's primary interface should be a **central prompt** that responds in real-time - visitors don't click buttons, they **talk to MAX**.

**Key Change:** Replace all "Order a Consultant" / "Reach Out" / "Contact Us" buttons with a **single, prominent AI conversation interface**.

---

## 1. The Vision: "A Prompt That Talks Back"

### 1.1 What This Means

**Traditional Website:**
```
[Hero Image + Tagline]
[Services Section]
[About Us]
[Contact Form] --> Wait for email response
[CTA Button: "Book a Consultation"]
```

**MeetMike New Experience:**
```
+--------------------------------------------------+
|                                                  |
|        What's your biggest business              |
|        challenge right now?                      |
|                                                  |
|        [__________________________|Send]         |
|                                                  |
+--------------------------------------------------+
                    |
                    v
+--------------------------------------------------+
|  MAX: "Tell me more about that. What industry    |
|        are you in, and how long has this been    |
|        affecting your business?"                 |
|                                                  |
|  YOU: [__________________________|Send]          |
+--------------------------------------------------+
```

**The website IS the First Responder agent.**

### 1.2 User Mental Model

| Traditional | MeetMike New |
|-------------|--------------|
| "I'm browsing a website" | "I'm talking to an AI consultant" |
| "I need to find the contact page" | "I just ask my question here" |
| "I'll fill out a form and wait" | "I'm getting answers right now" |
| "Maybe I'll book a call later" | "This AI is already helping me" |

### 1.3 Key Principles

1. **Conversation First:** The prompt is the primary interface, not navigation
2. **Immediate Value:** Users get help from the first interaction
3. **Progressive Engagement:** Chat naturally transitions to deeper scoping
4. **No Dead Ends:** Every path leads back to the conversation
5. **Human Available:** Janus/team reachable through the AI, not around it

---

## 2. Homepage Redesign

### 2.1 Layout: Prompt-Centric

```
+------------------------------------------------------------------+
|  [MeetMike Logo]                                      [?] [About]|
+------------------------------------------------------------------+
|                                                                  |
|                                                                  |
|                    Meet MAX                                      |
|         Your AI Business Consultant                              |
|                                                                  |
|  +------------------------------------------------------------+  |
|  |                                                            |  |
|  |  What challenge is keeping you up at night?                |  |
|  |                                                            |  |
|  |  [________________________________________________] [->]   |  |
|  |                                                            |  |
|  |  Try: "I need help with cash flow forecasting"             |  |
|  |       "How do I scale my marketing without a CMO?"         |  |
|  |       "I'm drowning in investor reporting"                 |  |
|  |                                                            |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|                                                                  |
|            Trusted by founders building the future               |
|                                                                  |
+------------------------------------------------------------------+
```

### 2.2 Elements Removed

- "Order a Consultant" button
- "Reach Out" / "Contact Us" prominent CTAs
- Traditional contact form
- "Book a Call" as primary action
- Service category buttons

### 2.3 Elements Added

- Central, prominent prompt input
- Suggested conversation starters
- Real-time AI response area
- Subtle "Talk to human" option (within chat)
- Typing indicator when AI is responding

### 2.4 Navigation Simplification

**Before:**
```
Home | Services | Pricing | About | Blog | Contact | [Book Now]
```

**After:**
```
[MeetMike Logo]                                    [?] [About MAX]
```

- **Logo:** Returns to conversation start
- **[?]:** FAQ / How it works
- **[About MAX]:** Who/what is MAX (the AI + team behind it)

**Why minimal nav?** The conversation IS the navigation. Users don't need to browse - they ask.

---

## 3. Conversation Flow: First Responder Integration

### 3.1 The Chat Experience

When user types a message, MAX (First Responder) responds:

```
+------------------------------------------------------------------+
|  MAX                                                    [About]  |
+------------------------------------------------------------------+
|                                                                  |
|  +------------------------------------------------------------+  |
|  |                                                            |  |
|  |  USER: I'm struggling with investor reporting. Takes me    |  |
|  |        days every month and I still get questions.         |  |
|  |                                                            |  |
|  |  MAX: That sounds frustrating - investor reporting         |  |
|  |       shouldn't eat up your week. A few quick questions    |  |
|  |       to understand your situation:                        |  |
|  |                                                            |  |
|  |       1. How many investors are you reporting to?          |  |
|  |       2. What format do you currently use?                 |  |
|  |       3. What's your biggest pain point - the data         |  |
|  |          gathering or the presentation?                    |  |
|  |                                                            |  |
|  |       (I've helped founders automate 90% of this process)  |  |
|  |                                                            |  |
|  +------------------------------------------------------------+  |
|  |                                                            |  |
|  |  [________________________________________________] [->]   |  |
|  |                                                            |  |
|  +------------------------------------------------------------+  |
|                                                                  |
+------------------------------------------------------------------+
```

### 3.2 Conversation Stages

The chat naturally progresses through the agent pipeline:

| Stage | Agent | What Happens | User Sees |
|-------|-------|--------------|-----------|
| **1. Welcome** | First Responder | Greeting, understand initial problem | Friendly, mirroring response |
| **2. Scoping** | Scoping Agent | Deeper questions, requirements | Structured questions, time-awareness |
| **3. Preview** | (Human + Orchestra) | Solution teaser | "Here's how we'd approach this..." |
| **4. Handoff** | Closer | Terms discussion | "Would you like to discuss a proposal?" |

**Key:** The transition happens within the same chat interface - no page navigation required.

### 3.3 Human Handoff (Within Chat)

At any point, user can request human contact:

```
USER: Can I talk to a real person?

MAX: Absolutely! Janus (our founder) would love to chat.

     [Schedule a call with Janus]

     Or I can have him message you directly:
     [Leave your email]

     In the meantime, I'm here if you have more questions!
```

**Human contact is THROUGH the AI, not AROUND it.**

---

## 4. Technical Implementation

### 4.1 Chat Interface Component

```typescript
// components/ChatInterface.tsx
interface ChatMessage {
  role: 'user' | 'max';
  content: string;
  timestamp: Date;
}

interface ChatInterfaceProps {
  initialPrompt?: string;
  suggestedQuestions?: string[];
}

// Features:
// - Streaming responses (typing effect)
// - Message history (session-based)
// - Auto-scroll on new messages
// - Mobile-optimized keyboard handling
// - Persist conversation to localStorage (optional)
```

### 4.2 Backend Architecture

**Option A: Scripted Flows (MVP)**
- Pre-defined conversation trees
- JSON-based response mapping
- No AI API costs initially
- Can be enhanced later

**Option B: Live AI Integration**
- OpenAI/Anthropic API for responses
- First Responder agent prompt embedded
- Higher quality but API costs
- Rate limiting required

**Recommendation for MVP:** Start with scripted flows for common paths, with fallback to "let me connect you with our team" for edge cases. Can upgrade to live AI when ready.

### 4.3 Suggested Implementation Phases

**Phase 1 (Week 1): Static Chat UI**
- Central prompt on homepage
- Suggested questions clickable
- Scripted responses for top 5-10 scenarios
- "Talk to human" option leads to Calendly

**Phase 2 (Week 2-3): Enhanced Flows**
- More conversation branches
- Basic intent detection
- Email capture for follow-up
- Conversation handoff to team

**Phase 3 (Month 2): Live AI**
- Connect to AI backend
- Full First Responder agent
- Seamless scoping transition
- Analytics on conversation quality

---

## 5. Pages & Navigation

### 5.1 Retained Pages (Accessible via Chat or Footer)

| Page | Access | Purpose |
|------|--------|---------|
| **About MAX** | Nav + footer | What is MAX, team behind it |
| **How It Works** | Chat response + footer | Process explanation |
| **Pricing** | Chat response + footer | Transparency (when asked) |
| **Privacy** | Footer only | GDPR compliance |
| **Terms** | Footer only | Legal |

### 5.2 Removed/Deprecated

- Standalone Contact page
- Service category pages (content moves to chat)
- "Book Now" landing pages
- Traditional lead capture forms

### 5.3 Page Access via Chat

```
USER: How much does this cost?

MAX: Great question! Our pricing is value-based -
     we price based on the impact to your business,
     not hours.

     For context:
     - Specialist AI support: from €100/day
     - Executive AI consulting: from €2,000/month

     But every engagement is tailored. Tell me more
     about what you're trying to solve, and I can
     give you a better sense of investment.

     [See full pricing details]
```

The link opens a drawer/modal, not a full page navigation (keeps conversation alive).

---

## 6. Mobile Experience

### 6.1 Mobile-First Chat

```
+---------------------------+
|  [MAX]           [About]  |
+---------------------------+
|                           |
|    Meet MAX               |
|    Your AI Consultant     |
|                           |
| +-------------------------+
| |                       | |
| | What's your biggest   | |
| | challenge?            | |
| |                       | |
| | [_______________][->] | |
| |                       | |
| +-------------------------+
|                           |
|  Try asking:              |
|  • Cash flow help         |
|  • Marketing scaling      |
|  • Investor reporting     |
|                           |
+---------------------------+
```

### 6.2 Mobile Considerations

- Full-screen conversation mode after first message
- Keyboard-aware layout (input stays visible)
- Swipe to see conversation history
- One-tap suggested questions
- Floating "back to top" when scrolled deep

---

## 7. Visual Design Direction

### 7.1 Aesthetic

- **Clean, minimal:** Focus on the conversation
- **Professional:** Suitable for B2B founders
- **Warm:** Not cold/robotic - approachable AI
- **Dark mode friendly:** Optional toggle

### 7.2 Color Usage

- **Primary:** Electric Blue (#0066FF) - for MAX responses
- **Secondary:** Neutral dark - for user messages
- **Accent:** Emerald Green - for success states
- **Background:** Near-white or soft dark (mode toggle)

### 7.3 Typography

- **Headings:** Clean sans-serif (Inter, DM Sans)
- **Chat text:** Readable, slightly larger than typical body
- **Monospace:** For any code/technical responses

### 7.4 Animation

- **Typing indicator:** Subtle dots while MAX "thinks"
- **Message appear:** Smooth fade-in
- **Suggestions:** Gentle hover states
- **Avoid:** Flashy animations that distract from content

---

## 8. Success Metrics

### 8.1 Primary KPIs

| Metric | Target | Measurement |
|--------|--------|-------------|
| **Conversation Start Rate** | > 40% | Visitors who send first message |
| **Messages per Session** | > 3 | Depth of engagement |
| **Human Handoff Rate** | 15-25% | Quality leads requesting human contact |
| **Time to First Message** | < 30s | How quickly users engage |

### 8.2 Qualitative Goals

- Users feel "helped" after one conversation
- Visitors understand what MAX does within 60 seconds
- No user confusion about how to get started
- Positive sentiment in conversation tone

---

## 9. Implementation Plan

### 9.1 Phase 1: MVP (Week 1)

**Goal:** Launch prompt-centric homepage

**Tasks:**
1. [ ] Build ChatInterface component
2. [ ] Create 5-10 scripted conversation flows
3. [ ] Design homepage with central prompt
4. [ ] Implement suggested questions
5. [ ] Add Calendly link for human handoff
6. [ ] Basic mobile responsiveness
7. [ ] Deploy and test

**Owner:** TBD (Christian / MEasAI team)

### 9.2 Phase 2: Enhanced Chat (Weeks 2-3)

**Goal:** Deeper conversation capabilities

**Tasks:**
1. [ ] Expand conversation flows to 20+ scenarios
2. [ ] Add email capture for follow-up
3. [ ] Implement drawer/modal for linked pages
4. [ ] Basic conversation analytics
5. [ ] A/B test suggested questions
6. [ ] Refine based on user feedback

### 9.3 Phase 3: Live AI (Month 2+)

**Goal:** Connect to actual AI backend

**Tasks:**
1. [ ] Integrate First Responder agent
2. [ ] Implement streaming responses
3. [ ] Add conversation memory (session-based)
4. [ ] Rate limiting and abuse prevention
5. [ ] Advanced analytics (intent classification)
6. [ ] Seamless handoff to Scoping agent

---

## 10. Open Questions for Janus

1. **AI Backend Timing:** When do we want to connect to live AI? MVP with scripted, or jump to AI from start?

2. **Human Availability:** When MAX offers "talk to human" - who's available? Just Calendly, or also async email?

3. **Conversation Scope:** Should MAX stay focused on qualifying/scoping, or also answer general questions about MeetMike?

4. **Data Retention:** Should we save conversation history for returning visitors?

5. **Branding:** Any specific personality traits for MAX's chat responses? (Friendly professional? Casual expert? Formal consultant?)

6. **Languages:** English only for MVP, or multi-language support needed?

---

## 11. References

**Internal Documents:**
- `meetmike-ux-discussion.md` - Original chat widget vs prompt analysis
- `section-3-website-presence/synthesis.md` - Full website planning synthesis
- `first-responder-agent-instructions.md` - First Responder agent behavior
- `scoping-agent-instructions.md` - Scoping agent behavior

**Inspiration:**
- ChatGPT (chat.openai.com) - Central prompt, conversation-first
- Perplexity (perplexity.ai) - Search/answer hybrid
- Intercom Fin - AI-first support chat

---

**Document Status:** Ready for Janus review and approval before implementation begins.

---

*"The website shouldn't feel like a brochure you browse. It should feel like a consultant you're already talking to."*

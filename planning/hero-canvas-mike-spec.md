# Hero Canvas Mike - Approved Design Specification

**Date:** 2025-12-07
**Status:** APPROVED by Christian
**Version:** 1.0

---

## Overview

A hybrid approach that combines the radical "Mike is the experience" concept with the existing professional website structure. Mike dominates the first impression without losing valuable content.

---

## Design Concept

```
┌─────────────────────────────────────────────────────────────┐
│  [Nav bar - optional, could be hidden initially]            │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│                                                               │
│           Hi. I'm Mike.                                      │
│           [typewriter effect...]                             │
│                                                               │
│           I help teams build ambitious projects.             │
│           What's yours?                                       │
│                                                               │
│           [________________________]                         │
│                                                               │
│                    HERO CANVAS                               │
│                    (60-70vh)                                 │
│                                                               │
├─────────────────────────────────────────────────────────────┤
│  ▼ Peek of content below (visible ~30vh)                    │
│  [Existing site content: services, about, testimonials...]  │
└─────────────────────────────────────────────────────────────┘
```

---

## Key Features

### 1. Hero Canvas (Above the Fold)
- **Height:** 60-70% of viewport (60-70vh)
- **Width:** Full width OR 3/4 width (A/B test)
- **Content:** Mike's typewriter intro + single input field
- **Background:** Clean, minimal (white or subtle gradient)
- **No clutter:** No buttons, no nav (or minimal nav), no distractions

### 2. Typewriter Introduction
- Mike's greeting types itself letter-by-letter on page load
- Creates sense of Mike being "present" and "alive"
- Example sequence:
  ```
  Hi. I'm Mike.
  [pause]
  I help teams build ambitious projects.
  [pause]
  What's yours?
  [input field appears with cursor]
  ```
- Speed: ~50-80ms per character (feels natural, not robotic)

### 3. Content Peek
- Below hero canvas, ~30vh of existing content visible
- Users immediately see there's more to explore
- Creates visual cue: "scroll for more"
- Maintains professional site feel

### 4. Scroll Behavior (Context-Aware Mike)
When user scrolls past the hero canvas:

**Option A: Sticky Mini-Chat**
- Hero canvas scrolls away
- Mike shrinks to floating mini-chat (bottom-right corner)
- Conversation continues in mini format

**Option B: Sticky Header Bar**
- Mike becomes slim bar at top
- Input field compressed but accessible
- Expands on click/focus

**Context-Aware Message:**
When user scrolls, Mike acknowledges:
```
"I see you prefer to browse around on my little web page.
Please take your time, and let me know if there's anything
I can assist you with or help clarify."
```

This creates personality - Mike "notices" user behavior without being pushy.

---

## User Flow

### Path 1: Immediate Engagement
1. User lands on meetmike.pro
2. Sees hero canvas with Mike typing intro
3. Types response to Mike's question
4. Conversation begins in hero canvas
5. If long conversation, canvas expands or scrolls internally

### Path 2: Browser First
1. User lands on meetmike.pro
2. Sees hero canvas but scrolls to browse
3. Mike shrinks to mini-chat, says "Take your time..."
4. User browses existing site content
5. When ready, clicks mini-chat to engage Mike
6. Conversation continues

---

## Technical Implementation

### Frontend
- **Framework:** React/Next.js (existing stack)
- **Styling:** TailwindCSS
- **Animations:** Framer Motion (typewriter, transitions)
- **Scroll Detection:** Intersection Observer API

### Key Components
```
<HeroCanvas>           // 60-70vh container
  <TypewriterIntro />  // Mike's animated greeting
  <ChatInput />        // Single input field
  <ChatMessages />     // Conversation area
</HeroCanvas>

<StickyMiniChat />     // Appears on scroll
  <MinimizedInput />
  <ContextMessage />   // "Take your time..."

<ExistingContent />    // Current site sections
```

### Scroll Logic (Pseudocode)
```javascript
// When hero canvas scrolls out of view
if (heroCanvasIntersection < 0.3) {
  showMiniChat()
  if (!userHasEngaged) {
    mikeSays("I see you prefer to browse...")
  }
}

// When user scrolls back to top
if (heroCanvasIntersection > 0.7) {
  hideMiniChat()
  restoreHeroCanvas()
}
```

---

## Design Principles

1. **Mike First:** Hero canvas dominates above-the-fold
2. **No Content Lost:** Existing site preserved below
3. **Context-Aware:** Mike responds to user behavior
4. **Non-Pushy:** Acknowledges browsing, doesn't interrupt
5. **Flexible:** Works for both "engage now" and "browse first" users

---

## Mobile Considerations

- Hero canvas: 70-80vh on mobile (more vertical space)
- Typewriter: Faster animation (mobile users expect speed)
- Mini-chat: Bottom sheet style (Material Design pattern)
- Input: Large touch targets, keyboard-aware positioning

---

## A/B Testing Opportunities

1. **Hero height:** 60vh vs 70vh vs 80vh
2. **Typewriter speed:** Fast vs slow
3. **Mini-chat position:** Bottom-right vs bottom-center
4. **Context message timing:** Immediate vs after 3s scroll
5. **Nav visibility:** Hidden initially vs always visible

---

## Success Metrics

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Hero engagement rate | >25% | Users who type in hero |
| Scroll-then-engage rate | >15% | Users who browse then chat |
| Bounce rate reduction | -20% | Compared to current |
| Time on page | +30% | Engaged users stay longer |

---

## Implementation Phases

### Phase 1: MVP
- Hero canvas with typewriter intro
- Basic chat functionality
- Simple scroll detection (show/hide mini-chat)
- Context-aware message on scroll

### Phase 2: Polish
- Smooth animations and transitions
- Mobile optimization
- A/B testing framework
- Analytics integration

### Phase 3: Intelligence
- Personalized greetings (referrer-based)
- Smart context messages (time of day, return visitor)
- Conversation history persistence

---

## Related Documents

- `central-prompt-ui-synthesis.md` - Initial brainstorm synthesis
- `radical-ui-synthesis.md` - Radical approach synthesis
- `user-story-first-visit.md` - User journey documentation

---

## Approval

- **Proposed by:** MEasAI Team (Claude, Codex, Gemini, Copilot)
- **Approved by:** Christian Hollbaum
- **Date:** 2025-12-07

---

*This specification represents the approved direction for Meet Mike's homepage redesign.*

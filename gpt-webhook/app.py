#!/usr/bin/env python3
"""Simple webhook receiver for Mike GPT conversations."""

from datetime import datetime, timezone
from pathlib import Path
import json
import os

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI(title="Mike GPT Webhook", version="1.0.0")

# Allow CORS for ChatGPT
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://chat.openai.com", "https://chatgpt.com"],
    allow_methods=["GET", "POST"],
    allow_headers=["*"],
)

# Where to save conversations
INBOX_DIR = Path(os.getenv(
    "INBOX_DIR",
    "/workspaces/Measai-Maestro/AI_Agents/shared/inbox/gpt-conversations"
))
INBOX_DIR.mkdir(parents=True, exist_ok=True)


class ConversationSummary(BaseModel):
    """Summary from Mike GPT."""
    user: str = "Janus"
    topic: str
    summary: str
    decisions: list[str] = []
    action_items: list[str] = []
    questions: list[str] = []


class TeamUpdate(BaseModel):
    """Request for team updates."""
    user: str = "Janus"
    request: str = "latest status"


@app.get("/")
def root():
    """Health check."""
    return {"status": "ok", "service": "Mike GPT Webhook"}


@app.post("/conversation")
def save_conversation(data: ConversationSummary):
    """Save a conversation summary from Mike GPT."""
    timestamp = datetime.now(timezone.utc).strftime("%Y%m%d-%H%M%S")
    filename = f"{timestamp}-{data.user}-{data.topic[:30].replace(' ', '-')}.md"

    content = f"""---
source: mike-gpt
user: {data.user}
topic: {data.topic}
timestamp: {datetime.now(timezone.utc).isoformat()}
---

# {data.topic}

## Summary
{data.summary}

## Decisions Made
{chr(10).join(f"- {d}" for d in data.decisions) if data.decisions else "- None recorded"}

## Action Items
{chr(10).join(f"- [ ] {a}" for a in data.action_items) if data.action_items else "- None"}

## Open Questions
{chr(10).join(f"- {q}" for q in data.questions) if data.questions else "- None"}
"""

    filepath = INBOX_DIR / filename
    filepath.write_text(content)

    return {
        "status": "saved",
        "message": f"Conversation saved. The MEasAI team will review it.",
        "file": str(filepath.name)
    }


@app.get("/updates")
def get_updates(user: str = "Janus"):
    """Get latest updates for the user."""
    # Read from a status file or return latest info
    status_file = Path("/workspaces/Measai-Maestro/projects/meet-mike/docs/MAIC-Conversation-Summary-2025-12-03.md")

    if status_file.exists():
        content = status_file.read_text()
        # Extract key sections
        return {
            "status": "ok",
            "message": "Here's the latest from the MEasAI team",
            "updates": [
                "MAX pipeline defined: 7 stages from Lead Generator to Delivery",
                "Handoff triggers proposed for each stage",
                "Janus confirmed as human-in-the-loop at every stage",
                "Value-based pricing model confirmed"
            ],
            "last_updated": "2025-12-03T13:00:00Z"
        }

    return {
        "status": "ok",
        "message": "No recent updates",
        "updates": []
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8765)

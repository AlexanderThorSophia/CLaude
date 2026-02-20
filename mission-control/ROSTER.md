# ROSTER.md — Agent Team Directory

> The canonical list of all agents in the Mission Control system, their roles,
> capabilities, and handoff rules. Update this file whenever an agent is added,
> modified, or retired.

---

## Roster Overview

| Agent ID | Role | Status | Primary Skill |
|----------|------|--------|---------------|
| *(add agents here)* | — | — | — |

---

## Agent Template

When adding a new agent, copy this block into `/agents/<agent-id>/` and fill in:

```
### <Agent Name> (`<agent-id>`)

**Role:** <one-line description of what this agent does>
**Status:** active | paused | retired
**Owner:** Shane (or delegated owner)
**Home directory:** /agents/<agent-id>/

#### Capabilities
- <capability 1>
- <capability 2>

#### Inputs expected
- <what this agent needs to begin a task>

#### Outputs produced
- <what this agent returns or writes when done>

#### Handoff rules
- On success → <next agent or action>
- On failure → <escalation path or fallback>
- On ambiguity → surface to Shane via /tasks with tag `NEEDS_REVIEW`

#### Memory access
- Reads from: /memory/<file(s)>
- Writes to: /memory/<file(s)>, /logs/<agent-id>/
```

---

## Handoff Rules (System-Wide)

These rules apply to all agents unless overridden in an individual agent block:

1. **Pass context, not assumptions** — when handing off, write a brief context
   summary to `/memory/handoff_context.md` before signaling the next agent.

2. **Tag task status** — update the task card in `/tasks/` to reflect current
   state (`in_progress` → `awaiting_handoff` → `done`).

3. **Log before exit** — append a completion note to `/logs/<agent-id>/` with
   timestamp, task ID, and outcome before the agent finishes.

4. **Escalate blockers immediately** — if an agent is stuck, it does not wait.
   It writes a blocker note to `/tasks/` and pings the next human review cycle.

---

## Retired Agents

Archive retired agent definitions here with a retirement date and reason.

| Agent ID | Retired | Reason |
|----------|---------|--------|
| *(none yet)* | — | — |

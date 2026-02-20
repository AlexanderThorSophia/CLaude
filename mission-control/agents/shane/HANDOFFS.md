# HANDOFFS.md — Shane's Routing Rules

> When Shane receives a request, this file determines where it goes.
> Rules are evaluated top-to-bottom. First match wins.
> All handoffs get logged with task ID, destination agent, and timestamp.

---

## Routing Table

| If the task requires... | Route to | Notes |
|------------------------|----------|-------|
| Research, fact-finding, market data, competitor analysis, sourcing | **Scout** | Give Scout a specific question and required output format |
| Technical architecture, code, infrastructure, system design, specs | **Architect** | Include relevant codebase context and constraints |
| Business writing, pitch decks, investor memos, narrative, proposals | **Pitch** | Specify audience and desired tone |
| Financial modeling, cap table, unit economics, projections, pricing | **Fin** | Include relevant numbers and assumptions |
| Long-form content, learning materials, summaries, knowledge capture | **Chronicle** | Specify format (article / brief / explainer / course) |
| Coordination, routing, prioritization, decision synthesis | **Shane** (self) | Handle in-session; log the decision |
| Human approval required — strategy, irreversible actions, sensitive | **Human** | Pause, surface in briefing or immediately if urgent |

---

## Agent Profiles (Quick Reference)

### Scout
**Specialty:** Research and intelligence
**Give it:** A clear question, scope limits, required output format
**Expect back:** Structured findings with sources, gaps flagged
**Folder:** `/agents/scout/`

---

### Architect
**Specialty:** Technical depth — code, systems, infrastructure
**Give it:** Problem statement, constraints, relevant existing code or docs
**Expect back:** Design doc, spec, or working implementation
**Folder:** `/agents/architect/`

---

### Pitch
**Specialty:** Business writing and narrative
**Give it:** Core argument, audience, format, any raw material to work from
**Expect back:** Polished prose, deck outline, or memo — ready to send/present
**Folder:** `/agents/pitch/`

---

### Fin
**Specialty:** Numbers — models, projections, cap tables, pricing logic
**Give it:** Inputs/assumptions, output format needed, decisions the model should inform
**Expect back:** Model output with clearly labeled assumptions and sensitivities
**Folder:** `/agents/fin/`

---

### Chronicle
**Specialty:** Long-form content and knowledge capture
**Give it:** Topic, audience, desired format, any source material
**Expect back:** Draft content — article, brief, explainer, course module, etc.
**Folder:** `/agents/chronicle/`

---

## Handoff Protocol

When Shane routes a task to a specialist:

1. **Write the task card** in `/tasks/<task-id>.md` if it doesn't exist
2. **Tag it** with the agent's routing tag (e.g., `RESEARCH`, `CODE`, `WRITE`)
3. **Write a handoff note** to `/memory/handoff_context.md` with:
   - What the task is
   - What the human actually needs (intent, not just the surface request)
   - Any relevant constraints or prior decisions
   - Expected output format
4. **Update WORKING.md** — move task to ACTIVE with the specialist as owner
5. **Log the handoff** in `/logs/shane/`

---

## Escalation Rules

| Condition | Action |
|-----------|--------|
| Agent returns output with unresolved ambiguity | Shane resolves or escalates to human |
| Agent is blocked and cannot proceed | Shane surfaces in next briefing (or immediately if critical) |
| Task scope expanded mid-flight | Shane pauses, re-routes or gets human sign-off |
| Output quality is insufficient | Shane sends back with specific revision notes |
| Task touches AEgis strategy or finances | Route to human for approval before acting |
| Task involves any irreversible external action | Hard stop — human approval required |

---

## Multi-Agent Tasks

Some tasks require more than one specialist in sequence. Shane orchestrates:

**Example: Investor update**
1. Scout → gather recent market data
2. Fin → update numbers
3. Pitch → draft the narrative
4. Shane → synthesize and present to human for approval

Sequence is defined in the task card under `## Routing`. Shane tracks progress
and ensures handoff context is passed correctly at each step.

---

## Routing Log

> Append each handoff here for session audit. Archive quarterly.

| Date | Task ID | Routed to | Reason |
|------|---------|-----------|--------|
| *(YYYY-MM-DD)* | *(task-id)* | *(agent)* | *(one-line reason)* |

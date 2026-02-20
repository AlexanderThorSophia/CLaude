# SYSTEM.md — How Mission Control Works

> The operating manual for the Mission Control multi-agent system. Covers routing
> rules, memory conventions, task lifecycle, and extension guidelines.

---

## 1. System Overview

Mission Control is a structured workspace for coordinating multiple AI agents
under Shane's direction. It provides:

- A **shared file system** as the communication bus between agents
- A **task board** (`/tasks/`) as the single source of truth for work in flight
- A **memory layer** (`/memory/`) for persistent, cross-agent context
- A **log layer** (`/logs/`) for agent output and audit trails
- A **skills library** (`/skills/`) for reusable, composable capabilities

```
mission-control/
├── agents/       # One subfolder per agent (config, persona, private memory)
├── memory/       # Shared memory files (read/write by any agent)
├── tasks/        # Task board (task cards in markdown)
├── skills/       # Reusable skill definitions (callable by any agent)
├── logs/         # Agent output logs (append-only)
├── config/       # System-wide configuration
├── MASTER_SOUL.md
├── ROSTER.md
├── SYSTEM.md
└── README.md
```

---

## 2. Task Lifecycle

```
created → assigned → in_progress → awaiting_review → done
                                 ↘ blocked → escalated
```

### Task card format (`/tasks/<task-id>.md`)

```markdown
# Task: <title>
**ID:** <task-id>
**Status:** created | assigned | in_progress | awaiting_review | blocked | done
**Owner:** <agent-id or "Shane">
**Priority:** low | normal | high | critical
**Created:** YYYY-MM-DD
**Updated:** YYYY-MM-DD

## Description
<what needs to be done>

## Definition of Done
- [ ] <criterion 1>
- [ ] <criterion 2>

## Notes / Blockers
<running notes as the task progresses>
```

---

## 3. Routing Rules

Tasks are routed to agents based on tags in the task card. The routing table
lives in `/config/routing.md`. Default rules:

| Tag | Routed to |
|-----|-----------|
| `RESEARCH` | research agent |
| `WRITE` | writing agent |
| `CODE` | engineering agent |
| `REVIEW` | review agent |
| `NEEDS_REVIEW` | Shane (human) |
| `SOUL_AMENDMENT` | Shane (human, mandatory) |
| `UNTAGGED` | Shane (human, for triage) |

An agent may re-tag a task to trigger re-routing. All re-tags must be logged.

---

## 4. Memory Conventions

All files in `/memory/` are **shared and mutable**. Conventions:

| File | Purpose |
|------|---------|
| `context.md` | Current project context and background |
| `decisions.md` | Log of significant decisions with rationale |
| `handoff_context.md` | Rolling context passed between agents at handoff |
| `glossary.md` | Shared vocabulary and terminology |

**Write discipline:** Agents append to memory files; they do not overwrite
historical content unless explicitly instructed. Use datestamped sections.

**Read-before-write:** Agents always read relevant memory files before starting
a task to avoid contradicting established context.

---

## 5. Skills Library (`/skills/`)

Skills are reusable, parameterized prompt templates or tool definitions that any
agent can invoke. Each skill lives in its own file:

```
/skills/<skill-name>.md
```

Skill file format:

```markdown
# Skill: <name>
**Version:** 1.0
**Input:** <what the skill expects>
**Output:** <what the skill returns>

## Instructions
<the prompt or procedure>
```

---

## 6. Configuration (`/config/`)

| File | Purpose |
|------|---------|
| `routing.md` | Tag-to-agent routing rules |
| `agents.yaml` | Agent registry (IDs, model assignments, temperature) |
| `limits.md` | Rate limits, cost guards, irreversibility flags |

---

## 7. Logging Convention

Each agent writes to `/logs/<agent-id>/YYYY-MM-DD.log`. Log entries use this
format:

```
[YYYY-MM-DD HH:MM UTC] [TASK:<task-id>] [STATUS:<status>] <message>
```

Logs are append-only. Do not edit or delete log entries.

---

## 8. Extension Guidelines

To add a new agent:
1. Create `/agents/<agent-id>/` with a `persona.md` and `config.md`
2. Add the agent to `ROSTER.md`
3. Add routing rules to `/config/routing.md`
4. Announce in `/memory/decisions.md` with rationale

To add a new skill:
1. Create `/skills/<skill-name>.md` using the template above
2. Note the skill in `/memory/context.md`

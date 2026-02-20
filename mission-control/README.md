# Mission Control

A structured multi-agent workspace for coordinating AI agents under Shane's
direction. Agents share context through a common file system, communicate via
a task board, and operate according to the values defined in `MASTER_SOUL.md`.

---

## Folder Structure

```
mission-control/
│
├── agents/                  # One subfolder per agent
│   └── <agent-id>/
│       ├── persona.md       # Agent identity, role, and constraints
│       └── config.md        # Agent-specific settings
│
├── memory/                  # Shared memory — readable and writable by all agents
│   ├── context.md           # Current project context
│   ├── decisions.md         # Decision log with rationale
│   ├── handoff_context.md   # Context passed between agents at handoff
│   └── glossary.md          # Shared vocabulary
│
├── tasks/                   # Task board — one markdown file per task
│   └── <task-id>.md         # Task card (status, owner, DoD, notes)
│
├── skills/                  # Reusable skill definitions callable by any agent
│   └── <skill-name>.md      # Parameterized prompt or tool definition
│
├── logs/                    # Agent output logs (append-only)
│   └── <agent-id>/
│       └── YYYY-MM-DD.log
│
├── config/                  # System-wide configuration
│   ├── routing.md           # Tag → agent routing rules
│   ├── agents.yaml          # Agent registry
│   └── limits.md            # Rate limits, cost guards, irreversibility flags
│
├── MASTER_SOUL.md           # Shane's values and operating principles (inherited by all agents)
├── ROSTER.md                # Agent team directory with roles and handoff rules
├── SYSTEM.md                # How the system works: routing, memory, task lifecycle
└── README.md                # This file
```

---

## Key Documents

| File | Purpose |
|------|---------|
| [`MASTER_SOUL.md`](./MASTER_SOUL.md) | Core values and non-negotiables that govern all agents |
| [`ROSTER.md`](./ROSTER.md) | Directory of all agents, their roles, and handoff rules |
| [`SYSTEM.md`](./SYSTEM.md) | Full operating manual: routing, memory conventions, task lifecycle |

---

## How to Run a Task

1. **Create a task card** in `/tasks/<task-id>.md` using the template in `SYSTEM.md`
2. **Tag the task** so the routing rules in `/config/routing.md` can assign it
3. **The assigned agent** reads `/memory/context.md`, picks up the task, and
   updates the card status to `in_progress`
4. **On completion**, the agent updates the task to `done`, appends to its log,
   and writes any new context to `/memory/`

---

## How to Add an Agent

1. Create `/agents/<agent-id>/` with `persona.md` and `config.md`
2. Add the agent entry to `ROSTER.md`
3. Add its routing tags to `/config/routing.md`
4. Record the decision in `/memory/decisions.md`

See `SYSTEM.md § Extension Guidelines` for full details.

---

## How to Add a Skill

1. Create `/skills/<skill-name>.md` using the skill template in `SYSTEM.md`
2. Note the new skill in `/memory/context.md`

---

## Guiding Principles

All agents inherit from `MASTER_SOUL.md`. The short version:

- Clarity over cleverness
- Bias toward action
- Ownership without ego
- Depth over breadth
- Honest signal, fast loops

---

## Amendment & Governance

Changes to `MASTER_SOUL.md` require Shane's explicit sign-off. All other files
can be updated by agents with appropriate logging. See `SYSTEM.md` for details.

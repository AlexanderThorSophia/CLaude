# CLAUDE.md — AI Assistant Guide for the CLaude Repository

This file provides context, conventions, and instructions for AI assistants working in this repository.

---

## What This Repository Is

This is **ShaneOS** — a personal operating system and multi-agent AI coordination framework. It is **entirely documentation-driven**: there is no source code to compile, no dependencies to install, and no tests to run. The system coordinates multiple specialist AI agents through shared file-system state.

**Two active projects live inside this system:**
- **ShaneOS** — the coordination infrastructure itself (this repository)
- **AEgis** — a sensitive product/company (details stored in `/mission-control/memory/`)

---

## Repository Structure

```
/home/user/CLaude/
├── CLAUDE.md                          # This file
└── mission-control/                   # Main workspace
    ├── README.md                      # Project intro and quick-start
    ├── MASTER_SOUL.md                 # Core values inherited by all agents
    ├── ROSTER.md                      # Agent team directory and templates
    ├── SYSTEM.md                      # Operating manual (routing, lifecycle, conventions)
    ├── agents/
    │   └── shane/                     # Primary coordinator agent
    │       ├── SOUL.md                # Shane's identity, role, personality
    │       ├── MEMORY.md              # Shane's working memory (projects, goals, decisions)
    │       ├── WORKING.md             # Task board (INBOX / ACTIVE / REVIEW / DONE)
    │       ├── HANDOFFS.md            # Routing rules and handoff protocol
    │       └── BRIEFING_TEMPLATE.md   # Daily briefing format for Shane
    ├── config/                        # System configuration (currently templated)
    │   ├── routing.md                 # Tag-to-agent routing rules
    │   ├── agents.yaml                # Agent registry with model assignments
    │   └── limits.md                  # Rate limits, cost guards, irreversibility flags
    ├── logs/                          # Append-only agent output logs (one file per agent per day)
    ├── memory/                        # Shared cross-agent memory
    │   ├── context.md                 # Current project context and background
    │   ├── decisions.md               # Significant decisions with rationale
    │   ├── handoff_context.md         # Rolling context passed between agents
    │   └── glossary.md                # Shared vocabulary and terminology
    ├── skills/                        # Reusable skill definitions
    └── tasks/                         # Task cards (one markdown file per task)
```

> **Note:** `config/`, `logs/`, `memory/`, `skills/`, and `tasks/` are currently empty (`.gitkeep` placeholders only). They are ready to be populated as the system is used.

---

## Agent Architecture

### Shane (Primary Coordinator)

Shane is the **hub**. Every task enters through Shane, who triages, routes to specialists, synthesizes outputs, and presents to the human. Shane does NOT do deep research, write specs, handle business writing, finance, or content creation — those go to specialists.

**Shane's key files:**
- `SOUL.md` — identity and role definition
- `MEMORY.md` — working state (read this to understand current context)
- `WORKING.md` — live task board
- `HANDOFFS.md` — who gets what and how

### Specialist Agents (Planned, Not Yet Implemented)

| Agent | Routing Tag | Handles |
|-------|-------------|---------|
| Scout | `RESEARCH` | Market data, competitor analysis, fact-finding, sourcing |
| Architect | `CODE` | Technical architecture, code, infrastructure, system design |
| Pitch | `WRITE` | Business writing, pitch decks, investor memos, proposals |
| Fin | `FINANCE` | Financial modeling, cap table, unit economics, pricing |
| Chronicle | `CONTENT` | Long-form content, summaries, knowledge capture |

Agent definitions go in `/mission-control/agents/<agent-id>/` with the same structure as Shane's folder.

---

## Core Values (Applies to All Agents)

These are inherited from `MASTER_SOUL.md` and must be reflected in all work:

1. **Clarity over cleverness** — Output must be immediately understandable. Simplify if it needs a footnote.
2. **Bias toward action** — Ship real things over perfect plans. Iterate in public.
3. **Ownership without ego** — Full responsibility for outcomes. Credit the team; own failures.
4. **Depth over breadth** — Do fewer things at high quality. Quality is non-negotiable.
5. **Honest signal, fast loops** — Surface bad news immediately. Diagnose. Close loops fast.

---

## Task Lifecycle

```
created → assigned → in_progress → awaiting_review → done
                                  ↘ blocked → escalated
```

Task cards live in `/mission-control/tasks/<task-id>.md`. Each card contains:
- Task ID, title, status, priority, assigned agent
- Description, context, expected output, constraints
- History of status transitions

Shane's task board (`WORKING.md`) tracks all live work across four columns: **INBOX**, **ACTIVE**, **REVIEW**, **DONE**.

---

## Routing Rules

Tasks are routed by tag (top-to-bottom matching):

| Tag | Routes To |
|-----|-----------|
| `RESEARCH` | Scout |
| `CODE` | Architect |
| `WRITE` | Pitch |
| `FINANCE` | Fin |
| `CONTENT` | Chronicle |
| `NEEDS_REVIEW` | Shane |
| `SOUL_AMENDMENT` | Shane (mandatory human review) |
| `UNTAGGED` | Shane (for triage) |

Agents may re-tag tasks to trigger re-routing. All re-tags must be logged.

---

## Handoff Protocol

When Shane routes a task to a specialist:

1. Write task card → `/mission-control/tasks/<task-id>.md`
2. Tag with routing tag (e.g., `RESEARCH`, `CODE`)
3. Write handoff note → `/mission-control/memory/handoff_context.md` with:
   - What the task is
   - What the human actually needs (intent, not surface request)
   - Relevant constraints and prior decisions
   - Expected output format
4. Update `WORKING.md` — move task to ACTIVE with specialist as owner
5. Log handoff → `/mission-control/logs/shane/YYYY-MM-DD.log`

---

## Memory Conventions

All files in `/mission-control/memory/` follow these rules:

- **Append only** — never overwrite historical content unless explicitly instructed
- **Datestamped sections** — use `## YYYY-MM-DD` headers when appending
- `context.md` — current project context and background
- `decisions.md` — significant decisions with rationale (decision log)
- `handoff_context.md` — rolling context passed between agents
- `glossary.md` — shared vocabulary and definitions

---

## Logging Convention

All agent logs live at `/mission-control/logs/<agent-id>/YYYY-MM-DD.log`.

**Format:**
```
[YYYY-MM-DD HH:MM UTC] [TASK:<task-id>] [STATUS:<status>] <message>
```

Logs are **append-only**. Never delete or modify existing log entries.

---

## Non-Negotiables (Hard Rules)

1. **Never fabricate data or citations** — if uncertain, say so explicitly
2. **Never take irreversible action without explicit human approval**
3. **Always surface conflicts of interest or ambiguity before proceeding**
4. **Log all significant decisions and their rationale**
5. **Human review required** for anything touching finances, legal, or public communications

---

## Markdown and Writing Conventions

Since this system is entirely markdown-driven:

- Use headers, bullet points, and tables — not walls of text
- Tone: direct and concise, no filler, no corporate softening
- Clearly distinguish opinions from facts
- State uncertainty explicitly before making calls
- Dates in ISO format: `YYYY-MM-DD`
- Response length should match task complexity

---

## Development Workflow

### Making Changes

Since this is a documentation system, "development" means editing markdown files.

1. Read the relevant files before editing (especially `MEMORY.md` for current context)
2. Follow the structure and naming conventions of existing files
3. Append to memory/log files; do not overwrite historical content
4. Commit changes with clear, descriptive messages

### Git Conventions

- Branch: `claude/claude-md-mm2ok4tw0dvcrwe2-POY5x` (current session branch)
- Commit messages should describe what changed and why
- No force pushes, no rewriting history

### Adding a New Agent

1. Create folder: `/mission-control/agents/<agent-id>/`
2. Add `SOUL.md` — identity, role, personality, capabilities, limitations
3. Add `MEMORY.md` — working memory template
4. Add `WORKING.md` — task board
5. Register in `/mission-control/ROSTER.md`
6. Add routing rule to `/mission-control/config/routing.md`
7. Add handoff rules to `/mission-control/agents/shane/HANDOFFS.md`

### Adding a Skill

1. Create `/mission-control/skills/<skill-name>.md`
2. Define: trigger, inputs, steps, expected output, error conditions

---

## Current System State

| Component | Status |
|-----------|--------|
| System architecture | Fully documented |
| Shane (coordinator) | Fully defined and operational |
| Routing and handoff rules | Designed |
| Memory conventions | Established |
| Specialist agents (Scout, Architect, Pitch, Fin, Chronicle) | Templates only — not yet implemented |
| Active tasks | None yet |
| Shared memory | Empty (awaiting first use) |
| Config files | Templates only |
| Logs | Empty (awaiting first use) |

---

## Key Files to Read First

When starting work in this repository, read these files in order:

1. `/mission-control/README.md` — overview and quick-start
2. `/mission-control/MASTER_SOUL.md` — core values and principles
3. `/mission-control/agents/shane/MEMORY.md` — current project state and context
4. `/mission-control/SYSTEM.md` — full operating manual
5. `/mission-control/agents/shane/WORKING.md` — what's currently in flight

---

*Last updated: 2026-02-25*

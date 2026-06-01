# START HERE — Project Template

This is a **golden-standard project template** that encodes a complete Claude Code
working philosophy: structured documentation, a disciplined Research → Plan → Implement →
Debug (RPID) loop, a multi-author collaboration model, and a copy-paste prompt library
that drives every kind of task.

It is **stack-agnostic**. Nothing here assumes a language, framework, or platform. Fill in
the placeholders and it works for a CLI, a web app, a backend service, a research codebase,
or a library.

---

## What this template gives you

| Asset | What it is |
|-------|-----------|
| `CLAUDE.md` | The first file every Claude session reads. The operating manual for this repo. **Fill in the `{{PLACEHOLDERS}}`.** |
| `README.md` | Human-facing project front page. |
| `MISSION.md` | Version-agnostic statement of purpose and success metrics (optional — delete if not a goal-driven/research project). |
| `prompts/` | The RPID prompt library. Copy-paste these into Claude sessions to run each step of any task. Already generic. |
| `docs/v1/` | The living documentation backbone — `STATUS`, `DECISIONS`, `ARCHITECTURE`, `DATA_MODEL`, `PLANNING`, `EXPERIMENTS`, `FUTURE_IMPLEMENTATIONS`. |
| `docs/v1/phases/` | Phase + task scaffolding for the collaboration model. |
| `src/` | Your code root. Rename to `frontend/`, `backend/`, `app/`, etc. as needed. |

---

## Two ways to use it

### Option A — Let Claude fill it in (recommended)

Open a Claude Code session in your new repo and paste `prompts/PROJECT_INIT_PROMPT.md`.
It interviews you (starting with your North Star metric) and rewrites every placeholder
doc to be concrete and project-specific. This is the intended entry point.

### Option B — Fill it in by hand

Work top-down:
1. `CLAUDE.md` — replace every `{{PLACEHOLDER}}`. Start with **Project** and **North Star**.
2. `docs/v1/STATUS.md` — set Current Phase, North Star, and Next Actions.
3. `docs/v1/PLANNING.md` — lay out your phases.
4. `docs/v1/DECISIONS.md` — record your first ADR.
5. Fill `ARCHITECTURE.md` and `DATA_MODEL.md` as the design solidifies.

---

## The core philosophy in five sentences

1. **Lost context and outdated context are the only real enemies** — every rule exists to prevent one of them.
2. **`STATUS.md` is read at the start of every session and updated at the end** — it is the single source of "where are we."
3. **Every task runs the RPID loop**: Research → Plan → Implement, then Tests (R→P→I), then Run, then Debug (R→P→I) if anything fails.
4. **Code commits and doc commits are never combined** — `impl:` is code only, `docs:` is malleable-doc updates only.
5. **Decisions are made in Research/Planning and merely executed in Implementation** — if you're making a design choice while coding, stop and go back.

---

## A note on the prompt library

The `prompts/*.md` files are battle-tested and copied verbatim from the origin project.
They are stack-agnostic, but a few inline **examples** inside `RESEARCH_PROMPT.md` and
`PLANNING_PROMPT.md` reference the origin domain (e.g. a `world.json` config file or a
WebSocket message type). Read those as illustrations, not requirements — substitute your
own project's nouns. The headers of those prompts already say as much.

---

## First action

Run `prompts/PROJECT_INIT_PROMPT.md` in a fresh session, **or** open `CLAUDE.md` and
replace the `{{PLACEHOLDERS}}`. Then delete this `START_HERE.md` — it has done its job.

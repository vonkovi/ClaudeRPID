# {{PROJECT NAME}}

{{One-paragraph description: what this project is, who it's for, and what it is NOT.}}

**North Star: {{the single metric every decision is evaluated against}}.**

---

## Status

{{One line: current phase and what's working today. Keep `docs/v1/STATUS.md` authoritative;
this is just a pointer.}}

| Phase | Description | Status |
|-------|-------------|--------|
| 0 | {{Planning — architecture + design spec}} | {{Complete / In progress / Not started}} |
| 1 | {{Core implementation}} | {{...}} |
| 2 | {{...}} | {{...}} |

---

## Repository Layout

```
src/              ← {{primary code root}}
prompts/          ← RPID prompt library (Claude Code workflow)
docs/v1/          ← architecture, data model, planning, decisions, status
CLAUDE.md         ← guidance for Claude Code
MISSION.md        ← purpose and metric definitions
```

---

## Getting Started

```bash
{{# install}}
{{# run locally}}
{{# test}}
```

---

## Key Docs

| File | Contents |
|------|----------|
| [`docs/v1/STATUS.md`](docs/v1/STATUS.md) | Current phase, blockers, next actions |
| [`docs/v1/ARCHITECTURE.md`](docs/v1/ARCHITECTURE.md) | System architecture and key invariants |
| [`docs/v1/DATA_MODEL.md`](docs/v1/DATA_MODEL.md) | Authoritative data model |
| [`docs/v1/PLANNING.md`](docs/v1/PLANNING.md) | Phased checklist with numbered tasks |
| [`docs/v1/DECISIONS.md`](docs/v1/DECISIONS.md) | Architectural decision log (ADRs) |
| [`CLAUDE.md`](CLAUDE.md) | How Claude Code (and the team) works in this repo |

# {{PROJECT NAME}}

{{One-paragraph description: what this project is, who it's for, and what it is NOT.}}

**North Star: {{the single metric every decision is evaluated against}}.**

---

## Status

{{One line: current phase and what's working today. Keep `docs/version1/STATUS.md` authoritative;
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
docs/version1/          ← architecture, data model, planning, decisions, status
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
| [`docs/version1/STATUS.md`](docs/version1/STATUS.md) | Current phase, blockers, next actions |
| [`docs/version1/ARCHITECTURE.md`](docs/version1/ARCHITECTURE.md) | System architecture and key invariants |
| [`docs/version1/DATA_MODEL.md`](docs/version1/DATA_MODEL.md) | Authoritative data model |
| [`docs/version1/PLANNING.md`](docs/version1/PLANNING.md) | Phased checklist with numbered tasks |
| [`docs/version1/DECISIONS.md`](docs/version1/DECISIONS.md) | Architectural decision log (ADRs) |
| [`CLAUDE.md`](CLAUDE.md) | How Claude Code (and the team) works in this repo |

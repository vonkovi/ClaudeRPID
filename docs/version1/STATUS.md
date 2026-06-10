# version1 Status

_Update this file at the start and end of every session. This is the first doc to read when resuming work._

`Template: rpid@2.3.0`  <!-- Template lineage. Read at session start, bumped by UPGRADE_TEMPLATE. Keep in sync with .rpid/template.json. -->


## North Star

> **{{THE SINGLE METRIC EVERY DECISION IS EVALUATED AGAINST}}**

{{One or two sentences on what this means concretely and how it is measured each phase.}}

---

## Current Phase

**Phase 0 — {{Project Name}} Vision Alignment and Architecture Design.**

## What's Done

_Authoritative record of what has been built and decided. Append-only — never delete a line._

- [ ] {{first milestone}}

## In Progress

_1–3 items max._

- {{current active work}}

## Active Blockers

None.

## KPI Baseline

_Measured value of the North Star vs target. Updated after every phase benchmark._

| Metric | Current | Target |
|--------|---------|--------|
| {{North Star metric}} | TBD | {{target}} |

---

## Locked Decisions

See `DECISIONS.md` — authoritative log of all locked ADRs.

## Open Decisions

| ADR | Decision | Resolve By |
|-----|----------|------------|
| ADR-002 | Test infrastructure + isolation (runner; in-process vs Docker vs VM) | Phase 1 |
| ADR-{{NNN}} | {{unresolved choice}} | Phase {{N}} |

## Open Questions

_Numbered. When resolved, strike through and append the answer inline — never delete the line._

1. {{design gap or open question}}

---

## Next Actions

_The literal next things to do, in order._

1. {{first concrete action}}
2. {{second}}
3. {{third}}

# Planning (v1)

The phased implementation checklist.

## Guiding Principles

_The non-negotiable principles that order all work. Examples: "Prove locally before touching
cloud." "Frontend first." "Every phase ends with a measured benchmark."_

1. {{principle}}
2. {{principle}}

## Rules

- Each phase has a hard dependency on the previous phase being **stable and manually verified**.
  Do not start a phase until the prior one is done.
- Each phase breaks into sub-phases (1a, 1b, 1c) for organization.
- Every sub-phase ends with a **Benchmark** task — measure the North Star metric. If a phase
  worsens the metric without compelling justification, the design is wrong.

## Open Infrastructure Decisions

| Decision | Options | Resolve Before |
|----------|---------|----------------|
| Test infrastructure + isolation (ADR-002) | in-process runner vs Docker vs full VM | Phase 1 |
| {{decision}} | {{A vs B}} | Phase {{N}} |

---

## Phase 0: Vision Alignment and Architecture Design

_Phase 0 is always vision alignment: an extensive, thorough interview between the user and Claude
on exactly what is being built — and what it is not — before any code. Capture every uncertainty
(a design choice → an open ADR; an unknown → a numbered open question). Only then draft the doc
backbone._

- [ ] 1. Vision-alignment interview completed; user confirms the vision is captured
- [ ] 2. North Star defined and recorded in STATUS.md + CLAUDE.md
- [ ] 3. Scope boundaries set; deferred items recorded in FUTURE_IMPLEMENTATIONS.md
- [ ] 4. Every uncertainty logged — open ADRs in DECISIONS.md, open questions in STATUS.md
- [ ] 5. ARCHITECTURE.md core loop + invariants drafted
- [ ] 6. DATA_MODEL.md entities drafted
- [ ] 7. PLANNING.md phases laid out (this file)

## Phase 1: {{Core Implementation}}

_{{One sentence: what this phase proves or delivers.}}_

### 1a: {{Sub-phase Name}}

- [ ] 1. {{item}} {{(note if blocked by / supersedes an ADR)}}
- [ ] 2. {{item}}
- [ ] N. **Benchmark: {{metric, metric}}**

### 1b: {{Sub-phase Name}}

- [ ] 1. {{item}}
- [ ] N. **Benchmark: {{metric}}**

## Phase 2: {{...}}

_{{...}}_

---

## Milestones

_Large goals spanning multiple phases._

- {{milestone}}

## Stretch Goals

_Never promised — aspirational only._

- {{stretch goal}}

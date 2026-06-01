# Blank Project Initialization Prompt

**Goal:** Scaffold the entire documentation structure, collaboration framework, and CLAUDE.md
for a new blank repository. Use this at the very start of a project — before any code exists.
The output is a living skeleton that every future Claude session can orient from immediately.
Stack-agnostic: works for any language, framework, or platform.

Copy and paste the block below into a new Claude Code session in your blank repository.

---

```
You are initializing a new project repository. This project follows a specific organizational
gold standard. Your job is to scaffold the entire documentation structure, collaboration
framework, and CLAUDE.md from scratch. Do not write any application code — only structure,
docs, and configuration files.

The project I am about to describe is: [DESCRIBE YOUR PROJECT IN 2-3 SENTENCES]

---

## STEP 1: Establish the North Star

Before creating any file, ask me ONE question:

  "What is the single most important performance/quality metric this project
   must optimize for? This becomes the North Star — every architectural decision
   will be evaluated against it."

Wait for my answer. Record it. It will appear in CLAUDE.md, STATUS.md, PLANNING.md,
and every architectural discussion.

Examples of good North Stars:
  - "Lower compute. Higher speed. Lower cost." (for an LLM-heavy system)
  - "Zero downtime. Sub-100ms p99 latency." (for a real-time service)
  - "One-command deploy. No ops overhead." (for a solo-dev product)

---

## STEP 2: Create the Repository Structure

Create the following folder structure (empty folders get a .gitkeep):

  docs/
    version1/               <- or v2, v3, etc. — whatever versioning scheme fits
      phases/
        .gitkeep
    legacy/                 <- only if there is a prior version to archive
      .gitkeep
  src/                      <- or frontend/, backend/, app/, etc. — your primary code root
    .gitkeep

The key invariant: ALL architectural documentation lives under docs/[version]/. Code
lives in its own top-level folder(s). Legacy/archived code is isolated, never mixed
with active development.

---

## STEP 3: Create the Core Documentation Files

Create all of these files. They are the permanent, living backbone of the project.
Every file below is "malleable" — meaning it should be updated as the project evolves,
but only by the right people at the right time (defined in STEP 6).

### docs/[version]/STATUS.md

This is the FIRST file read at the start of every session and UPDATED at the end of
every session. It must contain:

1.  North Star — the metric from STEP 1, written at the top.
2.  Current Phase — which phase of work is active (from PLANNING.md).
3.  What's Done — a checked-off history of completed milestones. This is the
    authoritative record of what has been built and decided. Never delete from it.
4.  In Progress — current active work (1-3 items max).
5.  Active Blockers — what is preventing forward progress right now.
6.  KPI Baseline — a table comparing the current measured values of the North Star
    metric against the target. Updated after every phase benchmark.
7.  Locked Decisions — one-line pointers to DECISIONS.md entries that are finalized.
8.  Open Decisions — table of unresolved architectural choices with a "Resolve By" phase.
9.  Open Questions — numbered list of design gaps. When resolved, mark them with
    the resolution inline (do not delete the line — mark it strikethrough with the
    answer appended). This gives you a searchable history of every question ever raised.
10. Next Actions — ordered numbered list of the literal next things to do.

### docs/[version]/DECISIONS.md

The Architectural Decision Record (ADR) log. Every significant architectural choice
lives here. Format for each ADR:

  ### ADR-[NNN]: [Short Title]

  **Decision:** [What was decided — one sentence.]

  **Why:** [The reasoning. Include the v-prior baseline if this supersedes something.]

  **Options considered:**
  | Option | Pros | Cons |
  |--------|------|------|
  | ...    | ...  | ...  |

  **Status:** Locked. / Open — resolve before Phase [N].

Rules:
- ADRs are numbered sequentially. Never renumber.
- "Locked" means no member can change this without admin sign-off.
- "Open" means this is an active decision with a deadline phase.
- If a decision supersedes a prior one, note it explicitly in the text.
- Inherited decisions from a prior version should be listed at the top under
  "Inherited from [version]" with a note if they have changed.

### docs/[version]/ARCHITECTURE.md

The high-level system architecture. This doc explains the "why" of each major
subsystem and how they interact — not implementation details (those go in DATA_MODEL.md
or equivalent). Must cover:

- The core loop / main flow (how does the system process a unit of work end-to-end?)
- Every major subsystem and its single responsibility
- Key invariants — rules that must NEVER be violated by any implementation
- Data flows for the 2-3 most important system operations (written as sequential prose
  or annotated pseudocode, not UML)
- The cost model / performance model — how does the system scale, and what are the
  expensive operations?

### docs/[version]/DATA_MODEL.md (or CLASS_MODEL.md / SCHEMA.md)

The authoritative data model. Every entity, its fields, and the invariants on those
fields. This is the contract between frontend and backend, and between phases of work.
When this doc and the code disagree, this doc wins — fix the code.

### docs/[version]/PLANNING.md

The phased implementation checklist. Rules:
- Each phase has a hard dependency on the previous phase being "stable and manually
  verified." Do not start a phase until the prior one is done.
- Each phase is broken into sub-phases (1a, 1b, 1c) for organizational clarity.
- Every sub-phase ends with a Benchmark task — measure the North Star metric after
  every phase. If a phase increases the metric without compelling justification, the
  design is wrong.
- The guiding principles of the project (e.g. "Frontend first", "Prove locally before
  touching cloud") are written at the top of this file.
- Open infrastructure decisions are listed in a table with their "Resolve Before" phase.
- Milestones (large goals that span multiple phases) are listed at the bottom.
- Stretch goals are listed separately — they are never promised, only aspirational.

Format for each phase:

  ## Phase [N]: [Phase Name]

  _[One-sentence description of what this phase proves or delivers.]_

  ### [N]a: [Sub-phase Name]

  - [ ] 1. [Item] (note if this supersedes or is blocked by an ADR)
  - [ ] 2. [Item]
  ...
  - [ ] N. **Benchmark: [metric name, metric name, metric name]**

### docs/[version]/EXPERIMENTS.md

Pre-registration document. Hypotheses and experiment designs are written HERE before
running any experiments. This forces intellectual honesty — you cannot claim a result
you did not predict. Structure:

- Hypothesis ID (H-001, H-002, ...)
- Prediction (specific, falsifiable)
- Experiment design (variables, controls, sample size)
- Measurement method (which KPI, which tool)
- Status: Pending / Running / Completed
- Result (filled in after running)

### docs/[version]/FUTURE_IMPLEMENTATIONS.md

The explicit deferred features list. Every feature that is deliberately out of scope
for the current version lives here. When someone says "we should add X later," it goes
in this file immediately. Rules:
- Never implement anything from this file in the current version without admin sign-off.
- Items here prevent scope creep from being accidental — the decision to defer was
  explicit and documented.

---

## STEP 4: Create the Phase Documentation Structure

For each phase in PLANNING.md, create:

  docs/[version]/phases/
    PHASE_MEMBER_TASK_TEMPLATE.md   <- template (see below)
    phase[N]/
      PHASE[N]_MEMBER_TASK.md       <- generated at phase start, admin-only edits
      task[NN]_[slug]/              <- one folder per task
        RESEARCH_PHASE[N]_TASK[NN].md
        PLANNING_PHASE[N]_TASK[NN].md
        ITERATION1/                 <- only created if debugging is needed
          DEBUG_RESEARCH_PHASE[N]_TASK[NN].md

Naming conventions (strictly enforced):
- Phase folders: phase0, phase1, phase2 — no leading zeros on phase number
- Task folders: task01_[slug], task02_[slug] — zero-padded two-digit task ID
- Branch names: [username]/phase[N]_task[NN]_[slug]
- Doc names: RESEARCH_PHASE[N]_TASK[NN].md — slug NOT repeated in doc name

PHASE_MEMBER_TASK_TEMPLATE.md must contain:

  # Phase [#]: [Phase Name] — Member Tasks

  _Admin-only edits. Generated by Claude at phase start; updated only by admin thereafter._

  ## Phase Overview
  | Field | Value |
  |-------|-------|
  | Phase | [#] |
  | Phase branch | phase[#] |
  | Created from | testing |
  | Collab integrator | [name] |
  | Status | In Progress |
  | Admin sign-off | [ ] |

  ## Members
  | Member | Role | Assigned Tasks |
  |--------|------|---------------|
  | [name] | collab_integrator | [tasks] |
  | [name] | member | [tasks] |

  ## Task Assignments
  [one block per task — see task block format below]

  ## Frozen Shared Contract Files
  No member edits these files unilaterally. All changes go through collab_integrator
  via REQUEST#_PHASE[N]_TASK[NN].md.

  | File | Reason Frozen |
  |------|--------------|
  | [file] | [reason] |

  ## Contract Change Log
  | Request Doc | Filed By | Filed On | Applied On | Status |
  |-------------|----------|----------|------------|--------|

  ## Phase Completion Checklist
  - [ ] All task items checked off
  - [ ] All RPID docs committed as permanent artifacts
  - [ ] Malleable docs updated (ARCHITECTURE.md, DATA_MODEL.md, STATUS.md, PLANNING.md)
  - [ ] No pending contract change requests
  - [ ] Admin sign-off
  - [ ] phase[#] merged to testing
  - [ ] phase[#+1] branch created
  - [ ] phase[#] branch deleted (docs remain — NEVER delete docs/[version]/phases/phase[#]/)

Task block format inside PHASE[N]_MEMBER_TASK.md:

  ### Task [NN]: [Task Name] (maps to PLANNING.md [N][a])

  - **Owner:** [member name]
  - **Branch:** [username]/phase[N]_task[NN]_[slug]
  - **Folder:** docs/[version]/phases/phase[N]/task[NN]_[slug]/
  - **Ownership zone:** [explicit list of files/folders this member owns exclusively]
  - **Hybrid:** [Yes — touches frontend + backend / No]
  - **Status:** [ ] Not started

  **Items (from PLANNING.md):**
  - [ ] 1. [item]

  **RPID docs:**
  - [ ] RESEARCH_PHASE[N]_TASK[NN].md
  - [ ] PLANNING_PHASE[N]_TASK[NN].md
  - [ ] ITERATION1/DEBUG_RESEARCH_PHASE[N]_TASK[NN].md (if needed)

  **Commits (two per task, always in this order, never combined):**
  - [ ] impl: phase[N]_task[NN]   <- code changes ONLY
  - [ ] docs: phase[N]_task[NN]   <- malleable doc updates ONLY

---

## STEP 5: Create CLAUDE.md

CLAUDE.md is the first file Claude reads. It is non-malleable — only the admin edits it.
It must contain the following sections (adapt content to the project):

  # CLAUDE.md

  This file provides guidance to Claude Code (claude.ai/code) when working with
  code in this repository.

  ## Project

  [2-3 sentences: what the project does, what it is NOT (common misconception),
  and the North Star metric in bold.]

  ---

  ## Repository Layout

  [ASCII tree of top-level folders with one-line descriptions of each]
  [State explicitly which folder is active development vs. archived/legacy]

  ---

  ## Active Development: [version]

  **[Current phase status in one sentence.]**

  Read docs/[version]/STATUS.md first when resuming work — it tracks current
  phase, blockers, and next actions. Update it at the end of every session.

  ### Key Docs

  | File | Purpose |
  |------|---------|
  | docs/[version]/STATUS.md | Current phase, blockers, next actions — read at start, update at end |
  | docs/[version]/DECISIONS.md | ADR log — authoritative for all locked decisions |
  | docs/[version]/ARCHITECTURE.md | [what it covers] |
  | docs/[version]/DATA_MODEL.md | [authoritative for all backend implementation] |
  | docs/[version]/PLANNING.md | [N]-phase checklist with numbered tasks |

  ### Build/Run Commands

  [Only list commands that are actually valid for the current phase. If the toolchain
  is not yet set up, say so explicitly rather than listing placeholder commands.
  Include: how to build, how to run locally, how to run the type-checker or linter,
  how to run tests, and how to run a single test in isolation.]

  ---

  ## [Architecture Summary Section — name it after the core architectural concept]

  [Mirror the key concepts from ARCHITECTURE.md here as a quick reference:]
    - The main loop / core flow
    - The component model (table: Component | Responsibility | When it fires)
    - Key invariants (bullet list — these are the "laws" of the system)
    - Performance model summary

  ---

  ## Collaboration

  > [Insert the one-line core collaboration principle]

  ### Roles
  | Role | Responsibility | Authority |
  |------|---------------|-----------|

  ### Branching Hierarchy

    main
      └── testing
            └── phase[N]
                  └── [username]/phase[N]_task[NN]_[slug]

  ### Golden Rules
  1. Task isolation — members only do assigned tasks.
  2. Doc isolation — members only write in their own task folder.
  3. No lost context — all RPID docs are permanent artifacts. Never delete them.
  4. No outdated context — every doc change must be reflected across all related docs.
  5. RPID loop — Research → Plan → Implement → Debug. Always in this order.
  6. Contract files — shared contracts need collab_integrator before any edit.

  ### RPID Loop
  [Describe R→P→I→D in detail including the two-commit rule and the required CI test gate
   on PRs (Track 3) — the full test suite runs as a required GitHub Actions check on every
   PR; author the gate workflow at phase 1 start]

  ### Document Classification
  [Non-malleable / Malleable / Phase-scoped / Task-scoped]

  ### Shared Contract Change Process
  [REQUEST doc process — what, why, how, impact on others]

  ### Phase Lifecycle
  | Event | Who | Action |
  |-------|-----|--------|

---

## STEP 6: Create the Git Branch Structure

Set up branches in this order:

1. Ensure main exists with an initial commit (the scaffold you just created).
2. Create testing from main.
3. Create phase0 from testing.
4. The current working branch should be [your-username]/phase0 or just phase0
   depending on whether there is a collab integrator pattern to enforce.

Do NOT create phase1 yet — it is created only after phase0 is complete and merged.

---

## STEP 7: Verify the Scaffold

After creating all files, run through this checklist:

- [ ] CLAUDE.md exists at repo root
- [ ] docs/[version]/STATUS.md exists and has all 10 required sections
- [ ] docs/[version]/DECISIONS.md exists with at least one ADR
- [ ] docs/[version]/ARCHITECTURE.md exists
- [ ] docs/[version]/DATA_MODEL.md (or equivalent) exists
- [ ] docs/[version]/PLANNING.md exists with at least Phase 0 fully specified
- [ ] docs/[version]/EXPERIMENTS.md exists
- [ ] docs/[version]/FUTURE_IMPLEMENTATIONS.md exists
- [ ] docs/[version]/phases/PHASE_MEMBER_TASK_TEMPLATE.md exists
- [ ] docs/[version]/phases/phase0/ folder exists
- [ ] Branch structure: main → testing → phase0 (or username/phase0)
- [ ] No application code written yet (Phase 0 is planning, not coding)
- [ ] STATUS.md "Next Actions" section has a clear first action
- [ ] Required CI test-gate workflow planned for phase 1 (Track 3 gate; author it at phase 1 start)

---

## CONSTRAINTS

- Do NOT write any application code. This is a documentation and structure sprint only.
- Do NOT invent architecture decisions — leave ADRs as "Open" and list options with
  trade-offs. I will make the decisions.
- Do NOT pre-fill experiment hypotheses — leave EXPERIMENTS.md with structure and a placeholder.
- Every doc you write should be specific to this project. Use the project description I gave
  you to make everything concrete and real — no generic [placeholder] filler.
- If you are unsure about a project-specific detail, write an open ADR entry rather than guessing.
- STATUS.md "Current Phase" should read: "Phase 0 — [Project Name] Documentation and
  Architecture Design."
- STATUS.md "Next Actions" should be the literal first 3-5 things to do to make the project real.
- After creating all files, show a brief summary of what was created and ask:
  "What is the first architectural decision we should lock — pick one ADR to close together
  before Phase 0 work begins."
```

# Project Initialization Prompt (Phase 0)

**Goal:** Turn a freshly instantiated RPID template repo (or, as a fallback, a blank repo) into a
living, project-specific scaffold: run the Phase 0 vision-alignment interview, fill every
placeholder doc, wire the template metadata, and clean up the template's own artifacts.
Stack-agnostic: works for any language, framework, or platform.

Copy and paste the block below into a new Claude Code session in your repository.

---

```
You are initializing a new project repository that follows the RPID organizational gold standard.
Your job: run the Phase 0 vision-alignment interview, then turn the template scaffold into this
project's living documentation. Do not write any application code — only structure, docs, and
configuration files.

The project I am about to describe is: [DESCRIBE YOUR PROJECT IN 2-3 SENTENCES]

---

## STEP 0: Detect the Starting State (before anything else)

Look at the repository and pick the flow:

**Flow A — instantiated from the RPID template** (it has `prompts/`, `.rpid/template.json`, and a
`CLAUDE.md` containing `{{...}}` placeholders). This is the normal case. Your job is to FILL the
shipped files, never to recreate them:

  - Edit placeholders in place. Never regenerate a shipped file from scratch.
  - Never touch the `<!-- RPID:METHODOLOGY:* START -->`…`END` fenced blocks in CLAUDE.md — they
    are template-owned and are swapped only by prompts/UPGRADE_TEMPLATE_PROMPT.md.
  - If `.rpid/template.json` -> `source` is reachable and reports a NEWER version than this repo's
    `version`, pause and offer to run prompts/UPGRADE_TEMPLATE_PROMPT.md first (upgrade, then
    init). Offline or unreachable -> proceed on the current version; never guess.
  - If the docs are ALREADY filled (no `{{...}}` placeholders remain), this project is already
    initialized — do not re-scaffold anything. Offer the upgrade path if the template is behind;
    otherwise report that and stop.

**Flow B — blank repo** (no template files). Recommend instantiating from the template first
("Use this template" on the template repo, or clone and copy), so this prompt can run as Flow A.
Only if that is impossible: create the files described in the steps below from their content
specs, and copy the `.rpid/` directory from the template source — without it the project has no
versioned upgrade path. Flag that limitation explicitly if `.rpid/` cannot be copied.

Everything below is written for Flow A; in Flow B, read "fill" as "create with this content".

---

## STEP 1: Vision Alignment Interview (this IS Phase 0)

Phase 0 is ALWAYS vision alignment between the user and Claude — not coding, not even
architecture. Before touching any file, run an **extensive, thorough interview** to pin down
exactly what is being built and, just as importantly, what it is NOT. Do not rush to scaffold:
this interview is the actual work of Phase 0.

Interview in rounds. Ask a few questions at a time, listen, then probe deeper on anything vague
or hand-wavy. Cover at least:

  1. Problem & users — what problem, for whom, and what do they do today instead?
  2. What it is NOT — the common misconception; the nearest thing this is deliberately not.
  3. North Star — the single metric every decision is weighed against (examples below).
  4. Scope boundaries — what is explicitly in v1 vs deferred to FUTURE_IMPLEMENTATIONS.md.
  5. Core idea / central bet — the one principle everything else is downstream of.
  6. Constraints — platform, stack, budget, deadline, team size, compliance.
  7. Success criteria — how you will know v1 worked; the acceptance bar.
  8. Risks & unknowns — what could sink this; what the user is unsure about.

Rules for the interview:
  - Reflect back what you heard before moving on. Confirm alignment; never assume.
  - Anything the user is UNSURE of is captured, never guessed:
      * a design choice with options -> an OPEN ADR in DECISIONS.md (Status: Open — resolve before Phase N)
      * an open unknown to resolve    -> a numbered OPEN QUESTION in STATUS.md
  - Keep going until the user explicitly confirms the vision is captured. Only THEN proceed to STEP 2.

Examples of good North Stars:
  - "Lower compute. Higher speed. Lower cost." (for an LLM-heavy system)
  - "Zero downtime. Sub-100ms p99 latency." (for a real-time service)
  - "One-command deploy. No ops overhead." (for a solo-dev product)

Record everything. The North Star appears in CLAUDE.md, STATUS.md, PLANNING.md, and every
architectural discussion; the rest of the interview seeds ARCHITECTURE.md, DATA_MODEL.md,
DECISIONS.md, and FUTURE_IMPLEMENTATIONS.md in the steps below.

---

## STEP 2: Verify / Adjust the Repository Structure

The template ships the structure; verify it and adapt it to the project:

  docs/
    version1/               <- or v2, v3, etc. — whatever versioning scheme fits
      phases/
        phase0/
  src/                      <- rename to frontend/, backend/, app/, etc. if that fits better
  legacy/                   <- create ONLY if there is a prior version to archive

The key invariant: ALL architectural documentation lives under docs/[version]/. Code lives in its
own top-level folder(s). Legacy/archived code is isolated, never mixed with active development.
Empty folders get a .gitkeep.

---

## STEP 3: Fill the Core Documentation Files

Fill the shipped docs under docs/[version]/. They are the permanent, living backbone of the
project. Every file below is "malleable" — updated as the project evolves, but only by the right
people at the right time.

### docs/[version]/STATUS.md

This is the FIRST file read at the start of every session and UPDATED at the end of every
session. **Keep the `Template: rpid@X.Y.Z` line at the top intact** — the session-start version
check and the upgrade path depend on it. The file must contain:

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
- Keep the pre-registered **Test Infrastructure** ADR (ADR-002: test runner + isolation —
  in-process vs Docker vs full VM) Open until Phase 1 — it fills .github/workflows/test.yml and
  selects the profiles/ overlay, if any.

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

Not a research/benchmarking project? Leave the file with its structure and a one-line note that
it is unused — do not delete it (the doc backbone stays complete).

### docs/[version]/FUTURE_IMPLEMENTATIONS.md

The explicit deferred features list. Every feature that is deliberately out of scope
for the current version lives here. When someone says "we should add X later," it goes
in this file immediately. Rules:
- Never implement anything from this file in the current version without admin sign-off.
- Items here prevent scope creep from being accidental — the decision to defer was
  explicit and documented.

---

## STEP 4: Phase Documentation Structure

The member-task template ships at **docs/[version]/phases/PHASE_MEMBER_TASK_TEMPLATE.md** — it is
the authoritative format (task blocks, ownership zones, frozen-contract list, and the four-commit
discipline `impl:` -> `test:` -> `fix:` -> `docs:`). Do NOT restate or fork its content: at each
phase start, generate that phase's PHASE[N]_MEMBER_TASK.md from the shipped template.

Per-phase structure (created as phases begin, not all up front):

  docs/[version]/phases/
    PHASE_MEMBER_TASK_TEMPLATE.md     <- ships with the template; the authoritative format
    phase[N]/
      PHASE[N]_MEMBER_TASK.md         <- generated at phase start, admin-only edits
      task[NN]_[slug]/                <- one folder per task; all RPID docs live here
        RESEARCH_PHASE[N]_TASK[NN].md
        PLANNING_PHASE[N]_TASK[NN].md
        TEST_RESEARCH_PHASE[N]_TASK[NN].md
        TEST_PLAN_PHASE[N]_TASK[NN].md
        SESSION_LOG_PHASE[N]_TASK[NN].md
        ITERATION1/                   <- only created if debugging is needed
          DEBUG_RESEARCH_PHASE[N]_TASK[NN].md
          DEBUG_PLAN_PHASE[N]_TASK[NN].md

Naming conventions (strictly enforced):
- Phase folders: phase0, phase1, phase2 — no leading zeros on phase number
- Task folders: task01_[slug], task02_[slug] — zero-padded two-digit task ID
- Branch names: [username]/phase[N]_task[NN]_[slug]
- Doc names: RESEARCH_PHASE[N]_TASK[NN].md — slug NOT repeated in doc name

---

## STEP 5: Fill CLAUDE.md

CLAUDE.md ships with the template and is the first file Claude reads. It is non-malleable — only
the admin edits it after this. Fill its placeholders; do not restructure it:

- **Project Settings** — set the admin username; adjust the Review-autonomy dial if asked.
- **Project + North Star** — 2-3 sentences (including what it is NOT) and the metric from STEP 1.
- **Repository Layout** — make the tree match the real folders (renamed src/, legacy/ if present).
- **Active Development** — the one-sentence current-phase status.
- **Build / Run commands** — only commands that are actually valid right now. If the toolchain is
  not set up yet, write exactly that; never list placeholder commands that fail.
- **Architecture Summary** — mirror the key concepts from ARCHITECTURE.md.
- **Testing / Test Coverage** — leave for prompts/TEST_SETUP_PROMPT.md at Phase 1 start; do not
  invent a test command.

Hard rules:
- Never edit anything inside the `<!-- RPID:METHODOLOGY:* START/END -->` fences.
- Never reintroduce a `{{...}}` token into a section that has been filled.
- (Flow B only) Copy CLAUDE.md from the template source and then fill it — generating it from
  memory loses the methodology fences and breaks future upgrades.

---

## STEP 6: Create the Git Branch Structure

Set up branches in this order:

1. Ensure main exists with an initial commit (the filled scaffold).
2. Create testing from main.
3. Create phase0 from testing.
4. The current working branch should be [your-username]/phase0 or just phase0
   depending on whether there is a collab integrator pattern to enforce.

Do NOT create phase1 yet — it is created only after phase0 is complete and merged.

---

## STEP 7: Finalize Template Metadata & Clean Up

The template leaves artifacts that belong to the template, not to your project. Finish the job:

1. **profiles/** — if the stack is already decided, follow profiles/README.md: copy the matching
   overlay into the repo root, record the choice as ADR-002, then **delete the profiles/ folder**.
   If the stack is still open, leave profiles/ in place and add "pick profile at TEST_SETUP" to
   STATUS.md Next Actions.
2. **README.md** — rewrite it as the project's own front page (what it is, why it exists, how to
   get started). The shipped README describes the template; none of that should survive.
3. **.rpid/template.json** — verify `version` (the template version this project is on) and
   `source` (the template's git URL) are present; verify STATUS.md's `Template: rpid@X.Y.Z` line
   matches `version`. (Flow B: write both now if `.rpid/` was copied.)
4. **Delete the template-repo-only files** — listed in `.rpid/OWNERSHIP.md` under
   "Template-repo-only": MAINTAINING.md, the template self-test suite (tests/check-*.sh,
   tests/run-all.sh, tests/README.md), .github/workflows/template-check.yml, and the template
   README image (.github/readme-hero.png). They guard the template's integrity, not yours.
5. **Delete START_HERE.md** — it has done its job.
6. **Point the user at .github/SETUP.md** to wire the GitHub<->Claude workflows (the
   CLAUDE_CODE_OAUTH_TOKEN secret + the connection self-check). Do not run it for them — it needs
   repo-settings access only they have.

---

## STEP 8: Verify

After all steps, run through this checklist:

- [ ] CLAUDE.md has no `{{...}}` placeholders left in Project, North Star, Repository Layout, or
      Active Development; Build/Run is real or explicitly "not set up yet"
- [ ] CLAUDE.md methodology fences are intact (every START has its END, content untouched)
- [ ] docs/[version]/STATUS.md has all 10 required sections AND the `Template: rpid@X.Y.Z` line
      matching .rpid/template.json
- [ ] docs/[version]/DECISIONS.md has at least one ADR + the Open ADR-002 (Test Infrastructure)
- [ ] docs/[version]/ARCHITECTURE.md, DATA_MODEL.md (or equivalent), PLANNING.md (Phase 0 fully
      specified), EXPERIMENTS.md, FUTURE_IMPLEMENTATIONS.md are filled
- [ ] docs/[version]/phases/PHASE_MEMBER_TASK_TEMPLATE.md exists; docs/[version]/phases/phase0/ exists
- [ ] Branch structure: main -> testing -> phase0 (or username/phase0)
- [ ] No application code written (Phase 0 is planning, not coding)
- [ ] STATUS.md "Next Actions" has a clear first action
- [ ] CI test-gate skeleton (.github/workflows/test.yml) present and flagged to be filled at
      phase 1 — it fails until its placeholder command is replaced (Track 3 gate; ADR-002)
- [ ] README.md rewritten for the project; START_HERE.md deleted
- [ ] Template-repo-only files deleted (MAINTAINING.md, tests/ self-checks, template-check.yml)
- [ ] profiles/ either applied + deleted, or deferred with a STATUS.md note

---

## CONSTRAINTS

- Do NOT write any application code. This is a documentation and structure sprint only.
- Do NOT invent architecture decisions — leave ADRs as "Open" and list options with
  trade-offs. I will make the decisions.
- Do NOT pre-fill experiment hypotheses — leave EXPERIMENTS.md with structure and a placeholder.
- Do NOT touch the CLAUDE.md methodology fences, and never reintroduce a `{{...}}` token.
- Every doc you write should be specific to this project. Use the project description I gave
  you to make everything concrete and real — no generic [placeholder] filler.
- If you are unsure about a project-specific detail, write an open ADR entry rather than guessing.
- STATUS.md "Current Phase" should read: "Phase 0 — [Project Name] Vision Alignment and
  Architecture Design."
- STATUS.md "Next Actions" should be the literal first 3-5 things to do to make the project real.
- After all steps, show a brief summary of what was created and ask:
  "What is the first architectural decision we should lock — pick one ADR to close together
  before Phase 0 work begins."
```

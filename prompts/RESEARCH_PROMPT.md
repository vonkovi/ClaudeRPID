# Research Prompt (R Phase — RPID)

**Goal:** Produce RESEARCH_PHASE[N]_TASK[NN].md — a thorough, scoped research document
that gives the planner everything needed to make a concrete implementation plan without
asking basic questions. This is an information-gathering phase, not a decision-making phase.
You will surface what is known, what is unknown, and what options exist. You will NOT choose
between options. You will NOT write code. You will NOT start implementing anything.

Bad research produces a plan that does not work. Missing research discovered mid-implementation
is one of the most expensive problems in this workflow — it forces context loss, partial rewrites,
and untracked regressions. The cost of thorough research here is always lower than the cost of
discovering a gap during implementation.

Stack-agnostic: works for any language, framework, or platform. Doc names follow the
PROJECT_INIT_PROMPT convention (STATUS.md, DECISIONS.md, ARCHITECTURE.md, etc.) — substitute
your project's actual doc names if they differ, as defined in your project's CLAUDE.md.

Copy and paste the block below into a Claude Code session on your task branch.

---

```
You are entering the Research (R) phase of the RPID loop.

Task ID:    [PHASE[N]_TASK[NN] — e.g. PHASE1_TASK02]
Task slug:  [slug from PHASE[N]_MEMBER_TASK.md — e.g. core_engine]
Branch:     [your branch — e.g. yourname/phase1_task02_core_engine]
Output doc: docs/[version]/phases/phase[N]/task[NN]_[slug]/RESEARCH_PHASE[N]_TASK[NN].md

---

## STEP 1: Load Context

Read ALL of the following before doing anything else. Do not begin research until every
file is read. If a file does not exist, note the gap and flag it before continuing.

Required reading:
1. docs/[version]/STATUS.md — current phase, blockers, open questions
2. docs/[version]/DECISIONS.md — all locked and open ADRs
3. docs/[version]/ARCHITECTURE.md — system architecture and key invariants
4. docs/[version]/DATA_MODEL.md (or equivalent) — authoritative data model
5. docs/[version]/PLANNING.md — your task's items (find sub-phase [N][a/b/c])
6. docs/[version]/phases/phase[N]/PHASE[N]_MEMBER_TASK.md — your task assignment,
   ownership zone, and frozen contract files list
7. Any prior phase research docs relevant to your task — check
   docs/[version]/phases/phase[N-1]/ for anything your task builds on
8. If a partial draft of your research doc already exists, read it

After reading, state a one-paragraph Context Summary in your working notes:
  - What phase/task am I on?
  - What have prior phases established that I depend on?
  - Which locked ADRs directly constrain my solution space?
  - Which open ADRs must I NOT assume are resolved?

---

## STEP 2: Declare Your Scope Boundary

Before researching anything, explicitly declare what is IN scope and what is OUT of scope
for this task. Pull this directly from PHASE[N]_MEMBER_TASK.md and your items in PLANNING.md.

Format:
  IN SCOPE:
    - [item 1 from PLANNING.md]
    - [item 2 from PLANNING.md]
    ...

  OUT OF SCOPE (adjacent work I will not touch):
    - [specific adjacent feature, file, or concern]
    - [specific adjacent feature, file, or concern]
    ...

If there is any ambiguity about scope — two tasks that seem to overlap, an item whose
ownership is unclear — ask ONE clarifying question before proceeding. Do not assume.

---

## STEP 3: Research Each In-Scope Item

For each item in your declared scope, answer all four questions:

a) CODEBASE AUDIT — what already exists that is relevant?
   Search the ownership zone and adjacent code. State:
   "This already exists: [X]" or "Nothing exists yet for this item."
   Do not guess — actually search the files.

b) TECHNOLOGY / LIBRARY AUDIT — if this item requires a technology or approach choice
   (library, framework integration, serialization format, storage backend, etc.),
   research the viable options. For each document:
   - Name and what it does
   - How it fits with the existing stack and locked ADRs
   - Compatibility with the project's language and runtime
   - One-line trade-off summary
   Do NOT pick one. List all viable options. If no technology choice is required,
   write "N/A — no choice required."

c) ARCHITECTURAL FIT — does this item fit cleanly within the existing architecture?
   Are there tensions with ARCHITECTURE.md invariants or DATA_MODEL.md definitions?
   If yes, document the tension specifically (which invariant, which field, which rule).

d) INTERFACE QUESTIONS — if this item produces or consumes an interface (API endpoint,
   API endpoint, message schema, shared type definition), document:
   - Current state: what does that interface look like today (if it exists)?
   - Required state: what does it need to look like after this task?
   - Gap: what must change?

---

## STEP 4: Identify Design Gaps

A design gap is a specific unknown that the planner must resolve before implementation
can proceed without guessing. After completing STEP 3, extract every design gap and
number them DG-1, DG-2, etc.

For each design gap:
- Gap statement: "We do not know [X]."
- Why it matters: "If we get this wrong, [Y] breaks or [Z] is difficult to change later."
- Options table:
  | Option | Description | Pros | Cons | Compatible with locked ADRs? |
  |--------|-------------|------|------|------------------------------|
  | A | ... | ... | ... | Yes / No / Partial |
  | B | ... | ... | ... | Yes / No / Partial |
- Leave the choice blank. Do not pick an option.

CRITICAL GAP RULE: If a design gap conflicts with a locked ADR — meaning all viable
options violate the ADR — mark it "CRITICAL GAP — ADR CONFLICT" and STOP. Do not
continue past this gap until the user addresses it. This is not a planning problem,
it is an architecture problem.

---

## STEP 5: Build the Risk Register

A risk is anything that could cause the implementation to fail, take significantly longer,
or introduce a regression. Include at least one risk in each category:

TECHNICAL RISKS — unknown APIs, untested integrations, performance unknowns, library
  version conflicts
SCOPE RISKS — items that could expand mid-implementation ("and also" creep); note any
  task items that have unclear stopping points
DEPENDENCY RISKS — tasks, ADRs, or external systems that must be ready before this task
  can proceed; flag if any are not yet done
REGRESSION RISKS — existing functionality that could be broken by this change

Format:
| Risk ID | Description | Likelihood (H/M/L) | Impact (H/M/L) | What makes it worse |
|---------|------------|-------------------|----------------|---------------------|
| R-1 | ... | H/M/L | H/M/L | ... |

---

## STEP 6: Map Dependencies

Two types of dependencies:

INCOMING — what must be true or done before this task can start?
  - Other tasks in this phase that must complete first (list by task ID)
  - ADRs that must be locked first
  - External systems or environments that must be deployed or available

OUTGOING — what depends on this task's output?
  - Other tasks in this phase or future phases that read this task's output
  - Shared contract files that will change as a result of this task

For outgoing dependencies: list every other task that will be affected if this task's
output changes. This is the impact section that will go into any REQUEST doc later.

---

## STEP 7: Contract File Impact Check

Look at the frozen contract files listed in PHASE[N]_MEMBER_TASK.md.

For each frozen file:
- Will this task require a change to this file? (Yes / No / Maybe)
- If Yes or Maybe: describe exactly what would need to change and why.
- If Yes: flag that a REQUEST[K]_PHASE[N]_TASK[NN].md will need to be filed with
  the collab_integrator before implementation begins.

Do NOT file the REQUEST doc now — that happens in the planning phase. Just surface
the need here so the planner knows to prepare it.

---

## STEP 8: Write RESEARCH_PHASE[N]_TASK[NN].md

Write the output document to:
  docs/[version]/phases/phase[N]/task[NN]_[slug]/RESEARCH_PHASE[N]_TASK[NN].md

The research document is a permanent artifact. Write it to stand alone — a reader
who has not been in this conversation must be able to understand every finding from
the document itself without needing to ask follow-up questions.

Document structure:

  # Research: Phase [N] Task [NN] — [Task Name]

  ## Context Summary
  [one paragraph from STEP 1]

  ## Scope
  ### In Scope
  [list from STEP 2]

  ### Out of Scope
  [list from STEP 2]

  ## Findings

  ### [Item 1 title from PLANNING.md]
  **Codebase state:** [what exists or "nothing exists yet"]
  **Technology options:** [table, or "N/A — no choice required"]
  **Architectural fit:** ["fits cleanly" or "tension with [specific invariant]"]
  **Interface:** [current state → required state, or "N/A"]

  [repeat block for each in-scope item]

  ## Design Gaps

  ### DG-1: [Short title]
  [gap statement]
  [why it matters]
  [options table]
  Choice: [BLANK — left for planner]

  [repeat for each DG]

  ## Risk Register
  [table from STEP 5]

  ## Dependency Map
  ### Incoming Dependencies
  [list]

  ### Outgoing Dependencies
  [list — these become the impact section of any REQUEST docs]

  ## Contract File Impacts
  | Frozen File | Change needed? | Description of change |
  |-------------|----------------|----------------------|

  ## Open Questions for Planner
  [anything that does not fit the above structure — edge cases, ambiguities,
   things that came up during research that have no clean home above]

---

## STEP 9: Checkpoint — Wait for User Review

After writing the research doc, present this summary to the user:

1. In-scope items researched: [N]
2. Design gaps identified: [list DG titles — DG-1: ..., DG-2: ...]
3. Risks logged: [N]
4. Contract file changes needed: [Yes — [files] / No]
5. Critical Gap — ADR Conflicts found: [Yes — [describe] / None]

Then say exactly:
"Research complete. Please review RESEARCH_PHASE[N]_TASK[NN].md before we move to
planning. If anything is missing or needs deeper investigation, tell me and I will
update the doc. When you are satisfied, use PLANNING_PROMPT to begin the planning phase."

DO NOT proceed to planning. DO NOT write any planning documents. Wait.

---

## CONSTRAINTS

- Do NOT make decisions. Surface options, enumerate trade-offs, leave choices blank.
- Do NOT write code, pseudocode, or scaffolding of any kind.
- Do NOT research topics outside your declared scope boundary.
- Do NOT assume open ADRs are resolved in favor of any particular option.
- If the task assignment in PHASE[N]_MEMBER_TASK.md is ambiguous, ask ONE clarifying
  question before starting STEP 3.
- If you discover that this task's ownership zone conflicts with another member's zone,
  flag it immediately — do not proceed past the conflict.
- If a locked ADR is directly violated by a finding, flag it before continuing.
- The research document is permanent. Write it so it can be read in a future session
  with no memory of this conversation.
```

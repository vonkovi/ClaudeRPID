# Planning Prompt (P Phase — RPID)

**Goal:** Produce PLANNING_PHASE[N]_TASK[NN].md — a concrete, step-by-step implementation
plan that is specific enough to execute without judgment calls. If the Research doc describes
WHAT the problem is and WHAT the options are, the Planning doc describes HOW to solve it,
in WHAT order, and with WHAT exact outputs at each step.

A good plan is one where a developer can read it and work through each step without asking
"but how exactly?" If they need to ask that question, the plan is not specific enough.
A bad plan is one where the implementer has to make design decisions — design decisions
belong in planning, not in implementation, where they are invisible and untracked.

Cycling between Research and Planning (R→P→R→P) before moving to Implementation is
healthy and expected. If you discover a research gap while planning, go back. Do not
plan around an unknown.

Stack-agnostic: works for any language, framework, or platform. Doc names follow the
PROJECT_INIT_PROMPT convention — substitute your project's actual doc names if they
differ, as defined in your project's CLAUDE.md.

Copy and paste the block below into a Claude Code session on your task branch.

---

```
You are entering the Planning (P) phase of the RPID loop.

Task ID:    [PHASE[N]_TASK[NN]]
Task slug:  [slug]
Branch:     [your branch]
Input doc:  docs/[version]/phases/phase[N]/task[NN]_[slug]/RESEARCH_PHASE[N]_TASK[NN].md
Output doc: docs/[version]/phases/phase[N]/task[NN]_[slug]/PLANNING_PHASE[N]_TASK[NN].md

---

## STEP 1: Load Context

Read ALL of the following before doing anything else. Do not begin planning until
every file is read. If any file has changed since the research doc was written, note
the discrepancy before proceeding.

Required reading:
1. docs/[version]/phases/phase[N]/task[NN]_[slug]/RESEARCH_PHASE[N]_TASK[NN].md
   — your primary input; everything in this doc informs the plan
2. docs/[version]/STATUS.md — confirm no new blockers or decisions since research
3. docs/[version]/DECISIONS.md — confirm locked ADRs have not changed since research
4. docs/[version]/ARCHITECTURE.md — key invariants your plan must not violate
5. docs/[version]/CLASS_MODEL.md — authoritative data model; your plan's output
   must be consistent with every field and type defined here
6. All frozen contract files listed in PHASE[N]_MEMBER_TASK.md — read their current
   state so you know exactly what you are working with

If the research doc is stale (STATUS.md shows new decisions made after the research
doc was written), flag the stale sections specifically before planning.

---

## STEP 2: Resolve Every Design Gap

The research doc identified DG-1, DG-2, ... For each design gap, you must make a
decision before the step list can be written. A plan with unresolved design gaps is
not a plan — it is a list of hopes.

For each DG:

a) Read the gap statement, the options table, and the trade-offs.
b) Make a decision. State: "For DG-[N], I choose Option [X]."
c) Write a one-sentence justification that references the project's constraints:
   North Star metric, a specific locked ADR, explicit prior user guidance, or a
   clearly dominant trade-off from the options table.
d) If you genuinely cannot decide (roughly equal trade-offs, no ADR guidance, no
   prior user guidance), present BOTH options side-by-side with a one-line
   recommendation and ask the user to decide. Do not guess. Do not pick arbitrarily.

If resolving a DG reveals a NEW research gap that was not in the research doc, STOP.
Return to RESEARCH_PROMPT, add the gap to the research doc, get user review, and
return to planning once the new gap is answered. Do not plan around an unresearched
unknown.

---

## STEP 3: Write the File Map

List every file in the ownership zone that this task will touch. Be exhaustive —
discovering a missing file mid-implementation is a planning failure.

FILES TO CREATE (new files that do not exist):
| File path (from repo root) | Purpose | Key contents — be specific: type names, function signatures, component names |
|---------------------------|---------|-----------------------------------------------------------------------------|
| ... | ... | ... |

FILES TO MODIFY (existing files that will change):
| File path | What changes | What stays the same |
|-----------|-------------|---------------------|
| ... | ... | ... |

FILES EXPLICITLY LEFT UNTOUCHED (files in the ownership zone that will NOT change):
| File path | Why untouched |
|-----------|--------------|
| ... | ... |

RULE: If a file outside your ownership zone must change, STOP — this requires a
REQUEST doc. Note the file here and prepare the REQUEST doc outline in STEP 6.
Do not plan to directly modify another member's files.

---

## STEP 4: Write the Ordered Step List

The step list is the core of the planning document and the primary input to the
implementer. Rules for writing it:

- Steps are ordered by dependency — you cannot reorder them arbitrarily. A step that
  depends on a prior step must come after it.
- Each step is a single coherent unit of work: one type definition, one component,
  one function, one integration point, one schema. Not "implement the whole module."
- No step contains "and also." If a step has an "and also," split it into two steps.
- Every step must reference exact names: file paths, function names, type names,
  field names. Vague language ("implement the agent logic") is not allowed.
- Every step must have a concrete verify-by. If you cannot write a specific
  verify-by, the step is too vague — make it more specific.

Format for each step:

  ### Step [N]: [Short imperative title — e.g. "Define AgentStateMessage type"]

  **What:**
  [Specific description of what gets built. Name exact functions, types, fields, file
  paths. A developer who has never seen this codebase should know exactly what to write
  after reading this field. No vague language.]

  **Depends on:** [Step numbers this depends on, or "None — can start immediately"]

  **Verify by:**
  [Exactly how to confirm this step is complete and correct. Choose one:
    - "Run: [command] — expected output: [X]"
    - "Open [file] — [field/function/type] exists and matches [spec]"
    - "Load [URL] — [element] renders with [properties]"
    - "[compile/type-check/lint command] passes with zero new errors"
    - "Run test: [specific test name or file] — all pass"
    - "Manual test: [exact steps] — expected result: [Y]"
  A verify-by of "it should work" or "the code looks correct" is not acceptable.
  Use whatever commands are appropriate for your project's language and toolchain.]

---

## STEP 5: Write the Verification Plan

Beyond per-step verification, the verification plan answers: how do you know the
entire task is done and correct? This is the acceptance criteria for the task.

FUNCTIONAL VERIFICATION — what does the feature do? List the specific user-visible
or system-observable behaviors that must work after this task is complete. For each:
state the behavior and how to observe it.

INTEGRATION VERIFICATION — how does this interact with adjacent systems (backend,
WebSocket, other UI panels, Pub/Sub topics, Firestore)? What must be true at every
integration boundary? For each boundary: state the expected behavior.

REGRESSION CHECK — list the existing behaviors that must NOT break. For each:
state how to verify it still works after this task's changes.

NORTH STAR CHECK — does this task move the project's North Star metric (as defined in
STATUS.md and CLAUDE.md) in the right direction, hold it steady, or risk worsening it?
State which. If it risks worsening it, what is the mitigation and how will it be measured?

---

## STEP 6: Prepare Contract Change Request Outlines (if needed)

If STEP 3 identified any frozen contract file changes, prepare a draft REQUEST doc
outline for each. This outline is filed with the collab_integrator before implementation
begins — it is not filed now, but it must be written now so the planner knows the
full scope of coordination needed.

For each affected frozen file, prepare:

  File: REQUEST[K]_PHASE[N]_TASK[NN].md (to be created in your task folder)

  CHANGE: [Exact change to the frozen file — field added, renamed, type changed,
           message type added, etc. Be field-level specific.]

  WHY: [Why this change is required — reference the DG resolution that drove it]

  IMPACT ON OTHER MEMBERS' CODE:
  [For each other task in this phase, list every field, type, or behavior they reference
   that will change. Be exhaustive — semantic breakage (code reading a renamed field)
   will not surface as a git conflict. It must be caught by the impacted member manually.
   "Task02 reads world.json.agents[].sensors — this field is being renamed to
   agent_sensors. Task02 owner must update all reads in [specific files]."]

Note: these are DRAFTS. File them with collab_integrator before starting STEP 1 of
the implementation. Do not implement any contract file changes until collab_integrator
has applied them and announced to all members.

---

## STEP 7: Write PLANNING_PHASE[N]_TASK[NN].md

Write the output document to:
  docs/[version]/phases/phase[N]/task[NN]_[slug]/PLANNING_PHASE[N]_TASK[NN].md

The planning document is a permanent artifact. Write it to stand alone — an implementer
who has not been in this conversation must be able to execute every step from the
document alone, without needing to read this conversation or ask clarifying questions.

Document structure:

  # Planning: Phase [N] Task [NN] — [Task Name]

  ## Design Gap Resolutions
  DG-1: Chose [Option X] — [one-sentence justification]
  DG-2: Chose [Option X] — [one-sentence justification]
  [one entry per DG from the research doc]

  ## File Map

  ### Files to Create
  [table]

  ### Files to Modify
  [table]

  ### Files Left Untouched
  [table]

  ## Implementation Steps
  [full ordered step list from STEP 4 — this is the main body of the document]

  ## Verification Plan
  [from STEP 5: Functional, Integration, Regression, North Star]

  ## Contract Change Requests
  [Draft outlines from STEP 6, or "None required"]

  ## Risk Mitigations
  [For each risk in the research doc's risk register, one-line mitigation:
   "R-1: [risk title] — mitigated by [specific action in step N]"]

---

## STEP 8: Checkpoint — Wait for User Review

Present this summary to the user:

1. Design gaps resolved: [list — "DG-1: chose Option B — [reason]"]
2. Unresolved gaps (awaiting user decision): [list, or "None"]
3. File map: [N] files to create, [N] to modify
4. Implementation steps: [N] total
5. Contract change requests needed: [list files, or "None"]
6. Estimated risk areas: [list the 1-2 highest-impact risks from the register]

Then say exactly:
"Planning complete. Please review PLANNING_PHASE[N]_TASK[NN].md. If any step is
underspecified, if a design gap resolution seems wrong, or if you want to brainstorm
an alternative approach for any step, tell me now. When you are satisfied with the
plan, use IMPLEMENTATION_PROMPT to begin implementation."

DO NOT write any code. DO NOT create any source files. Wait for user review.

---

## CONSTRAINTS

- Do NOT write any code during planning. Pseudocode is allowed ONLY to clarify a
  non-obvious interface or function signature — one line maximum. Not a block.
- Do NOT proceed to implementation if any DG is unresolved.
- Do NOT modify malleable docs (ARCHITECTURE.md, CLASS_MODEL.md, STATUS.md, PLANNING.md)
  during the planning phase — those happen in the docs commit after implementation.
- If a step in your plan would violate a locked ADR, STOP and raise it before writing
  the rest of the plan.
- If a step touches a file outside your ownership zone without a REQUEST doc, flag it —
  do not plan to modify it unilaterally.
- Every step must have a specific verify-by. Vague verification is a planning failure.
- The planning document is permanent. Write every step as if the implementer has no
  memory of this conversation.
```

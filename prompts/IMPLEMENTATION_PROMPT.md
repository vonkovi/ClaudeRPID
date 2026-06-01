# Implementation Prompt (I Phase — RPID)

**Goal:** Execute PLANNING_PHASE[N]_TASK[NN].md faithfully, step by step, producing exactly
two commits in the correct order. This is an execution phase, not a creative phase. All
decisions were made during Research and Planning. The implementer's job is to turn the plan
into working code, track progress precisely, and raise a flag — not improvise — when reality
diverges from the plan.

Two things kill implementations: silent deviation from the plan, and undocumented debug loops.
Both produce code that no longer matches its documentation, which is context loss that compounds
across every future session.

Stack-agnostic: works for any language, framework, or platform. Substitute your project's
actual build and check commands wherever [compile/type-check command] or [linter command]
appear — these are defined in your project's CLAUDE.md Build/Run Commands section.

Copy and paste the block below into a Claude Code session on your task branch.

---

```
You are entering the Implementation (I) phase of the RPID loop.

Task ID:    [PHASE[N]_TASK[NN]]
Task slug:  [slug]
Branch:     [your branch — confirm this is correct BEFORE reading anything else]
Plan:       docs/[version]/phases/phase[N]/task[NN]_[slug]/PLANNING_PHASE[N]_TASK[NN].md

---

## STEP 1: Load Context

Read ALL of the following before writing a single line of code:

1. docs/[version]/phases/phase[N]/task[NN]_[slug]/PLANNING_PHASE[N]_TASK[NN].md
   — your primary input; this is the law for this session
2. docs/[version]/phases/phase[N]/task[NN]_[slug]/RESEARCH_PHASE[N]_TASK[NN].md
   — background for understanding WHY each decision was made (do not re-research)
3. docs/[version]/ARCHITECTURE.md — invariants you must not violate
4. docs/[version]/DATA_MODEL.md — authoritative data model; your code must match this
5. Every file listed in the plan's "Files to Modify" — read their current state before
   touching them; confirm your understanding of what exists before changing it
6. Every file listed in the plan's "Files to Create" — confirm they do not already exist.
   If any already exist, flag it before proceeding — do not overwrite silently.

---

## STEP 2: Pre-Flight Checklist

Before writing any code, verify all of the following. Fix any failure before proceeding.
A dirty pre-flight creates commits that are difficult to untangle later.

- [ ] Current branch matches the task branch in PHASE[N]_MEMBER_TASK.md
      (run: git branch --show-current)
- [ ] No uncommitted changes on this branch
      (run: git status — must be clean)
- [ ] Branch is up to date with phase[N]
      (run: git log --oneline phase[N]..HEAD — should show only your commits, or nothing
       if this is a fresh branch)
- [ ] All contract change requests (if any) have been filed with collab_integrator and
      applied to phase[N] before this session
      (check: REQUEST docs in your task folder marked as "Applied")
- [ ] The plan's "Files to Create" do not already exist
      (spot-check at least two)
- [ ] Compiler / type-checker / linter baseline is clean before you add any code
      (run: [your project's compile or check command, from CLAUDE.md] — zero errors/warnings
       baseline must be confirmed now so that any issues your changes introduce are clearly yours)

State the result of each check explicitly. If any check fails: describe the failure
and fix it before writing a single line of code.

---

## STEP 3: Execute the Step List

Work through the plan's implementation steps in order. For each step:

STEP 3a — Read the step
Re-read the step's "What", "Depends On", and "Verify By" fields before writing anything.
Do not rely on memory from a prior read.

STEP 3b — Implement
Write the code described in "What". Follow these rules without exception:
  - Match the exact file paths, function names, and type names from the plan.
  - Do not add features, abstractions, or cleanup that are not in the plan.
  - "While I'm here" changes are forbidden. If you notice a bug or improvement
    in adjacent code, note it with a one-line comment:
    // TODO: [issue] — out of scope for phase[N]_task[NN]
    and move on. Do not fix it now.
  - Do not add comments explaining WHAT the code does — the plan already documented
    that, and well-named identifiers do it for the reader.
  - Do add one short comment if a non-obvious WHY exists: a hidden constraint, a
    workaround for a specific library bug, a subtle invariant. One line. Never a block.
  - Match the project's existing code style precisely: indentation, import ordering,
    naming conventions, file structure.

STEP 3c — Verify
Run the "Verify By" check from the plan exactly as written.
  - If it passes: the step is done. Move to 3d.
  - If it fails on the first attempt: diagnose the failure. Try one fix.
  - If it fails on the second attempt: invoke the Debug Protocol (STEP 5).
    Do not continue trying after two failed attempts.

STEP 3d — Track progress
After each completed step, update your working note:
  "Steps 1-[N] complete and verified. Step [N+1] in progress. Steps [N+2]-[total] not started."
You should be able to report this status at any point in the session.

---

## STEP 4: Deviation Protocol

A deviation is any moment when what you need to write differs from what the plan says.
Deviations happen — a type does not exist yet, a library API changed, a dependency is
different than expected, the plan made an incorrect assumption.

When a deviation occurs:

1. STOP writing code immediately.
2. Write a deviation report:

   DEVIATION — Step [N]: [step title]
   Plan said:          [what the plan expected — quote it directly]
   Reality is:         [what you actually found]
   Why it differs:     [your best hypothesis for the discrepancy]
   Proposed fix:       [what you would write instead, and why it still satisfies the
                        step's stated goal]
   Downstream impact:  [list any subsequent steps whose inputs change as a result
                        of the proposed fix]

3. Present the deviation report to the user.
4. Wait for confirmation before proceeding.

Do NOT implement your best guess at a resolution and move on. Silent deviations
accumulate into a codebase that no longer matches its planning doc, which defeats
the purpose of planning and creates invisible context loss for every future session.

If a deviation reveals that the plan itself is fundamentally wrong — not a small
adjustment, but a structural error — STOP implementation entirely. Return to
PLANNING_PROMPT and update the plan before resuming.

---

## STEP 5: Debug Protocol

If a "Verify By" check fails and you cannot identify the fix within two attempts:

1. Do NOT keep trying in silence. Debugging without documentation is invisible context loss.
2. Create the iteration folder:
   docs/[version]/phases/phase[N]/task[NN]_[slug]/ITERATION1/
3. Write DEBUG_RESEARCH_PHASE[N]_TASK[NN].md in that folder:

   # Debugging Research: Phase [N] Task [NN] — Iteration 1

   ## Failed Step
   Step [N]: [title]

   ## Expected Behavior (from plan's Verify By)
   [exact expected output, state, or behavior — copied from the plan verbatim]

   ## Observed Behavior
   [exact actual output: error message, stack trace, or observable state — copy-paste,
    do not paraphrase. The exact text matters for diagnosing the root cause.]

   ## What Was Tried
   Attempt 1: [what you tried] → [result]
   Attempt 2: [what you tried] → [result]

   ## Hypotheses
   H1: [root cause hypothesis — be specific about which system or component is at fault]
   H2: [alternative hypothesis]

   ## Research Needed
   [What you need to understand to resolve this. This becomes the R phase of the
    debug loop — targeted, scoped research on the failing behavior only.]

4. Tell the user exactly:
   "Step [N] failed verification after two attempts. I have created
   ITERATION1/DEBUG_RESEARCH_PHASE[N]_TASK[NN].md. Please review it. We need to
   run a debug loop before continuing implementation."

5. The debug loop is a mini RPID scoped to the failing step:
   - R: use RESEARCH_PROMPT scoped to the failing behavior only
   - P: use PLANNING_PROMPT scoped to the fix only
   - I: implement the fix, then resume the main implementation step list
   - Increment to ITERATION2/ if the first debug loop does not resolve it.

---

## STEP 6: The impl Commit

When ALL steps are complete and ALL "Verify By" checks pass:

1. Run your project's compile/check and linter over all files you modified
   (commands are in your project's CLAUDE.md Build/Run Commands section):
   - [compile/type-check command] — must pass with zero NEW errors
     (errors that existed before your changes are not your problem to fix here)
   - [linter command] — must pass with zero new warnings introduced by your changes

2. Run git status and review every file in the diff. Confirm each of the following
   before staging anything:
   - Only files from the plan's "Files to Create" and "Files to Modify" appear in the diff
   - No malleable docs are in the diff — these are the docs/[version]/ files classified
     as "Malleable" in your project's CLAUDE.md (typically STATUS.md, DECISIONS.md,
     ARCHITECTURE.md, the data model doc, PLANNING.md, and other shared truth docs)
   - No RPID docs are in the diff —
     RESEARCH_*.md, PLANNING_*.md, DEBUG_*.md files are documentation, not code
   - No .env files, credential files, or secrets
   - No generated build artifacts (dist/, build/, out/, target/, __pycache__/,
     node_modules/, .next/, etc. — whatever your build system produces)

3. Stage only the code files — add them by path, not with git add -A or git add .

4. Present the diff summary to the user:
   "Ready to commit [N] files. Changed: [list each file]. No malleable doc changes are
   included. Shall I proceed with the impl commit?"

5. Wait for explicit user confirmation.

6. Make the commit:
     git commit -m "impl: phase[N]_task[NN]"
   Nothing else in the message. No description, no bullet points. The planning doc is
   the description. That is what it is for.

---

## STEP 7: After the impl Commit — What Comes Next

The docs commit (updating ARCHITECTURE.md, DATA_MODEL.md, STATUS.md, PLANNING.md to
reflect this task's changes) happens separately, later, and only after coordination.
It is NOT part of this session's job.

The correct sequence for the docs commit is:
1. Task owner announces to collab_integrator that the impl commit is made.
2. All members pull from phase[N] before the task owner continues.
3. Task owner updates malleable docs to reflect the task's changes.
4. Task owner makes the docs commit:
     git commit -m "docs: phase[N]_task[NN]"
5. Task owner opens a PR to phase[N]; collab_integrator reviews and merges.

The two commits are NEVER combined. They are always made in this order. The impl
commit contains zero doc changes. The docs commit contains zero code changes.

After the impl commit, tell the user:
"impl commit made. Next step: announce to collab_integrator that phase[N]_task[NN]
impl is complete. After all members pull from phase[N], run the docs commit."

---

## STEP 8: Handoff Summary

After the impl commit, present this handoff summary:

1. Steps completed: [list all N steps — ✓ Step 1: [title], ✓ Step 2: [title], ...]
2. Files created: [list with paths]
3. Files modified: [list with paths]
4. Deviations from plan: [list each with resolution, or "None — plan followed exactly"]
5. Debug iterations: [list with outcomes, or "None"]
6. Verification status: [all checks passed / list any that were waived and why]
7. Next action: "Announce impl complete to collab_integrator. Wait for all members to
   pull from phase[N]. Then run the docs commit."

---

## CONSTRAINTS

- Do NOT add features, abstractions, or cleanup not in the plan. This includes
  renaming variables for style, adding error handling for edge cases not in scope,
  refactoring adjacent code, or fixing bugs noticed in other files.
- Do NOT modify malleable docs during the impl commit. Zero exceptions.
- Do NOT combine the impl and docs commits. Zero exceptions.
- Do NOT push to remote without explicit user confirmation.
- Do NOT skip the pre-flight checklist. A wrong branch creates git history that is
  expensive to unwind.
- Do NOT proceed past a failed verify-by without invoking the deviation or debug protocol.
- Do NOT make architectural changes during implementation. If the plan requires an
  architectural change, the plan is wrong — go back to PLANNING_PROMPT.
- If you discover a locked ADR is being violated by the plan, STOP and raise it before
  implementing.
- If you discover a file outside your ownership zone must be modified, STOP — do not
  modify it. Raise it as a deviation.
```

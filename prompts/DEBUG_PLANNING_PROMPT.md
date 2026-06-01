# Debug Planning Phase Prompt — RPID Loop (Track 4, P)

Copy into a new Claude Code session after DEBUG_RESEARCH is approved.

```
You are beginning DEBUG PLANNING — Track 4, step P, iteration [M].
Root cause is confirmed. Plan the minimal fix. Do NOT change code. Do NOT change tests.

STEP 0: Read CLAUDE.md.

STEP 1: Load Context
- ITER[M]/DEBUG_RESEARCH_PHASE[N]_TASK[NN].md (confirmed root cause and evidence)
- PLANNING_PHASE[N]_TASK[NN].md (original plan — fix must stay within its boundaries)
- TEST_PLAN_PHASE[N]_TASK[NN].md (the test the fix must satisfy)
- Every file named in DEBUG_RESEARCH as relevant to the root cause

STEP 2: Confirm Fix Scope
State:
- Root cause (one sentence from DEBUG_RESEARCH)
- Minimal change that eliminates it
- What the fix must NOT touch

If the fix requires changing test logic: STOP.
Write: "Fix requires changing test [name]. This means the test or the plan was wrong — not code. Requesting guidance."

STEP 3: Deviation Check
Does the fix stay within PLANNING_PHASE[N]_TASK[NN].md boundaries?
- Yes: proceed.
- No: invoke Deviation Protocol before proceeding.
  Write: "Plan said [X]. Root cause revealed [Y]. Proposed fix: [Z]. Downstream impact: [W]."
  Wait for confirmation.

STEP 4: Write the Fix Step List
For each step: What (exact file, function, line) | Depends on | Verify by (exact command + expected output).
No "and also" in a single step. Every step has a concrete verify-by.

STEP 5: Write ITER[M]/DEBUG_PLAN_PHASE[N]_TASK[NN].md
In docs/[version]/phases/phase[N]/task[NN]_[slug]/ITER[M]/.

STEP 6: Checkpoint
End with: "Debug planning iteration [M] complete. Please review before debug implementation."
```

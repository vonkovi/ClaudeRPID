# Debug Research Phase Prompt — RPID Loop (Track 4, R)

Copy into a new Claude Code session after a FAIL in Track 3.

```
You are beginning DEBUG RESEARCH — Track 4, step R, iteration [M].
A test failed. Find the root cause. Do NOT change code. Do NOT change tests.

STEP 0: Read CLAUDE.md.

STEP 1: Load Context
- SESSION_LOG_PHASE[N]_TASK[NN].md — find the failing test and verbatim output
- TEST_PLAN_PHASE[N]_TASK[NN].md — what the failing test was designed to catch
- TEST_RESEARCH_PHASE[N]_TASK[NN].md — original failure hypotheses
- PLANNING_PHASE[N]_TASK[NN].md — what the feature was supposed to do
- Every file listed in PLANNING as "Files Modified" or "Files Created"
- All prior DEBUG_RESEARCH and DEBUG_PLAN docs for this task (if iteration > 1)

One sentence: which test failed, what it expected, what it observed.

STEP 2: Form Hypotheses
At minimum two independent hypotheses for root cause.
For each: what evidence confirms it? What evidence refutes it? What diagnostic produces that evidence?

STEP 3: Run Diagnostics
Run the minimum steps to confirm or refute each hypothesis.
For each: state the step, paste verbatim output, conclude confirms/refutes.
Do not proceed until at least one hypothesis is confirmed by evidence.
If all hypotheses are refuted: generate new ones and repeat.
If inconclusive after exhausting hypotheses: STOP.
Write: "All hypotheses refuted. Unexplained behavior: [X]. Requesting guidance."

STEP 4: State Root Cause
One sentence: "Root cause is [X] because [evidence]."
No hedging. If you can't write it in one sentence, you haven't confirmed it.

STEP 5: Write ITER[M]/DEBUG_RESEARCH_PHASE[N]_TASK[NN].md
In docs/[version]/phases/phase[N]/task[NN]_[slug]/ITER[M]/.
Sections: Symptom (verbatim) | Hypotheses | Diagnostic results | Root cause.

STEP 6: Checkpoint
End with: "Debug research iteration [M] complete. Root cause: [one sentence]. Please review before debug planning."
```

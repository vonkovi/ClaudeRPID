# Test Planning Phase Prompt — RPID Loop (Track 2, P)

Copy into a new Claude Code session after TEST_RESEARCH is approved.

```
You are beginning TEST PLANNING — Track 2, step P of the RPID loop.
Translate failure hypotheses into concrete, runnable test cases.
Do NOT write test code. Every test case must map to a specific failure hypothesis.
"Verify X works" is not a test case — rejected.

STEP 0: Read CLAUDE.md. Confirm test file locations and naming conventions.

STEP 1: Load Context
- TEST_RESEARCH_PHASE[N]_TASK[NN].md (hypotheses, edge cases — source of truth)
- PLANNING_PHASE[N]_TASK[NN].md (what the feature does)
- Every file listed in PLANNING as "Files Created" or "Files Modified"

STEP 2: Map Every Hypothesis to a Test Case
For each FH-N and edge case, write one specification:

| Field | Required |
|-------|---------|
| Name | Descriptive, maps to hypothesis. E.g., "FH-2: returns null on empty input" |
| Hypothesis | Which FH-N or edge case |
| Precondition | Exact system state before the test |
| Action | Exact call or interaction |
| Expected result | Exact output or state — no vagueness |
| Failure means | What conclusion to draw if this fails |
| Type | Unit / Integration / Regression |

If a test cannot be automated: document as a manual step with exact instructions and justify why.
Test names are permanent — they link code to hypotheses for all future readers.

STEP 3: Coverage Check
For each FH-N and edge case: confirm at least one test case covers it.
Explicitly document any hypothesis that cannot be tested and why.

STEP 4: Write TEST_PLAN_PHASE[N]_TASK[NN].md
Permanent artifact in docs/[version]/phases/phase[N]/task[NN]_[slug]/.
Format as a table: Name | Hypothesis | Precondition | Action | Expected Result | Failure Means | Type

STEP 5: Checkpoint
End with: "Test planning complete. Please review before we move to test implementation."
```

# Test Research Phase Prompt — RPID Loop (Track 2, R)

Copy into a new Claude Code session on your task branch after the `impl` commit exists.

```
You are beginning TEST RESEARCH — Track 2, step R of the RPID loop.
The feature is implemented and committed. Your job: find every way it could be wrong.
Do NOT write tests yet. Do NOT fix anything. Surface failure hypotheses only.
Default assumption: the implementation fails somewhere.

STEP 0: Read CLAUDE.md. Confirm build and test commands. One sentence confirmation.

STEP 1: Load Context
- PLANNING_PHASE[N]_TASK[NN].md (what was planned and how)
- RESEARCH_PHASE[N]_TASK[NN].md (why it was designed this way)
- The project architecture doc
- Every file listed in PLANNING as "Files Created" or "Files Modified"
Write a one-paragraph summary of what was implemented.

STEP 2: Adversarial Analysis
Answer each:
1. What are the three most likely ways this implementation is silently wrong?
2. What inputs or system states cause failure that the implementation didn't consider?
3. Which architecture invariants does this task touch — and how could it violate them?
4. What properties was this task supposed to establish — could any remain unestablished?
5. What existing behavior could this task have broken (regression surface)?

Minimum three distinct failure hypotheses. More is better.

STEP 3: Contract and Invariant Check
For each contract file touched: could a semantic breakage exist that won't surface as a type error?

STEP 4: Edge Case Inventory
- Boundary values (empty, zero, max)
- Null / undefined / missing states
- Ordering-dependent scenarios
- States valid individually but invalid in combination

STEP 5: Write TEST_RESEARCH_PHASE[N]_TASK[NN].md
Permanent artifact in docs/[version]/phases/phase[N]/task[NN]_[slug]/.
Organize as: Failure Hypotheses (FH-1, FH-2…) | Contract Risks | Edge Cases | Regression Surface.

STEP 6: Checkpoint
End with: "Test research complete. Please review before we move to test planning."
```

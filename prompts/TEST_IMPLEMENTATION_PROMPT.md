# Test Implementation Phase Prompt — RPID Loop (Track 2, I)

Copy into a new Claude Code session after TEST_PLAN is approved.

```
You are beginning TEST IMPLEMENTATION — Track 2, step I of the RPID loop.
Write test code that exactly matches the plan. Nothing more.
Do NOT fix feature code. Do NOT add tests beyond the plan.
Test names must match TEST_PLAN exactly — they are the permanent link to hypotheses.

STEP 0: Read CLAUDE.md. Confirm test commands and test file conventions.

STEP 1: Load Context
- TEST_PLAN_PHASE[N]_TASK[NN].md (source of truth for this session)
- TEST_RESEARCH_PHASE[N]_TASK[NN].md (hypotheses, for context only)
- PLANNING_PHASE[N]_TASK[NN].md (what the feature code does)
- Every file listed in PLANNING as "Files Created" or "Files Modified"

STEP 2: Pre-Flight
- [ ] Branch: git branch --show-current = [username]/phase[N]_task[NN]_[slug]
- [ ] impl commit exists: git log --oneline shows "impl: phase[N]_task[NN]"
- [ ] No uncommitted changes
- [ ] Build checks pass cleanly before writing any tests

STEP 3: Write the Tests
For each test case in TEST_PLAN:
1. Re-read the spec before writing
2. Write the test — name must match TEST_PLAN exactly
3. Assertions must match "Expected result" exactly
4. Deviation from plan → Deviation Protocol (STEP 4)

Rules:
- Match existing test style exactly
- No assertions beyond what the plan specifies
- Do NOT change feature code to make tests pass — that is a fix commit

STEP 4: Deviation Protocol
If the test plan cannot be implemented as written: STOP.
Write: "Plan said [X]. Reality is [Y]. Proposed approach: [Z]. Hypothesis [FH-N] still tested: [yes/no]."
Wait for confirmation.

STEP 5: The test Commit
- [ ] Build checks pass
- [ ] git diff: test files only — no feature code touched
- [ ] Stage by path (never git add -A)
- [ ] Present diff to user, wait for confirmation
- [ ] Commit: "test: phase[N]_task[NN]"

STEP 6: Hand off to Track 3
Use TESTING_PROMPT.md in a new session. Pass: branch name, task folder, test files written.
Do NOT run tests yourself. Do NOT open a PR yet.

STEP 7: Handoff Summary
List test cases written (by name), files created/modified, any deviations.
End with: "Test implementation complete. Handing off to Testing Run. Awaiting user approval."
```

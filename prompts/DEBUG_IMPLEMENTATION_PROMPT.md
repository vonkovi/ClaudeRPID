# Debug Implementation Phase Prompt — RPID Loop (Track 4, I)

Copy into a new Claude Code session after DEBUG_PLAN is approved.

```
You are beginning DEBUG IMPLEMENTATION — Track 4, step I, iteration [M].
Fix plan is approved. Implement exactly what it says. Nothing more.
Do NOT refactor. Do NOT change tests to match wrong behavior.

STEP 0: Read CLAUDE.md. Confirm build commands.

STEP 1: Load Context
- ITER[M]/DEBUG_PLAN_PHASE[N]_TASK[NN].md (source of truth for this session)
- ITER[M]/DEBUG_RESEARCH_PHASE[N]_TASK[NN].md (root cause and evidence)
- Every file listed in DEBUG_PLAN as fix targets

STEP 2: Pre-Flight
- [ ] Correct branch
- [ ] No uncommitted changes
- [ ] Build checks pass before applying any fix

STEP 3: Execute Fix Steps
For each step in DEBUG_PLAN:
1. Re-read the step before writing
2. Implement exactly what it says
3. Run verify-by

If verify-by fails: Deviation Protocol.
Write: "Plan said [X]. Reality is [Y]. Proposed adjustment: [Z]. Downstream impact: [W]."
Wait for confirmation.

Rules:
- No "while I'm here" changes
- Match existing code style
- Log any deviation from DEBUG_PLAN before applying

STEP 4: The fix Commit
- [ ] Build checks pass
- [ ] git diff: fix targets only — no test files, no doc files
- [ ] Stage by path (never git add -A)
- [ ] Present diff to user, wait for confirmation
- [ ] Commit: "fix: phase[N]_task[NN]_iter[M]"

STEP 5: Hand off to Track 3
Use TESTING_PROMPT.md in a new session. Full suite must be re-run — not just the previously failing test.

STEP 6: Handoff Summary
Fix steps completed | Files modified | Deviations (if any).
End with: "Debug implementation iteration [M] complete. Handing off to Testing Run. Awaiting user approval."

RULE: After two debug iterations without passing: STOP and escalate. Do not attempt a third without explicit user instruction.
```

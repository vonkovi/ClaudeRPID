# Documentation Phase Prompt — RPID Loop (After Track 3 Pass)

Copy into a new Claude Code session after SESSION_LOG shows PASS.

```
You are beginning the DOCUMENTATION phase — the final step before PR.
Track 3 passed. Your only job: leave every malleable doc more accurate than you found it.
Do NOT touch code files. Do NOT add features to docs that were not implemented.
Docs describe reality. They do not describe intentions.

NORTH STAR: No lost context. No outdated context. Both must pass simultaneously.

STEP 0: Read CLAUDE.md.
Identify: which docs are malleable (editable here), which are non-malleable (admin only).
One sentence confirmation.

STEP 1: Load Context
- SESSION_LOG_PHASE[N]_TASK[NN].md (what passed, what was built)
- PLANNING_PHASE[N]_TASK[NN].md (what was planned)
- All DEBUG_PLAN docs for this task (if debug iterations occurred)
- All malleable docs
One paragraph summary of what was implemented and verified.

STEP 2: Audit Every Malleable Doc
For each doc, answer TWO questions:
1. Lost context: "Is anything that happened in this task missing from this doc?"
2. Outdated context: "Does this doc still describe anything no longer true?"
Both must pass. One passing is not enough.

STATUS.md:
- [ ] Task recorded in What's Done?
- [ ] Next Actions updated to reflect what actually comes next?
- [ ] New blockers recorded?
- [ ] In Progress no longer lists this task?
- [ ] If a new session started now and read only this doc, would it know exactly where things stand?

DECISIONS.md:
- [ ] Did this task resolve an open decision? Record it as locked.
- [ ] Did this task reveal a new unresolved decision? Add it as open.
- [ ] Any decision still marked "Open" that is now resolved?

ARCHITECTURE.md:
- [ ] Did this task add or change any component, flow, or invariant?
- [ ] Does any section still describe a component replaced by this task?

PLANNING.md:
- [ ] Completed task checked off?
- [ ] Any future task description now conflicts with what was actually built? (Flag for user — do not silently rewrite.)

STEP 3: Write All Updates
- Remove or correct outdated content — do not leave old descriptions alongside new ones
- Do not add aspirational content — only what is now true
- Do not rewrite sections that are already accurate

STEP 4: Verify the Diff
Run: git diff --name-only
Expected: only malleable doc files. No source code or test files.
If any code file appears: STOP. Revert it before proceeding.

STEP 5: The docs Commit
- [ ] git diff clean: malleable docs only
- [ ] Stage by path (never git add -A)
- [ ] Commit: "docs: phase[N]_task[NN]"

STEP 6: Open PR
Open PR from `[username]/phase[N]_task[NN]_[slug]` to `phase[N]`.
PR description: what was implemented, what was fixed, what tests were added.

STEP 7: Checkpoint
List: docs updated (what changed) | docs unchanged (confirmed accurate) | flags for user.
End with: "Documentation complete. Task phase[N]_task[NN] is fully closed."
```

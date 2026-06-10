# Issue Mode — Remote Trigger

**Type: Remote trigger. Non-interactive.** This mode fires automatically when a GitHub issue is assigned to Claude. It reads the issue from GitHub, runs all tracks autonomously without human gates, and posts results back to the issue. There are no interactive sessions — the entire run is one continuous autonomous execution.

For interactive bug fixes initiated by a human, use FEATURE_MODE instead and skip Track 1.

---

## Trigger Condition

Fired by the `.github/workflows/claude-issue-to-pr.yml` workflow when an issue is **labeled
`claude`** (or assigned to the Claude bot account). That workflow runs this mode at `Review
autonomy = auto` with write permissions and passes:
- Issue number
- Issue title
- Issue body (full text)
- Repository and default branch

---

## Entry Steps (automated)

Before any track work:

1. Read CLAUDE.md.
2. Read the assigned GitHub issue in full using the GitHub tools. Quote the reported behavior verbatim — this is what reproduction tests must catch.
3. Run the full test suite. Record output as the **regression baseline** in `SESSION_LOG_PHASE[N]_TASK[NN].md` before touching anything.
4. Create branch automatically: `claude/issue-[NNN]-[slug]` from the **base branch** — the open `phase[N]` branch if one exists, else the repository default branch (the usual case for autonomous CI runs). The slug is a 2–4 word snake_case summary of the issue title.
5. Post a comment on the GitHub issue: "Picked up. Working on branch `claude/issue-[NNN]-[slug]`."

If the branch already exists (issue was previously attempted): read the existing SESSION_LOG to understand prior run history before proceeding.

---

## GStack roles & autonomy

This mode presets **`Review autonomy = auto`** — the loop runs end-to-end without stopping for
routine decisions, but **Hard Gates always stop** and post to the issue for human action (see
`CLAUDE.md` → Ethos → Gate Behavior; e.g. a contract-file change, a high-confidence security
finding, escalation after the one debug iteration). When `GStack role reviews` is ON, run
`prompts/reviews/CODE_REVIEW_PROMPT.md` on the diff before opening the PR (auto-apply mechanical
fixes; surface anything in the ASK column as an issue comment), and use `prompts/SHIP_PROMPT.md`'s
plan-completion + verification steps before posting the fix. Every auto-decision is logged in
SESSION_LOG.

---

## Track Sequence (autonomous — no human gates)

### Track 2 — Reproduction Tests

**R(test) focus is different from feature mode.** The question is not "how could this implementation fail?" It is: "what exact inputs and system state trigger the reported behavior?" Every hypothesis must be traceable to a specific claim in the issue body.

Run inline — no separate sessions:

1. **Test Research:** Analyze the issue. Form failure hypotheses (minimum 3). Quote the issue verbatim. Identify edge cases. Write `TEST_RESEARCH_PHASE[N]_TASK[NN].md`.
2. **Test Planning:** Translate each hypothesis into a concrete test case specification. Every test case must be runnable without human interpretation. Write `TEST_PLAN_PHASE[N]_TASK[NN].md`.
3. **Test Implementation:** Write test code matching TEST_PLAN exactly. Commit: `test: phase[N]_task[NN]`.

### Track 3 — Verify Bug Exists

Run the full test suite. Paste verbatim output into SESSION_LOG.

**First-run outcome is inverted:**

| Outcome | Meaning | Action |
|---------|---------|--------|
| Tests **FAIL** | Bug reproduced — correct | Continue to Track 4 |
| Tests **PASS** | Bug cannot be reproduced | STOP — post to issue, open draft PR |

If tests pass on the first run, post to the GitHub issue:
> "Reproduction tests passed on current code — the reported behavior cannot be reproduced on branch `claude/issue-[NNN]-[slug]`. Either the bug was already fixed, or the reproduction tests did not target the right behavior. Human review required before proceeding."
Open a draft PR with the reproduction tests and stop.

### Track 4 — Fix (one iteration maximum)

Run inline — no separate sessions:

1. **Debug Research:** Research the root cause. Minimum two hypotheses. Run diagnostics. Confirm root cause in one sentence. Write `ITERATION1/DEBUG_RESEARCH_PHASE[N]_TASK[NN].md`.
2. **Debug Planning:** Plan the minimal fix. Write `ITERATION1/DEBUG_PLAN_PHASE[N]_TASK[NN].md`.
3. **Debug Implementation:** Implement fix. Commit: `fix: phase[N]_task[NN]_iter1`.

### Track 3 — Verify Fix

Run the full suite again. Compare against the regression baseline.

**If all tests pass:**
- Append PASS entry to SESSION_LOG.
- Open PR: `claude/issue-[NNN]-[slug]` → the base branch it was created from (the open `phase[N]` branch if one exists, else the default branch). PR description includes: issue number, root cause (one sentence), fix summary, test names added.
- Post to GitHub issue: "Fixed in PR #[NNN]. Reproduction tests added. Regression baseline preserved."

**If tests still fail after one debug iteration:**
- Append FAIL entry to SESSION_LOG.
- Open a draft PR with all work completed so far.
- Post to GitHub issue:
  > "Debug iteration 1 did not resolve the failure. Root cause identified: [one sentence]. Last known error: [verbatim failing test output, truncated to 20 lines]. Human review required to continue."
- Stop. Do not attempt a second debug iteration.

---

## Hard Rules

1. Never touch a contract file. Post to issue: "Blocked — fix requires changes to contract file `[name]`. Human action required." Stop.
2. Never touch a file outside the issue's ownership zone. Block and report.
3. Never combine commits.
4. Never open a non-draft PR for a run that did not reach PASS in Track 3.
5. Always re-run the full test suite — never only the failing test.
6. Always paste verbatim test output in SESSION_LOG — never summarize.
7. If the build breaks and cannot be restored in one step: post to issue immediately and stop all work.

---

## Commit Order

| Commit | Track | Contains |
|--------|-------|----------|
| `test: phase[N]_task[NN]` | 2 | Reproduction tests only |
| `fix: phase[N]_task[NN]_iter1` | 4 | Fix code only |
| `docs: phase[N]_task[NN]` | After pass | Malleable doc updates only |

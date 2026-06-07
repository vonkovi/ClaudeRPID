# Ship (release readiness)

**Role:** You wear the **Release** hat — a release engineer who takes a green task to a merged PR
with the plan verified complete. You run **after Track 3 passes** (local + CI green, `docs:`
committed).

**Output:** a verified-complete change and a PR (or the exact commands if no platform CLI is
available). Runs when `GStack role reviews` is ON; obeys the `Review autonomy` dial.

**Follow `prompts/reviews/_SHARED.md`** — Gate Behavior, decision briefs, User Sovereignty,
completion status. **A production deploy is a Hard Gate — always stop for it.**

> Source: adapted from GStack `/ship` (Garry Tan), stripped of version-queue/Greptile/Codex/
> redaction machinery. Deploy/canary specifics live in `profiles/`, not here.

---

## Step 1 — sync the base branch (before tests)

Merge the base branch into the feature branch first, so tests run on the merged result. Stop on a
complex conflict and hand it back.

## Step 2 — run the full suite + Test-Failure Ownership Triage

Run the whole suite. If anything fails, **don't stop blindly** — classify each failure:

- **In-branch** — the failing test or the code it covers was changed on this branch. **STOP** —
  these are yours to fix before shipping.
- **Pre-existing** — neither the test nor its code was changed on this branch.
  - SOLO project → ask: fix now / add a P0 TODO / skip (you accept the risk).
  - TEAM project → ask: fix now / assign to whoever last touched the code / P0 TODO / skip.
- When ambiguous, default to **in-branch** (safer to stop than to ship a break).

If any in-branch failure remains, STOP. Otherwise continue.

## Step 3 — coverage audit + gate

Trace every changed codepath and user flow; draw the ASCII coverage diagram (same format as the
Eng review's test section). Read `CLAUDE.md` → `## Test Coverage` for `Minimum:` / `Target:`
(defaults 60% / 80%):

- `≥ target` → pass.
- `≥ minimum, < target` → ask: generate more tests / ship and accept the risk / mark intentionally
  uncovered. (Max 2 generation passes.)
- `< minimum` → ask: generate tests / override and ship with low coverage.

For test-only diffs, skip this step.

## Step 4 — plan-completion audit

Find the task's plan (the `PLANNING` artifact / plan file). Extract every actionable item (cap 50).
Classify each against the diff:

- **DONE** (cite the file) · **PARTIAL** · **NOT DONE** · **CHANGED** (goal met a different way) ·
  **UNVERIFIABLE** (the diff can't prove it — e.g. external config; cite the manual check).

**Honesty rule:** code that *handles* a deliverable is not the deliverable. When unsure between
DONE and UNVERIFIABLE, choose UNVERIFIABLE. Gate:
- any **NOT DONE** → ask: implement now / defer to a P1 TODO / drop from scope.
- any **UNVERIFIABLE** → confirm each one individually (never blanket-confirm); a "no" blocks ship.

## Step 5 — scope-drift check

Compare what was requested (plan / commit messages / TODOs) against what the diff actually changed.
Report `Scope Check: CLEAN / DRIFT DETECTED / REQUIREMENTS MISSING`. Informational — does not block.

## Step 6 — verification (the Iron Law of shipping)

**No completion claim without fresh verification evidence.** If any code changed since the last
test run, re-run the suite now. Paste the result.

## Step 7 — open the PR

Compose the PR body and create the PR (or print the branch + remote + exact command if no platform
CLI is available — never block; the code is pushed and ready). PR body sections:

```
## Summary           — every substantive change, grouped by area
## Test Coverage      — the coverage diagram; "Tests: before → after"
## Pre-Landing Review — the Code-review findings (or "No issues found")
## Plan Completion    — the audit summary; any deferred items
## Verification       — fresh test result
## TODOS              — items completed / created (if any)
```

End with a completion status (DONE / DONE_WITH_CONCERNS / BLOCKED). Never force-push; never deploy
without an explicit Hard-Gate approval.

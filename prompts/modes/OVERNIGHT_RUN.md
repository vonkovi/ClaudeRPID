# Overnight Run Mode — Autonomous Multi-Task

**Type: Autonomous. User-induced.** The user provides a list of tasks and starts the run. No human gates between tracks. Stronger guardrails apply throughout because divergence risk is high without oversight. Results are reported at the end for human review.

---

## Task List Format

```
[feature] Description  →  phase[N]_task[NN]_[slug]
[issue]   GitHub issue #NNN: description  →  phase[N]_task[NN]_[slug]
```

Each task is labeled `[feature]` or `[issue]`. The label determines which tracks run.

---

## Phase 0 — Setup

Run before any task:

1. Read CLAUDE.md.
2. Run the full test suite. Paste verbatim output. This is the **regression baseline** for the entire run.
3. Map every task to a branch name. Check each branch exists; create from `phase[N]` if not.
4. Build the dependency graph. If task B depends on task A's output, A runs first. State each dependency explicitly.
5. Identify pre-blockers: any task requiring a contract file change is BLOCKED before it starts. Log it and skip it.
6. Print the execution plan:
   ```
   Task 1: [feature|issue] [description] → branch: [name] → depends on: none
   Task 2: [feature|issue] [description] → branch: [name] → depends on: Task 1
   Blocked: [description] → reason: [contract file | dependency failed]
   ```

Begin execution immediately after printing. Do not wait.

---

## Per-Task Execution

Print header: `=== TASK [N]/[total]: [feature|issue] [description] ===`

| Task type | Tracks run |
|-----------|------------|
| `[feature]` | Track 1 → Track 2 → Track 3 → Track 4 (if needed) |
| `[issue]` | Track 2 → Track 3 (expect fail) → Track 4 → Track 3 |

All tracks run inline. All overnight guardrails apply.

---

## Overnight Guardrails

These override the defaults in the individual track prompts.

**Track 2, R(test):** Minimum **five** failure hypotheses (not three). Every hypothesis must have at least one test case — zero uncovered hypotheses permitted. Regression tests required for every modified code path. Integration tests required if the task touches system boundaries.

**Track 2, P(test):** Each test case must include a "Regression risk" field.

**Deviations:** Log and apply the minimal adjustment if it stays within the ownership zone. If the deviation requires touching a file outside the ownership zone or a contract file: BLOCK the task, log it, continue to next task.

**Track 4:** Hard limit of **one** debug iteration per task. If Track 3 still fails after one debug iteration: mark FAILED, log last known root cause, continue to next task.

**Regression detection:** After every Track 3 run, compare against the Phase 0 baseline. If any previously passing test now fails: mark task FAILED, block all dependent tasks, log: `[REGRESSION] Task [N] introduced failure in [test name]. Blocking: [dependent task IDs].`

---

## Per-Task Log

Append to `OVERNIGHT_LOG_[date].md` after each task:

```
Task [N]: [PASS | FAILED | BLOCKED]
Type: [feature | issue]
Branch: [name]
Commits: [list or "none"]
Tests: [N passed / M total]
Regressions vs baseline: [none | list]
Reason (if not PASS): [one sentence]
Deviations: [none | list]
```

---

## Final Report

Write `OVERNIGHT_REPORT_[date].md`:

**Summary table:** Task | Type | Outcome | Commits | Tests

**Regression map:** For each regression: which task caused it, which tests broke, which tasks were blocked.

**Files modified:** All files changed across PASS tasks only.

**PRs opened:** PASS tasks only.

**Required user actions:**
- Failed tasks (reached debug limit): last known root cause
- Blocked tasks (contract file): which file, why needed
- Blocked tasks (dependency): depends on which failed task
- Regressions requiring investigation

Print: `"Overnight run complete. See OVERNIGHT_REPORT_[date].md."`

---

## Hard Rules

1. Never touch a contract file. Block the task.
2. Never touch a file outside the current task's ownership zone. Block the task.
3. Never combine commits.
4. Never open a PR for a task that did not reach PASS in Track 3.
5. Never attempt a second debug iteration per task.
6. Always run the full test suite — never only the failing test.
7. Always paste verbatim output — never summarize.
8. If the build breaks and cannot be restored in one step: STOP all tasks. Report immediately.

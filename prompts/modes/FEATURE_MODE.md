# Feature Request Mode — Interactive

**Type: Interactive.** The user works in parallel. Each track produces an output document; the user reviews it at the gate and approves or redirects before the next session begins. The user does not need to watch sessions run — the gate is the document, not a live review.

---

## Entry Checklist

Before starting Session 1:
- [ ] Read the feature request description. If it describes existing broken behavior rather than new behavior, use ISSUE_MODE instead.
- [ ] Confirm phase and task ID (e.g., `phase1_task02`)
- [ ] Confirm correct branch: `[username]/phase[N]_task[NN]_[slug]`
- [ ] Read CLAUDE.md

---

## Track Sequence

### Track 1 — Feature Implementation

| Session | Prompt | Output | Gate |
|---------|--------|--------|------|
| 1 | `prompts/RESEARCH_PROMPT.md` | `RESEARCH_PHASE[N]_TASK[NN].md` | User reviews — approve or redirect before Session 2 |
| 2 | `prompts/PLANNING_PROMPT.md` | `PLANNING_PHASE[N]_TASK[NN].md` | User reviews — approve or redirect before Session 3 |
| 3 | `prompts/IMPLEMENTATION_PROMPT.md` | `impl: phase[N]_task[NN]` commit | User reviews diff before Session 4 |

### Track 2 — Tests

| Session | Prompt | Output | Gate |
|---------|--------|--------|------|
| 4 | `prompts/TEST_RESEARCH_PROMPT.md` | `TEST_RESEARCH_PHASE[N]_TASK[NN].md` | User reviews — approve or redirect before Session 5 |
| 5 | `prompts/TEST_PLANNING_PROMPT.md` | `TEST_PLAN_PHASE[N]_TASK[NN].md` | User reviews — approve or redirect before Session 6 |
| 6 | `prompts/TEST_IMPLEMENTATION_PROMPT.md` | `test: phase[N]_task[NN]` commit | User reviews diff before Session 7 |

### Track 3 — Run

| Session | Prompt | Output | Decision |
|---------|--------|--------|----------|
| 7 | `prompts/TESTING_PROMPT.md` | `SESSION_LOG_PHASE[N]_TASK[NN].md` | All pass → Session 8. Any fail → Track 4. |

### Track 4 — Debug (repeating)

| Session | Prompt | Output | Gate |
|---------|--------|--------|------|
| N | `prompts/DEBUG_RESEARCH_PROMPT.md` | `ITERATION[M]/DEBUG_RESEARCH_PHASE[N]_TASK[NN].md` | User reviews |
| N+1 | `prompts/DEBUG_PLANNING_PROMPT.md` | `ITERATION[M]/DEBUG_PLAN_PHASE[N]_TASK[NN].md` | User reviews |
| N+2 | `prompts/DEBUG_IMPLEMENTATION_PROMPT.md` | `fix: phase[N]_task[NN]_iter[M]` commit | User reviews diff → back to Track 3 |

After two debug iterations without passing: STOP. Escalate. Do not attempt a third without explicit user instruction.

### Docs (after Track 3 pass)

| Session | Prompt | Output |
|---------|--------|--------|
| Final | `prompts/DOCUMENTATION_PROMPT.md` | `docs: phase[N]_task[NN]` commit + PR to `phase[N]` |

---

## User Parallelism

- The gate is the output document. The user reads it at their own pace, approves or redirects.
- The user can run unrelated tasks on other branches in parallel between gates.
- A redirect at any gate propagates backward to the earliest affected step — a planning redirect invalidates the implementation; a research redirect invalidates the plan.
- Never merge to `phase[N]` without Track 3 passing locally, the required CI check green, and the PR approved by collab_integrator.

---

## Commit Order

| Commit | Track | Contains |
|--------|-------|----------|
| `impl: phase[N]_task[NN]` | 1 | Feature code only |
| `test: phase[N]_task[NN]` | 2 | Test code only |
| `fix: phase[N]_task[NN]_iter[M]` | 4 | Fix code only (repeating; absent if Track 3 passes first run) |
| `docs: phase[N]_task[NN]` | After pass | Malleable doc updates only |

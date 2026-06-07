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

## GStack role steps (optional — on when `GStack role reviews` is ON; gated by `Review autonomy`)

These are reviews, not new tracks. They slot into the gates above and produce findings for your
approval. Each runs only when relevant; `Review autonomy` decides whether each stops for you
(`full` = every one; `auto` = only Hard Gates). FEATURE_MODE presets `Review autonomy = full`.

| Slot | Prompt | What it adds |
|------|--------|--------------|
| Phase 0 / before Session 1 | `prompts/OFFICE_HOURS_PROMPT.md` | Vision diagnostic — forcing questions + alternatives gate (big/ambiguous features) |
| After Session 1 (research) | `prompts/reviews/CEO_REVIEW_PROMPT.md` | Scope / 10-star challenge (new user-facing or large work) |
| After Session 2 (planning) | `prompts/reviews/ENG_REVIEW_PROMPT.md` (+ `DESIGN_REVIEW` if UI) | Architecture lock + test matrix |
| After Session 3 (impl) | `prompts/reviews/CODE_REVIEW_PROMPT.md` (+ `SECURITY_REVIEW` if security-relevant) | Pre-merge bug audit + adversarial pass |
| After Track 3 pass | `prompts/SHIP_PROMPT.md` | Plan-completion audit + scope-drift + PR |
| After merge | `prompts/RETRO_PROMPT.md` | Reflect — retro + learnings |
| Once, if no test gate yet | `prompts/TEST_SETUP_PROMPT.md` | Bootstraps the real CI test gate (closes ADR-002) |

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

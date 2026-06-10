# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

<!-- Template-maintainers only; harmless in downstream projects (the condition is simply false there). -->
> 🛠️ **Maintaining the RPID template itself?** If this repo *is* the template source (not a project
> built from it), read **[`MAINTAINING.md`](MAINTAINING.md)** first — the `{{PLACEHOLDER}}` tokens
> below are the product, not gaps to fill.

> **How to use this template:** Replace every `{{PLACEHOLDER}}`. Delete sections that do not
> apply (e.g. drop the experiment metrics if this is not a research/benchmarking project).
> Keep the **Collaboration** section close to verbatim — it is the reusable methodology.
> The fastest way to fill this in is to run `prompts/PROJECT_INIT_PROMPT.md` in a fresh session.

> **Placeholder integrity (read before acting):** A `{{...}}` token is an *unfilled* placeholder.
> While any remain in a doc, that area of the project is **not yet instantiated** — do **not**
> invent build commands, architecture, metrics, or status to fill the gap, and do not run code
> or test workflows that assume they exist. Surface the gap instead. If asked to "set up", "init",
> or "scaffold" the project, run the interview in `prompts/PROJECT_INIT_PROMPT.md` rather than
> guessing. Once a placeholder is replaced with real content, this rule is dormant for that spot;
> never re-introduce a `{{...}}` token into a section that has already been filled.

## Project Settings

_Project-level feature flags — read first. This template ships in **SOLO mode**: one developer
+ Claude. The **Collaboration** section below is written for a team; in SOLO mode the
team-coordination machinery is **DORMANT, not removed**. To change how the project operates,
flip a flag here — **do not delete the underlying section.**_

**Mode: SOLO** — admin: `{{your-username}}`.

| Feature | Flag | Solo behavior |
|---------|------|---------------|
| RPID loop | **ON** | Unchanged — core rigor, independent of team size |
| No-lost / no-outdated context (Golden Rules 3–4) | **ON** | Unchanged — the most important rules |
| Permanent task artifacts | **ON** | Unchanged |
| Document classification (non-malleable / malleable / task-scoped) | **ON** | Unchanged |
| Commit discipline (`impl`/`test`/`fix`/`docs`) | **ON** | Unchanged |
| CI test gate (Track 3) | **ON** | Your only second reviewer — more valuable solo |
| Branch hierarchy (`main`/`testing`/`phase#`/`task#`) | **ON** | Unchanged |
| User review gates → **Review autonomy** dial | **full** | `full` = you approve every gate (default) · `milestone` = one approval per task · `auto` = hands-off, stops only at Hard Gates. Defined in **Ethos → Gate Behavior**. ISSUE/OVERNIGHT modes preset this to `auto`. |
| GStack role reviews (CEO / Eng / Code / Security / Design) | **ON** | Specialist review rubrics at each gate — hats Claude wears, orthogonal to the human roles. Each is gated by Review autonomy. |
| Template versioning + self-link (`.rpid/`) | **ON** | Project knows its template lineage (version + source in `.rpid/template.json`) and can upgrade via `prompts/UPGRADE_TEMPLATE_PROMPT.md`. |
| Three-role model (Admin / Collab Integrator / Member) | **DORMANT** | You are all three; ignore role separation |
| Shared Contract Change Process (`REQUEST#` docs) | **DORMANT** | Edit shared/contract files directly; just weigh ripple effects first |
| "Announce to collab_integrator" / "all members pull" steps | **DORMANT** | No-op solo — skip them |
| Task & doc *isolation* (who-may-touch-what, Golden Rules 1–2) | **DORMANT** | You own everything. The `task#/` folder structure + RPID artifact placement stay **ON** — only the cross-member restriction is off |
| `PHASE#_MEMBER_TASK.md` role/ownership assignment | **DORMANT** | Task *breakdown* still useful; skip the role / ownership / frozen-contract columns |

**Reactivation rule:** a DORMANT feature becomes authoritative again the instant its flag flips
to **ON** (e.g. a second contributor joins). The Collaboration sections are preserved verbatim
for exactly that reason — SOLO → TEAM: flip the flags, re-read Collaboration, and the full
process is restored with no rewriting.

## Project

{{ONE-TO-THREE SENTENCES: what this project is, and — importantly — what it is NOT
(the common misconception). State the audience and the core value.}}

**North Star: {{THE SINGLE METRIC EVERY DECISION IS EVALUATED AGAINST — e.g. "Lower compute.
Higher speed. Lower cost." or "Zero downtime. Sub-100ms p99." or "One-command deploy, no ops."}}**
Every architectural decision is weighed against this.

---

## Repository Layout

```
src/              ← {{primary code root — rename to frontend/ backend/ app/ as needed}}
prompts/          ← RPID prompt library (modes/ + per-track prompts + reviews/)
docs/version1/          ← architecture, data model, planning, status — the living doc backbone
docs/version1/phases/   ← phase + task scaffolding for the collaboration model
profiles/         ← opt-in stack overlays — pick one at init/TEST_SETUP, then delete (profiles/README.md)
legacy/           ← {{archived prior version, if any — delete if greenfield}}
.github/workflows/ ← CI: the required test gate (test.yml) + @claude / auto-review / issue→PR actions
.rpid/            ← template self-link + metadata (version, ownership map, changelog, migrations)
CLAUDE.md         ← this file (admin-only)
README.md         ← human-facing front page (admin-only)
MISSION.md        ← purpose + success metrics (admin-only; optional)
```

State explicitly which folders are **active development** vs **archived**. Active: `src/`,
`docs/version1/`. Archived: `legacy/` ({{if present}}).

---

## Active Development: version1

**{{Current phase status in one sentence — e.g. "Phase 0 complete. Phase 1 (Core
Implementation) is next."}}**

Read `docs/version1/STATUS.md` first when resuming work — it tracks current phase, blockers, and
next actions. **Update it at the end of every session too.**

<!-- RPID:METHODOLOGY:VERSION-CHECK v2.0 START -->
> **Template version check (session start).** This project records its template lineage in
> `.rpid/template.json` and the `Template:` line of `STATUS.md`. If a newer template version is
> known (from the template `source` in `.rpid/template.json`), print **one** line:
> "Template update available: rpid@X → rpid@Y — run `prompts/UPGRADE_TEMPLATE_PROMPT.md`." Say it
> once per session; never auto-apply. Offline or no source reachable → skip silently. Running init
> in an existing project that's behind should likewise offer the upgrade rather than re-scaffold.
<!-- RPID:METHODOLOGY:VERSION-CHECK v2.0 END -->


> **Phase 0 is always Vision Alignment.** Every version begins with an extensive, thorough
> interview between the user and Claude to align on *exactly* what is being built — and what it
> is **not** — before any code or architecture. Uncertainties are captured, never guessed: a
> design choice becomes an **open ADR** in `DECISIONS.md`; an unknown becomes a numbered **open
> question** in `STATUS.md`. Phase 0 closes only when the vision is aligned and every uncertainty
> is logged. Run it via `prompts/PROJECT_INIT_PROMPT.md`.

### Key docs

| File | Purpose |
|------|---------|
| `docs/version1/STATUS.md` | Current phase, blockers, next actions — **read at session start, update at session end** |
| `docs/version1/DECISIONS.md` | Architectural Decision Log (ADR format) — authoritative for all locked decisions |
| `docs/version1/ARCHITECTURE.md` | System architecture, core loop, key invariants, cost/performance model |
| `docs/version1/DATA_MODEL.md` | Authoritative data model / schema — when this and the code disagree, fix the code |
| `docs/version1/PLANNING.md` | Phased implementation checklist with numbered tasks |
| `docs/version1/EXPERIMENTS.md` | Pre-registered hypotheses / benchmarks (optional — research or perf projects) |
| `docs/version1/FUTURE_IMPLEMENTATIONS.md` | Explicitly deferred features — do not implement without admin sign-off |
| `docs/version1/phases/PHASE_MEMBER_TASK_TEMPLATE.md` | Template for generating `PHASE#_MEMBER_TASK.md` at phase start |

### Build / Run commands

> Only list commands that are actually valid right now. If the toolchain is not set up yet,
> say so — do not list placeholder commands that fail.

```bash
{{# install dependencies}}
{{# run locally / dev server}}
{{# build for production}}
{{# type-check or lint}}
{{# run the full test suite}}
{{# run a SINGLE test in isolation  ← always document this}}
```

---

## Architecture Summary

> Mirror the key concepts from `ARCHITECTURE.md` here as a quick reference. Replace this
> whole section with your project's actual architecture.

**Core loop:** {{how the system processes one unit of work end-to-end, in 1-3 sentences}}

**Components:**

| Component | Responsibility | When it runs |
|-----------|---------------|--------------|
| {{Component}} | {{single responsibility}} | {{trigger}} |

**Key invariants** (the "laws" of the system — never violated by any implementation):
- {{invariant 1}}
- {{invariant 2}}

**Performance model:** {{how it scales; what the expensive operations are; how this ties
to the North Star}}

---

<!-- RPID:METHODOLOGY:ETHOS v2.0 START -->
## Testing

> Filled by `prompts/TEST_SETUP_PROMPT.md` at Phase 1 start. Until then this project has **no
> real test gate** — `.github/workflows/test.yml` fails on purpose so the gate is never falsely green.

Tests are organized by the **CI gate, not a folder.** `.github/workflows/test.yml` is the required
Track 3 check, and its `run:` command *is* the definition of "the suite." Your test directory is
whatever your stack uses (`tests/`, a `_test.go` beside each source file, `__tests__/`, …) — it is
wired into that command at `TEST_SETUP`, which is also what makes the location authoritative.

- **Test directory:** `{{e.g. tests/ — decided at TEST_SETUP}}`
- **Run the full suite:** `{{cmd — this is also the test.yml run step}}`
- **Run a SINGLE test:** `{{cmd}}`

## Test Coverage

> Filled by `TEST_SETUP`. Records the coverage tool, the target threshold, and how it's enforced.

- **Tool / threshold:** `{{e.g. coverage ≥ 80%}}`

## Ethos

> The builder principles every session operates by. Adapted from Garry Tan's GStack ethos and
> fused with RPID's anti-context-rot core. Each principle ties to a rule you already follow.

- **Boil the Lake.** AI makes completeness cheap. When the complete implementation (full tests,
  all edge cases, every error path) costs minutes more than the shortcut, do the complete thing.
  Boil "lakes" (a module's full coverage); flag "oceans" (multi-quarter rewrites) as out of scope.
  → the force behind the Track 3 gate and every benchmark.
- **Search Before Building.** Before building anything unfamiliar, ask "has this been solved?"
  Three Layers of Knowledge: (1) tried-and-true — don't reinvent; (2) new-and-popular — scrutinize;
  (3) first principles — prize above all. A **Eureka** is when first-principles reasoning shows the
  conventional approach is wrong *here* — name it. → the Research (R) track's job.
- **User Sovereignty.** AI recommends; the user decides. The one rule that overrides all others.
  Cross-model agreement is a strong signal, never permission to act. → why every gate is a gate.
- **The Golden Age.** One person with AI now builds what took a team of twenty. What remains is
  taste, judgment, and the willingness to do the complete thing. → the premise of SOLO mode.
- **The Iron Law (debugging).** No fix without investigation — find the root cause, then fix it.
  Escalate after two failed iterations. → this is Track 4.

### Gate Behavior (the Review-autonomy dial)

Every review/track gate reads the **Review autonomy** flag (Project Settings) to decide whether to
stop for you. Each review decision is classified first:

- **Mechanical** — obvious; a senior engineer would just do it (rename, dead-code removal).
- **Taste** — reasonable people could differ (two valid architectures).
- **User Challenge** — a review wants to change *your stated* direction.

| Level | Mechanical | Taste | User Challenge | Hard Gates |
|-------|-----------|-------|----------------|------------|
| **full** (default) | ask | ask | ask | always stop |
| **milestone** | auto + log | surface once, at the task boundary | always stop | always stop |
| **auto** | auto + log | auto-decide by the principles above + log | **always stop** | always stop |

In `milestone`/`auto`, every auto-decision is written to the task `SESSION_LOG` — nothing is silent.

**Hard Gates — ALWAYS stop, even in `auto`** (one-way doors): destructive / irreversible ops
(force-push, history rewrite, data deletion, production deploy) · architecture or shared-contract
changes (a new/changed ADR, a `DATA_MODEL` change, a frozen contract file) · a high-confidence
security finding · a **User Challenge** · escalation after two failed debug iterations · anything a
prompt classifies as a one-way door.
<!-- RPID:METHODOLOGY:ETHOS v2.0 END -->

## Collaboration

> **Lost context and outdated context are the real enemies.**

Every rule below is downstream of this. When in doubt, ask: does this action risk losing or
silently outdating context for another Claude or team member?

### Roles

| Role | Responsibility | Authority |
|------|---------------|-----------|
| **Admin** | Owns non-malleable docs (`CLAUDE.md`, `README.md`, `MISSION.md`). Final say on direction. Decides when a phase is finished. | Absolute — except on a `phase#` branch while that phase is open |
| **Collab Integrator** | Owns the `phase#` branch. Applies all shared-contract changes. Announces pulls. Merges completed phases to `testing`. Creates the next phase branch. | Supersedes admin on the `phase#` branch until the phase closes |
| **Member** | Works on assigned tasks in their own branch (`username/phase#_task#`). Opens PRs to `phase#`. Requests contract changes via the requesting process. Never touches contract files directly. | Scoped to their assigned task folder and ownership zone |

> Solo project? You play all three roles. The discipline still pays off: the branch hierarchy
> and the two-commit rule keep your own future sessions from losing context.

<!-- RPID:METHODOLOGY:GSTACK-ROLES v2.0 START -->
### Roles Claude wears (GStack personas)

Distinct from the human roles above. These are **functional hats Claude puts on at a gate** — a
structured review lens, not a separate person. They are **orthogonal** to the Admin / Integrator /
Member model (which is about who-owns-what across humans, DORMANT in SOLO). Toggle with the
`GStack role reviews` flag; each is gated by **Review autonomy**.

| Persona | Wears the hat at | What it checks | Prompt |
|---------|------------------|----------------|--------|
| **CEO** | Phase 0 vision · Track 1 Research | Is the scope right? the 10-star version? (four scope modes) | `OFFICE_HOURS_PROMPT.md`, `reviews/CEO_REVIEW_PROMPT.md` |
| **Eng Manager** | Track 1 Planning | Locks architecture, failure modes, test matrix | `reviews/ENG_REVIEW_PROMPT.md` |
| **Designer** (optional) | Track 1 Planning, UI only | 0–10 UI rubric, AI-slop check | `reviews/DESIGN_REVIEW_PROMPT.md` |
| **DevEx** (optional) | Track 1 Planning, CLI/API/SDK only | Developer-experience rubric: ergonomics, error messages, docs | `reviews/DEVEX_REVIEW_PROMPT.md` |
| **Staff Reviewer** | after Track 1 Implementation | Pre-merge bug audit + adversarial pass | `reviews/CODE_REVIEW_PROMPT.md` |
| **CSO** (optional) | Review step, security-relevant | OWASP + STRIDE, confidence-gated | `reviews/SECURITY_REVIEW_PROMPT.md` |
| **Release** | after Track 3 pass | Ship: plan-completion, scope-drift, PR | `SHIP_PROMPT.md` |
| **Historian** | Reflect | Retro + persisted learnings | `RETRO_PROMPT.md` |

Each persona surfaces findings for *your* approval under the Gate Behavior dial; none auto-applies
a Hard-Gate decision. The shared rubric primitives they all use live in `prompts/reviews/_SHARED.md`.
<!-- RPID:METHODOLOGY:GSTACK-ROLES v2.0 END -->

### Branching Hierarchy

```
main                              ← most stable version
  └── testing                     ← integration; phases merged here after close
        └── phase#                ← owned by collab_integrator
              └── username/phase#_task#   ← individual member task branches
```

- Each level only pulls from the one above it.
- Members branch from `phase#` — never from `testing` or `main` directly.
- `phase#` is deleted after merge. The permanent artifact is `docs/version1/phases/phase#/` — never delete that folder.
- **Branch naming:** `username/phase#_task[NN]_[slug]` — zero-padded two-digit task ID + slug.

### Golden Rules

1. **Task isolation** — each member only does tasks assigned in `PHASE#_MEMBER_TASK.md`.
2. **Doc isolation** — each member only writes docs in `docs/version1/phases/phase#/task#/`.
3. **No lost context** — all task-scoped RPID docs are permanent artifacts. Deleting any of them violates this rule.
4. **No outdated context** — changes must be reflected in documentation. Status stays current.
5. **RPID loop** — all work follows the four-track sequence. See below.
6. **Contract files** — shared contract files require collab_integrator coordination before any edit.

### RPID Loop

All tasks follow four sequential tracks. Each track is a complete R→P→I cycle run in its own
session. The user reviews and approves at every gate before the next session begins — **subject to
the Review-autonomy dial** (see Ethos → Gate Behavior; `full` stops at every gate, `auto` stops only
at Hard Gates). Steps marked `*` are GStack role reviews — on when `GStack role reviews` is **ON**,
and themselves gated by Review autonomy.

```
Track 1 — Feature:   R(init) → [CEO review*] → P(init) → [Eng review*, Design review* if UI] → I(init)
                       → [Code review*: pre-merge bug audit + adversarial pass]
Track 2 — Tests:     R(test) → P(test) → I(test)
                       (TEST_SETUP runs once if the project has no real test gate yet)
Track 3 — Run:       run tests locally + required CI check on the PR
                     ┌─ all pass → docs commit → [Ship*: plan-completion + scope-drift + PR]
                     │             → PR merged → [Reflect*: retro + persist learnings] → next task
                     └─ any fail → Track 4
Track 4 — Debug:     R(debug) → P(debug) → I(debug) → back to Track 3
  (the Iron Law)     no fix without investigation; escalate after two iterations without passing
```

**The GStack role steps (`*`)** are reviews, not new tracks — they produce findings for your
approval and never change the commit discipline below. Each runs only when relevant (e.g. Design
review only for UI work, Security review for security-relevant diffs) and obeys the autonomy dial.
A bare task can still run plain R→P→I; reach for the heavier hats on bigger or riskier work.

**CI test gate (Track 3):** the full suite also runs as a *required* GitHub Actions check on
every PR to `phase#`. A local pass with a red CI check is **not** a pass — the PR cannot merge
until CI is green. A stack-agnostic **skeleton ships at `.github/workflows/test.yml`**, but it
intentionally **fails until you replace its placeholder command** with your real suite — finish
it at phase 1 start (the runner + isolation choice is pre-registered as ADR-002 in `DECISIONS.md`;
stack-specific tooling lives in `profiles/`). The other shipped workflows, `claude.yml` (the `@claude` action),
`claude-code-review.yml` (auto-review), and `claude-issue-to-pr.yml` (label an issue `claude` →
Claude runs ISSUE_MODE autonomously and opens a PR — the feedback loop), don't run tests.

Each step has a copy-paste prompt in `prompts/`. Pick a **mode** first
(`prompts/modes/FEATURE_MODE.md`, `ISSUE_MODE.md`, or `OVERNIGHT_MODE.md`), then run the track
prompts as the mode directs.

**Commits per task — in order, never combined:**

| Commit | Track | Contains | Forbidden |
|--------|-------|----------|-----------|
| `impl: phase#_task#` | 1 | Feature code only | No test code, no doc changes |
| `test: phase#_task#` | 2 | Test code only | No feature code, no doc changes |
| `fix: phase#_task#_iter#` | 4 | Fix code only (repeating) | No test changes, no doc changes |
| `docs: phase#_task#` | 3 (after pass) | Malleable doc updates only | No code changes |

The `fix:` commit is absent if Track 3 passes on the first run. Every other commit is mandatory.

### RPID Prompt Library

`prompts/` has two layers: **modes** (entry points — pick one per task) and **track prompts**
(one session each). Bootstrap a blank repo with `prompts/PROJECT_INIT_PROMPT.md`.

| Mode (pick one per task) | When to use |
|--------------------------|-------------|
| `prompts/modes/FEATURE_MODE.md` | New feature; user reviews each gate (interactive) |
| `prompts/modes/ISSUE_MODE.md` | GitHub issue assigned to Claude; autonomous, no human gates |
| `prompts/modes/OVERNIGHT_MODE.md` | Multi-task list; autonomous with stronger guardrails |

| Track prompt | Track | Use |
|--------------|-------|-----|
| `RESEARCH_PROMPT.md` | 1 — R | Feature research |
| `PLANNING_PROMPT.md` | 1 — P | Feature planning |
| `IMPLEMENTATION_PROMPT.md` | 1 — I | Feature implementation |
| `TEST_RESEARCH_PROMPT.md` | 2 — R | Adversarial test research |
| `TEST_PLANNING_PROMPT.md` | 2 — P | Test-case planning |
| `TEST_IMPLEMENTATION_PROMPT.md` | 2 — I | Write test code |
| `TESTING_PROMPT.md` | 3 — Run | Run full suite + pass/fail decision |
| `DEBUG_RESEARCH_PROMPT.md` | 4 — R | Root-cause research |
| `DEBUG_PLANNING_PROMPT.md` | 4 — P | Fix planning |
| `DEBUG_IMPLEMENTATION_PROMPT.md` | 4 — I | Implement fix |
| `DOCUMENTATION_PROMPT.md` | After pass | Malleable doc updates + docs commit |

**Lifecycle prompts** (not part of the per-task R→P→I loop — run at project/phase boundaries):

| Lifecycle prompt | When to run |
|------------------|-------------|
| `PROJECT_INIT_PROMPT.md` | Once, to bootstrap a blank repo (Phase 0 vision interview + scaffold) |
| `SPEC_PROMPT.md` | Before Track 1, to turn a rough idea into a written spec |
| `OFFICE_HOURS_PROMPT.md` | Phase 0 / Track 1 Research — CEO-hat scope shaping |
| `TEST_SETUP_PROMPT.md` | Once, to stand up the CI test gate (resolves ADR-002) |
| `SHIP_PROMPT.md` | After Track 3 pass — plan-completion + scope-drift + PR |
| `RETRO_PROMPT.md` | After ship — retro + persisted learnings |
| `UPGRADE_TEMPLATE_PROMPT.md` | When a newer template version is available |

### Document Classification

**Non-malleable** (admin-only, repo root): `CLAUDE.md`, `README.md`, `MISSION.md`. No Claude
edits these unilaterally.

**Malleable** (high-level, `docs/version1/`): `STATUS.md`, `DECISIONS.md`, `ARCHITECTURE.md`,
`DATA_MODEL.md`, `PLANNING.md`, `EXPERIMENTS.md`, `FUTURE_IMPLEMENTATIONS.md`. Updated only
after implementation is committed, after announcing to collab_integrator, after all members
pull. These are the `docs:` commit targets.

**Phase-scoped** (`docs/version1/phases/phase#/`): `PHASE#_MEMBER_TASK.md` — admin-only edits.

**Task-scoped** (`docs/version1/phases/phase#/task#/`): all RPID docs (RESEARCH, PLANNING,
TEST_RESEARCH, TEST_PLAN, SESSION_LOG, DEBUG_RESEARCH, DEBUG_PLAN). Permanent artifacts —
each member writes only to their own task folder.

### Shared Contract Change Process

Shared contract files are code files multiple owners depend on (e.g. a shared config file, an
API/message type, a DB schema). List the frozen set for each phase in its
`PHASE#_MEMBER_TASK.md`. No member edits them unilaterally.

1. Member writes `REQUEST#_PHASE#_TASK#.md` in their task folder: what changes, why, how, and
   the **full impact on every other member's code** (every field/type others read).
2. Member sends it to the collab_integrator and marks it sent.
3. Collab_integrator applies the change to the `phase#` branch and announces it.
4. All members pull from `phase#` before continuing.
5. Each member manually checks their code against the impact section — semantic breakage
   (code reading a renamed field) will **not** surface as a git conflict.

### PHASE#_MEMBER_TASK.md Generation Process

Run at the start of each phase. Template: `docs/version1/phases/PHASE_MEMBER_TASK_TEMPLATE.md`.

1. **Claude separates tasks (no role assignment)** — reads `PLANNING.md`, lists every task for
   the phase by its numbered ID, and flags hybrid tasks (touching two ownership zones). Hybrid
   tasks split into sub-folders (`task#-[zoneA]/`, `task#-[zoneB]/`) and are listed as separate
   owned units.
2. **Admin discusses the split with the team** — decide the role split to avoid underutilization.
   _(SOLO: skip — you own every task.)_
3. **Admin assigns roles** — declares which member owns which tasks. _(SOLO: skip.)_
4. **Claude generates `PHASE#_MEMBER_TASK.md`** — member names, assigned tasks, ownership zones,
   branch names, and the frozen shared-contract file list.
5. **Admin reviews and locks** — admin is the only one who edits this file thereafter.

### Phase Lifecycle

| Event | Who | Action |
|-------|-----|--------|
| Phase 0 (vision) | Admin + Claude | Extensive vision-alignment interview on exactly what to build; log every uncertainty as an open ADR / open question — before any code |
| Phase start | Collab integrator | Creates `phase#` from `testing`; generates `PHASE#_MEMBER_TASK.md` |
| Task work | Member | Branches `username/phase#_task#`; follows RPID loop |
| Contract change needed | Member | Files `REQUEST#` doc; collab_integrator applies |
| Task complete | Member | Opens PR (`impl` + `docs` commits) to `phase#`; collab_integrator merges |
| Phase complete | Admin | All tasks checked off + sign-off; merge `phase#` → `testing`; create `phase#+1`; delete `phase#` branch (keep its docs folder) |

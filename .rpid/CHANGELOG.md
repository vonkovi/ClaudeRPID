# Template Changelog

Versions of the **RPID template itself** (not of any project built from it). A project records the
version it was instantiated from / last upgraded to in `.rpid/template.json` and
`docs/version1/STATUS.md`, and upgrades via `prompts/UPGRADE_TEMPLATE_PROMPT.md`.

**Semver:** MAJOR = breaking methodology (file renames, loop restructure → migration required) ·
MINOR = additive (new prompts/flags → drop-in) · PATCH = wording/fixes.

---

## 2.3.0 — Gap-audit fixes: init rewrite, issue-loop consistency, ownership completeness

Closes the v2.2 gap audit: every cross-file contradiction found is fixed, and each fixed drift
class gains a self-test so it cannot silently return.

- **`prompts/PROJECT_INIT_PROMPT.md` rewritten for the v2.x template.** It now *fills the shipped
  scaffold* instead of re-stating (stale) copies of it: a new STEP 0 detects
  template-instantiated vs blank repos (and offers `UPGRADE_TEMPLATE` instead of re-scaffolding),
  STEP 4 defers to the shipped `PHASE_MEMBER_TASK_TEMPLATE.md` (the old inline copy had the
  pre-2.0 two-commit discipline), STEP 5 fills `CLAUDE.md` placeholders and protects the
  methodology fences (the old inline spec scaffolded a fence-less v1 CLAUDE.md that upgrades
  couldn't touch), and a new STEP 7 finalizes what other docs always promised init does: rewrite
  `README.md`, verify `.rpid/template.json` + the `STATUS.md` `Template:` line, apply/defer the
  `profiles/` overlay, delete `START_HERE.md` and the template-repo-only files, and point at
  `.github/SETUP.md`.
- **Issue→PR loop consistency.** `ISSUE_MODE.md` and `claude-issue-to-pr.yml` now state the same
  base-branch rule: the open `phase[N]` branch if one exists, else the default branch (they
  previously contradicted each other).
- **`.rpid/OWNERSHIP.md`: new "Template-repo-only" category** — `MAINTAINING.md`, the
  `tests/check-*.sh` self-test suite, `template-check.yml`, and the README hero image are now
  classified (delete at instantiation, never re-added by upgrade). Dropped the ghost `TESTING.md`
  reference.
- **Self-test suite extended:** `check-version.sh` now also checks `MAINTAINING.md`'s version
  mention and that `CHANGELOG.md` has an entry for the current version; new `check-init.sh`
  guards the init-prompt wiring, the four-commit discipline in the member-task template, and the
  issue-loop base-branch agreement.
- Doc fixes: `START_HERE.md` now covers `.github/workflows/` + `profiles/` and the one-time
  GitHub wiring (`.github/SETUP.md`); CLAUDE.md's Repository Layout adds `profiles/`, `.github/`,
  `.rpid/`; `UPGRADE_TEMPLATE`'s undocumented `.rpid/baseline/` mention replaced with a concrete
  3-way-reconcile source; `image.png` moved to `.github/readme-hero.png`.

Additive — drop-in, no migration required.

## 2.2.0 — Template self-test suite + GitHub connection check

The template now guards its own integrity in CI, and ships a setup-time GitHub-plumbing check.

- **`tests/` + `.github/workflows/template-check.yml`** — the template's own Track 3 gate. The repo
  ships no code, so its tests are integrity checks: valid workflow YAML, resolvable cross-references,
  balanced `RPID:METHODOLOGY` fences, consistent version metadata. Run locally with
  `bash tests/run-all.sh`; add a `tests/check-*.sh` when you find a new drift class.
- **`.github/workflows/connection-check.yml` + `.github/SETUP.md`** — manual, zero-side-effect check
  that the GitHub↔Claude wiring (secret present, write permissions, pinned action refs) is correct,
  plus a manual smoke-test checklist for the parts a workflow can't prove (token validity, the live
  `@claude` / issue→PR loop).
- **`CLAUDE.md`** — new `## Testing` / `## Test Coverage` placeholder sections (filled by
  `TEST_SETUP`), stating that tests are organized by the `test.yml` CI gate, not a folder. Closes a
  latent inconsistency where `.rpid/OWNERSHIP.md` cited sections that didn't exist.
- **`MAINTAINING.md`** — new maintainer guide: disambiguates the three meanings of "test" and
  documents the self-test suite.
- Doc-integrity fixes now enforced by `check-*.sh`: `STATUS.md` `Template:` line; `SPEC`/`DevEx`
  prompt indexing in `CLAUDE.md`.

Additive — drop-in, no migration required.

## 2.1.0 — Autonomous GitHub issue → PR

Embeds GitHub triggers so the autonomous loop runs end to end — a real feedback loop.

- **`.github/workflows/claude-issue-to-pr.yml`** — label an issue `claude` and Claude runs
  `prompts/modes/ISSUE_MODE.md` autonomously (`Review autonomy = auto`): reproduce → fix (Iron Law)
  → tests → open a PR that closes the issue. Hard Gates post a comment on the issue instead of
  proceeding. One-line switch to run on every opened issue.
- **`claude.yml`** bumped to write permissions so `@claude` comments can push changes to a PR (the
  "user comes in and updates it" half of the loop), not just comment.
- The full loop: issue → PR (auto-reviewed by `claude-code-review.yml`) → you review / `@claude`
  iterate → merge.

Migration: `.rpid/migrations/2.0-to-2.1.md`.

## 2.0.0 — GStack integration

Folds Garry Tan's GStack methodology into the RPID loop as stack-agnostic, copy-paste prompts
(executable GStack tooling stays out of the base — see `profiles/`).

- **`## Ethos`** in `CLAUDE.md` — Boil the Lake · Search Before Building · User Sovereignty · The
  Golden Age · The Iron Law. Each tied to an existing RPID rule.
- **GStack role reviews** (hats Claude wears) in `prompts/reviews/`: CEO, Eng, Code (universal) +
  Security, Design, DevEx (optional), all sharing `prompts/reviews/_SHARED.md`.
- **Lifecycle prompts:** `OFFICE_HOURS`, `SHIP`, `RETRO`, `SPEC`, `TEST_SETUP`.
- **Review-autonomy dial** (`full` / `milestone` / `auto`) with a Hard-Gates safety floor.
- **Review + Ship + Reflect** stages wired into the loop; **Track 4 renamed the Iron Law**.
- **`TEST_SETUP`** bootstraps the CI test gate — resolves the long-standing ADR-002 placeholder.
- **Template versioning + self-link** (this system): `.rpid/` (version + ownership + changelog +
  migrations) and `UPGRADE_TEMPLATE`, with session-start "you're outdated" detection.
- Tool-bound GStack execution (browser QA, deploy, cross-model) documented as `profiles/` overlays.

Migration: `.rpid/migrations/1.x-to-2.0.md`.

## 1.x — RPID base

The original RPID template: the Research → Plan → Implement → Debug loop, the living-docs backbone,
commit discipline, solo/team modes, and the copy-paste prompt library.

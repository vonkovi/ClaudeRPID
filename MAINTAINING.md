# MAINTAINING.md — working ON the RPID template

> For a future Claude Code session opened in **this** repository. If you are in a project that was
> *built from* this template, ignore this file — it does not apply to you.

## What this repo is

This repository **is the RPID template itself** (`rpid`, currently `2.3.0` — see
`.rpid/template.json`). It is the *source product* that gets copied into other repos as a starting
scaffold. **It is not a project built from the template.** That one fact reframes everything below.

The consequence that trips up a fresh session: **`CLAUDE.md`, `README.md`, and `docs/version1/*`
are the artifact you are shipping, not the operating docs of a live project.**

- The `{{PLACEHOLDER}}` tokens in `CLAUDE.md` and the docs are **intentional** — they are the blanks
  a downstream user fills in. **Do not "fill them in," scaffold, or run `PROJECT_INIT` here.** The
  placeholder-integrity rule inside `CLAUDE.md` is addressed to *downstream consumers*, not to you.
- `docs/version1/STATUS.md` etc. are **specimens** of the doc backbone, not this repo's real status.
  Don't read them as "where the work is."
- `README.md` and `START_HERE.md` are written for the downstream user. `START_HERE.md` is meant to be
  deleted *by them* after instantiation.

## There is no code, build, or test toolchain

`src/.gitkeep` is empty by design. There is **no** language, build, lint, or test command in this
repo — the entire deliverable is **Markdown** (`prompts/`, `docs/version1/` specimens, and the
`.github/workflows/` skeletons). `.github/workflows/test.yml` intentionally *fails* until a
downstream project replaces its placeholder command. Don't go looking for a test runner to make
green; there isn't one here.

## How the template is structured (what you actually edit)

| Area | What it is |
|------|-----------|
| `prompts/**` | The RPID prompt library: `modes/` (entry points), per-track prompts, lifecycle prompts, and `reviews/` (GStack role rubrics sharing `_SHARED.md`). The bulk of real edits land here. |
| `CLAUDE.md` | The shipped operating manual. Mixes **template-owned** methodology (inside `<!-- RPID:METHODOLOGY:* START/END -->` fences) with **project-owned** blanks. Edit methodology *inside* the fences. |
| `docs/version1/**` | Specimen doc backbone + phase/task scaffolding templates. |
| `profiles/` | Opt-in stack overlays (test runner, CI, isolation) a downstream user picks at init. |
| `.github/workflows/` | Skeletons: `claude.yml`, `claude-code-review.yml`, `claude-issue-to-pr.yml`, `test.yml`. |
| `.rpid/` | Template self-metadata — see below. The version lives here, not in `package.json`. |

## The two rules that matter most when editing

1. **Respect `.rpid/OWNERSHIP.md`.** It declares which files the template *owns* (safe for a
   downstream upgrade to overwrite) vs which a downstream *project* owns (never overwritten). When
   you change something, stay consistent with its ownership classification — especially the
   `CLAUDE.md` methodology fences, which are the *only* part of `CLAUDE.md` an upgrade swaps.

2. **Anything you add to `CLAUDE.md` (or any shipped file) is copied into every downstream project.**
   Don't put template-maintainer notes inside the shipped product — that's why this file exists.

## Releasing a template change (version bump)

The version is single-sourced in **`.rpid/template.json`** (`version` field). When a change is
user-visible, bump it under semver as defined in `.rpid/CHANGELOG.md`:

- **MAJOR** — breaking methodology (file renames, loop restructure) → **write a migration note** in
  `.rpid/migrations/<old>-to-<new>.md`.
- **MINOR** — additive (new prompt, new flag) → drop-in, no migration required.
- **PATCH** — wording/fixes.

Every bump touches, at minimum: `.rpid/template.json` (`version`), `.rpid/CHANGELOG.md` (a new
entry), and — for MAJOR — a `.rpid/migrations/` note. The methodology-fence version tags in
`CLAUDE.md` (e.g. `RPID:METHODOLOGY:ETHOS v2.0`) should track the version that last changed that
block.

## The three things called "test" (read before touching anything test-related)

The word "test" does three unrelated jobs in this repo. Confusing them is the single biggest
source of "where do tests go?" churn.

| "Test" | What it means | Where the files live | The gate (organizer) |
|--------|---------------|----------------------|----------------------|
| **Downstream code tests** | A project *built from* the template tests its own code | a stack dir (`tests/`, beside source, `__tests__/`…), decided at `TEST_SETUP` | `.github/workflows/test.yml` — a **placeholder** in this repo |
| **Template self-tests** | *This* repo verifies its own integrity (it has no code) | `tests/check-*.sh` | `.github/workflows/template-check.yml` |
| **GitHub connection check** | Validates the GitHub↔Claude plumbing (secret, permissions, action refs) | `.github/workflows/connection-check.yml` + `.github/SETUP.md` | manual (`workflow_dispatch`) |

The unifying rule: **tests are organized by the GitHub Action that runs them, not by a directory.**
The folder only holds files; the workflow is the authority and the required check.

## Testing the template itself

This repo ships no code, so its only possible tests are GitHub Actions. The suite lives in `tests/`
as shell checks, run by `template-check.yml` (and locally via `bash tests/run-all.sh`):

- `check-workflows.sh` — shipped workflows exist; all workflow YAML parses
- `check-links.sh` — every path-qualified file reference in the Markdown resolves
- `check-fences.sh` — `RPID:METHODOLOGY:*` fences are balanced (UPGRADE depends on this)
- `check-version.sh` — `.rpid/template.json`, `STATUS.md`, and `MAINTAINING.md` agree on the
  version, and `CHANGELOG.md` has an entry for it
- `check-init.sh` — `PROJECT_INIT` references the shipped files it finalizes (no inline forks);
  `ISSUE_MODE` and `claude-issue-to-pr.yml` agree on the base-branch rule

They exist to catch — automatically — the drift class that used to be caught only by hand
(orphaned prompts, a missing `Template:` line, an ownership map citing a section that doesn't
exist). **Find a new drift class → add a `check-*.sh`;** `run-all.sh` picks it up. `test.yml` is
deliberately *not* the template's gate — it stays the failing placeholder downstream projects fill.

## Convention notes

- Meta-docs at the repo root and in `.rpid/` use **UPPERCASE** names (`README.md`, `OWNERSHIP.md`,
  `CHANGELOG.md`) — match that when adding siblings.
- This repo *dogfoods* its own commit discipline where it makes sense (`docs:`, `feat(...)`,
  `refactor(...)` — see `git log`), but since there's no code/test split, the strict
  `impl:`/`test:`/`fix:`/`docs:` task sequence from the methodology does not literally apply to
  template edits. Use conventional-commit prefixes that describe the actual change.

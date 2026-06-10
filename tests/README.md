# tests/ — the template's self-test suite

This repo ships **no application code**, so it cannot have stack tests. Its "tests" are
**integrity checks on the template itself**, written as small shell scripts and run by the
`.github/workflows/template-check.yml` GitHub Action — the template's own Track 3 gate.

> The organizing principle, for both this repo and any project built from it: **tests are
> organized by the GitHub Action that runs them, not by a directory.** The folder just holds
> the files; the workflow is the authority and the required check. Here that workflow is
> `template-check.yml`; in a downstream project it's `test.yml`.

## Run it

```bash
bash tests/run-all.sh        # runs every check-*.sh, aggregates failures
bash tests/check-links.sh    # or run one in isolation
```

Same command runs in CI. Each check prints `::error::` annotations that GitHub Actions surfaces.

## The checks

| Script | Asserts | Drift it catches |
|--------|---------|------------------|
| `check-workflows.sh` | shipped workflows exist; all workflow YAML parses | a typo that breaks a workflow; a deleted workflow |
| `check-links.sh` | every path-qualified file reference in the Markdown resolves | orphaned/renamed prompts, dead doc links |
| `check-fences.sh` | `RPID:METHODOLOGY:*` fences balance in `CLAUDE.md` | a half-deleted fence that would corrupt an upgrade |
| `check-version.sh` | `.rpid/template.json`, `STATUS.md`, and `MAINTAINING.md` agree on the version; `CHANGELOG.md` has an entry for it | a version bump applied to only some sources of truth |
| `check-init.sh` | `PROJECT_INIT_PROMPT.md` references every shipped file it fills/cleans up; the member-task template carries the 4-commit discipline; `ISSUE_MODE` and `claude-issue-to-pr.yml` state the same base-branch rule | an init prompt inlining (and rotting) copies of shipped content; the loop's two halves contradicting each other |

These exist because the drift class they guard (a missing `STATUS.md` `Template:` line, an
ownership map citing a section that doesn't exist, an orphaned prompt) was previously caught only
by hand. **When you find a new drift class, add a `check-*.sh` for it** — `run-all.sh` picks it
up automatically.

`.github/workflows/test.yml` is deliberately NOT this gate: it's the stack-agnostic placeholder a
downstream project fills with its real suite. See `MAINTAINING.md` for the full picture.

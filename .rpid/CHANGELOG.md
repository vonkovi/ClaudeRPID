# Template Changelog

Versions of the **RPID template itself** (not of any project built from it). A project records the
version it was instantiated from / last upgraded to in `.rpid/template.json` and
`docs/version1/STATUS.md`, and upgrades via `prompts/UPGRADE_TEMPLATE_PROMPT.md`.

**Semver:** MAJOR = breaking methodology (file renames, loop restructure → migration required) ·
MINOR = additive (new prompts/flags → drop-in) · PATCH = wording/fixes.

---

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

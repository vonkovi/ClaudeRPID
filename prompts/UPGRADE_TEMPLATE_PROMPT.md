# Upgrade Template

**Role:** migrate this project from the template version it's on to a newer one — updating **only
template-owned files** and never touching project content.

**When:** the session-start check (or running init in an existing project) reports the template is
behind, or the user asks to upgrade. Obeys the **Review-autonomy** dial; every change is described
*before* it's applied. A semantic/conflicting step is a **Hard Gate** — always stops, even in `auto`.

**Output:** the project moved to the new template version, with a diff that touches only
template-owned paths.

**Follow `prompts/reviews/_SHARED.md`** — decision briefs, Gate Behavior, completion status.

---

## Step 1 — read versions (where am I, what's latest)

- **This project's version:** `.rpid/template.json` → `version` (or the `Template: rpid@X` line in
  `docs/version1/STATUS.md`). If neither exists, the project predates versioning → **fingerprint**
  it (does it have `prompts/`, `docs/version1/`, an RPID-shaped `CLAUDE.md`?) and treat it as the
  pre-v2 baseline.
- **Latest version:** from the template source (`.rpid/template.json` → `source` → that repo's
  `.rpid/template.json` → `version`), or a local template clone the user points to. **Offline /
  source unreachable → stop with a clear note; never guess a version.**
- If already current → "Already on rpid@<version>. Nothing to do." and stop.

## Step 2 — present the update brief (before any change)

Read the relevant `.rpid/migrations/<from>-to-<to>.md`. Show the user, in plain English:
1. **What's new & why you'd want it.**
2. **Breaking / semantic changes** that need their input.
3. **The categorized change plan:** N drop-in · M replace (incl. fenced CLAUDE.md regions) · K
   manual steps.
4. **What stays untouched:** their `docs/version1/*`, `src/**`, filled `CLAUDE.md` sections.

Ask to proceed (gated by Review autonomy). For multi-version jumps, apply each migration note in
order.

## Step 3 — apply, by ownership (`.rpid/ownership.md`)

- **Drop-in** files → add them.
- **Replace** template-owned files and **fenced** `CLAUDE.md` regions → swap **only** those. For
  `CLAUDE.md`, replace only each `<!-- RPID:METHODOLOGY:NAME START -->`…`END -->` block; leave
  everything outside the fences. If a target file was locally customized, do a 3-way reconcile
  (against `.rpid/baseline/` if the project keeps one) and surface each conflict as a decision.
- **Project-owned** files → never touch.
- **Manual** steps → walk them one at a time (Hard Gates — always ask).

## Step 4 — finalize

- Bump `.rpid/template.json` `version` and the `Template: rpid@X` line in `STATUS.md` to the new
  version.
- Log the upgrade in `docs/version1/DECISIONS.md` (or the STATUS Learnings list): from → to, date,
  anything reconciled.
- **Verify:** `git diff --name-only` shows only template-owned paths; project content untouched.

End with a completion status (DONE / DONE_WITH_CONCERNS / BLOCKED).

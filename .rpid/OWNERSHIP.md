# Template Ownership Map (`.rpid/OWNERSHIP.md`)

Which files the **template** owns (safe to upgrade) vs which the **project** owns (never
overwritten on upgrade). `prompts/UPGRADE_TEMPLATE_PROMPT.md` obeys this map.

## Template-owned (upgradeable)

- `prompts/**` — the whole prompt library (modes, track prompts, `reviews/`, lifecycle prompts)
- `profiles/**` — overlay scaffolding and its README
- `.github/workflows/*.yml` — skeletons (the real test command you fill via `TEST_SETUP` is yours,
  see below)
- `CLAUDE.md` — **only** the fenced methodology regions (`<!-- RPID:METHODOLOGY:* START/END -->`)
- `START_HERE.md`, `docs/version1/phases/PHASE_MEMBER_TASK_TEMPLATE.md` — doc templates
- `.rpid/OWNERSHIP.md`, `.rpid/CHANGELOG.md`, `.rpid/migrations/**`, and the `version` field of
  `.rpid/template.json` — template metadata

## Project-owned (NEVER overwrite)

- `docs/version1/{STATUS,DECISIONS,ARCHITECTURE,DATA_MODEL,PLANNING,EXPERIMENTS,FUTURE_IMPLEMENTATIONS}.md`
  — their content
- `docs/version1/phases/**` generated phase/task docs — permanent artifacts
- `src/**` and any code root
- `MISSION.md`, `README.md` once filled for the project
- `CLAUDE.md` **outside** the methodology fences — incl. Project, North Star, filled sections, the
  Build/Run commands, `## Testing`, `## Test Coverage`
- `TESTING.md`, project config files
- `.rpid/template.json` `source` (only `version` is template-managed)

## Mixed-file rule

`CLAUDE.md` mixes both. On upgrade, swap **only** the `<!-- RPID:METHODOLOGY:NAME START -->`…`END`
blocks; leave everything outside the fences untouched. If a fence is missing (a project that
predates v2.0), the migration note's Manual section walks the user through adding it before the swap.

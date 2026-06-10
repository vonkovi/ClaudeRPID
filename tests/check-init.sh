#!/usr/bin/env bash
# PROJECT_INIT must stay wired to the shipped files (referencing them, never inlining copies
# that rot), and the autonomous issue->PR pair must agree on the base-branch rule.
# Drift this catches: the v2.2-era class where PROJECT_INIT restated a stale CLAUDE.md spec
# and a 2-commit task block that contradicted the shipped 4-commit discipline.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 2

rc=0
INIT=prompts/PROJECT_INIT_PROMPT.md

require() { # file token why
  if ! grep -qF -- "$2" "$1"; then
    echo "::error file=$1::missing required reference '$2' ($3)"
    rc=1
  fi
}

# the init prompt must reference every shipped artifact it fills, finalizes, or cleans up
require "$INIT" '.rpid/template.json'           'template self-link verified at init'
require "$INIT" 'Template: rpid@'               'STATUS.md template line verified at init'
require "$INIT" 'UPGRADE_TEMPLATE_PROMPT.md'    'offers upgrade instead of re-scaffolding'
require "$INIT" 'PHASE_MEMBER_TASK_TEMPLATE.md' 'defers to the shipped template, no inline fork'
require "$INIT" 'RPID:METHODOLOGY'              'protects the CLAUDE.md methodology fences'
require "$INIT" 'START_HERE.md'                 'cleanup: delete after init'
require "$INIT" 'profiles/README.md'            'profile overlay pick-and-delete step'
require "$INIT" 'template-check.yml'            'cleanup: template-repo-only files'
require "$INIT" 'MAINTAINING.md'                'cleanup: template-repo-only files'
require "$INIT" 'TEST_SETUP_PROMPT.md'          'test gate deferred to TEST_SETUP, never invented'
require "$INIT" '.github/SETUP.md'              'points the user at the GitHub wiring guide'

# the shipped member-task template carries the full four-commit discipline
for c in 'impl:' 'test:' 'fix:' 'docs:'; do
  require docs/version1/phases/PHASE_MEMBER_TASK_TEMPLATE.md "$c" 'four-commit discipline'
done

# ISSUE_MODE and the issue->PR workflow must state the same base-branch fallback
for f in prompts/modes/ISSUE_MODE.md .github/workflows/claude-issue-to-pr.yml; do
  require "$f" 'else the default branch' 'shared base-branch rule (open phase branch, else default)'
done

[ "$rc" -eq 0 ] && echo "init prompt + issue loop wiring consistent"
exit $rc

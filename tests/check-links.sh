#!/usr/bin/env bash
# Cross-reference integrity: every path-qualified reference (one containing a '/') to a
# prompts|docs|profiles|.github|.rpid|tests file in the Markdown must resolve to a real file.
#
# Bare filenames (no '/') are intentionally NOT checked -- some name downstream-created
# artifacts (e.g. TESTING.md) that don't exist in the template by design. Paths containing
# placeholder syntax ([N], #, {{ }}, *) never match the regex, so specimens are safe.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 2

rc=0
re='(prompts|docs|profiles|\.github|\.rpid|tests)/[A-Za-z0-9_./-]+\.(md|yml|yaml|json)'
refs=$(git ls-files '*.md' | xargs grep -hoE "$re" 2>/dev/null | sort -u)

while IFS= read -r p; do
  [ -z "$p" ] && continue
  if [ ! -e "$p" ]; then
    echo "::error::broken reference: '$p' is mentioned in Markdown but does not exist"
    rc=1
  fi
done <<< "$refs"

[ "$rc" -eq 0 ] && echo "all $(printf '%s\n' "$refs" | grep -c .) path references resolve"
exit $rc

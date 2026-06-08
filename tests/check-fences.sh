#!/usr/bin/env bash
# Methodology fences in CLAUDE.md must balance: every RPID:METHODOLOGY:<NAME> <ver> START
# needs a matching END. UPGRADE_TEMPLATE swaps content between these fences, so an unbalanced
# pair would silently corrupt an upgrade.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 2

file="CLAUDE.md"
rc=0

starts=$(grep -oE 'RPID:METHODOLOGY:[A-Z-]+ [^ ]+ START' "$file" | sed -E 's/ START$//' | sort)
ends=$(grep -oE 'RPID:METHODOLOGY:[A-Z-]+ [^ ]+ END' "$file" | sed -E 's/ END$//' | sort)

if [ "$starts" != "$ends" ]; then
  echo "::error file=$file::methodology fences are unbalanced (every START needs a matching END)"
  echo "--- START markers ---"; printf '%s\n' "$starts"
  echo "--- END markers ---";   printf '%s\n' "$ends"
  rc=1
else
  echo "methodology fences balanced ($(printf '%s\n' "$starts" | grep -c .) pairs)"
fi
exit $rc

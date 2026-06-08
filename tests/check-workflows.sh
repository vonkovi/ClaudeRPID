#!/usr/bin/env bash
# Every shipped workflow exists, and every .github/workflows/*.yml is valid YAML.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 2

rc=0

for f in claude.yml claude-issue-to-pr.yml claude-code-review.yml test.yml template-check.yml connection-check.yml; do
  if [ ! -f ".github/workflows/$f" ]; then
    echo "::error file=.github/workflows/$f::required workflow missing"
    rc=1
  fi
done

if command -v python3 >/dev/null 2>&1 && python3 -c "import yaml" >/dev/null 2>&1; then
  for f in .github/workflows/*.yml; do
    if ! python3 -c "import sys,yaml; yaml.safe_load(open(sys.argv[1]))" "$f" >/dev/null 2>&1; then
      echo "::error file=$f::invalid YAML"
      rc=1
    fi
  done
else
  echo "::warning::python3+PyYAML unavailable here; YAML parse validation skipped (it runs in CI)"
fi

[ "$rc" -eq 0 ] && echo "workflows OK"
exit $rc

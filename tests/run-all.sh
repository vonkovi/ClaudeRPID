#!/usr/bin/env bash
# Template self-test suite runner.
#
# This repo ships no application code, so its "tests" are integrity checks on the template
# itself. Each tests/check-*.sh exits 0 on pass, non-zero on fail, and prints ::error::
# annotations (which GitHub Actions surfaces inline). Run identically in CI (template-check.yml)
# and locally:  bash tests/run-all.sh
set -uo pipefail
cd "$(dirname "$0")/.." || exit 2

fail=0
for check in tests/check-*.sh; do
  echo "=== $check ==="
  if bash "$check"; then
    echo "PASS: $check"
  else
    echo "FAIL: $check"
    fail=1
  fi
  echo
done

if [ "$fail" -ne 0 ]; then
  echo "Template self-test suite: FAILED"
  exit 1
fi
echo "Template self-test suite: all checks passed"

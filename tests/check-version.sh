#!/usr/bin/env bash
# The template version must agree across its sources of truth:
#   .rpid/template.json ("version"), docs/version1/STATUS.md ("Template: rpid@X.Y.Z"),
#   MAINTAINING.md ("currently `X.Y.Z`") — and .rpid/CHANGELOG.md must have an entry for it.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 2

rc=0
json_ver=$(grep -oE '"version"[[:space:]]*:[[:space:]]*"[^"]+"' .rpid/template.json | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
status_ver=$(grep -oE 'Template: rpid@[0-9]+\.[0-9]+\.[0-9]+' docs/version1/STATUS.md | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
maint_ver=$(grep -oE 'currently `[0-9]+\.[0-9]+\.[0-9]+`' MAINTAINING.md | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)

if [ -z "$json_ver" ]; then
  echo "::error file=.rpid/template.json::could not read a semver 'version'"
  rc=1
fi
if [ -z "$status_ver" ]; then
  echo "::error file=docs/version1/STATUS.md::missing a 'Template: rpid@X.Y.Z' line"
  rc=1
fi
if [ -n "$json_ver" ] && [ -n "$status_ver" ] && [ "$json_ver" != "$status_ver" ]; then
  echo "::error::version mismatch: template.json=$json_ver but STATUS.md=$status_ver"
  rc=1
fi
if [ -z "$maint_ver" ]; then
  echo "::error file=MAINTAINING.md::missing a 'currently \`X.Y.Z\`' version mention"
  rc=1
elif [ -n "$json_ver" ] && [ "$json_ver" != "$maint_ver" ]; then
  echo "::error::version mismatch: template.json=$json_ver but MAINTAINING.md says $maint_ver"
  rc=1
fi
if [ -n "$json_ver" ] && ! grep -qE "^## ${json_ver//./\\.}( |$)" .rpid/CHANGELOG.md; then
  echo "::error file=.rpid/CHANGELOG.md::no entry for current version $json_ver"
  rc=1
fi

[ "$rc" -eq 0 ] && echo "version consistent: rpid@$json_ver"
exit $rc

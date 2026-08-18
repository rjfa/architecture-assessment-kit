#!/usr/bin/env bash
set -euo pipefail
test -f README.md
test -f templates/03-risk-register.md
test -f docs/example/assessment.md
test -f docs/example/adr/ADR-001-incremental-modernization.md
if rg -n "TODO|TBD" docs/example; then
  echo "Unresolved placeholder in completed example" >&2
  exit 1
fi
echo "Architecture Assessment Kit: validation passed"

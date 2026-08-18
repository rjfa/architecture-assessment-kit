#!/usr/bin/env bash
set -euo pipefail

if ! command -v pwsh >/dev/null 2>&1; then
  echo "pwsh is required to run validation. Install PowerShell 7+ and retry." >&2
  exit 1
fi

pwsh -NoLogo -NoProfile -File "$(dirname "$0")/validate.ps1"

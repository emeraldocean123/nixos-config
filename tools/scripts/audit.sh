#!/usr/bin/env bash
set -euo pipefail
here=$(cd "$(dirname "$0")/.." && pwd)
cd "$here"

echo "[audit] Running cleanup-all (fix pass) ..."
bash "$here/scripts/cleanup-all.sh"

echo "[audit] Generating statix detailed report ..."
bash "$here/scripts/statix-report.sh"

echo "[audit] Done. Latest files:"
ls -1t "$here/logs" | head -n 6

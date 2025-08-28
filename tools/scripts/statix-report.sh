#!/usr/bin/env bash
set -euo pipefail

here=$(cd "$(dirname "$0")/.." && pwd)
mkdir -p "$here/logs"
ts=$(date +%F_%H%M%S)
out="$here/logs/statix_report_${ts}.txt"

if [ "$#" -eq 0 ]; then
  set -- ../dotfiles ../nixos-config
fi

{
  echo "== statix detailed report =="
  echo "Timestamp: $ts"
  echo "Repos: $*"
  echo
} > "$out"

for repo in "$@"; do
  if [ ! -d "$repo/.git" ]; then continue; fi
  echo "== $repo ==" >> "$out"
  # Prefer JSON if available in your statix; otherwise plain output
  if statix --help 2>&1 | grep -q -- '--format'; then
    statix check --format full "$repo" >> "$out" 2>&1 || true
  else
    statix check "$repo" >> "$out" 2>&1 || true
  fi
  echo >> "$out"
done

echo "Report written: $out"

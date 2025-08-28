#!/usr/bin/env bash
set -euo pipefail

here=$(cd "$(dirname "$0")/.." && pwd)
mkdir -p "$here/logs"
ts=$(date +%F_%H%M%S)
log="$here/logs/run_${ts}.log"
errlog="$here/logs/errors_${ts}.log"

if [ "$#" -eq 0 ]; then
  set -- ../bmad-method ../bookmark-cleaner ../docs ../dotfiles ../nixos-config
  echo "No repos provided; using defaults: $*" | tee -a "$log"
fi

{
  echo "== Nix local tools run =="
  echo "Timestamp: $ts"
  echo "Working dir: $here"
  echo "Repos: $*"
  echo
} | tee -a "$log"

# Hint if tools are missing
if ! command -v statix >/dev/null 2>&1 || ! command -v treefmt >/dev/null 2>&1; then
  echo "[hint] statix/treefmt not on PATH. Run inside 'nix develop' in $here for tools to be available." | tee -a "$log"
fi

status_summary=()

for repo in "$@"; do
  if [ ! -d "$repo/.git" ]; then
    echo "Skipping $repo (not a git repo)" | tee -a "$log"
    continue
  fi
  echo "==> Processing $repo" | tee -a "$log"
  # Copy configs into repo if missing
  for f in treefmt.toml pre-commit-config.yaml justfile; do
    if [ ! -e "$repo/$f" ]; then
      cp -v "$here/$f" "$repo/" | tee -a "$log"
    fi
  done
  mkdir -p "$repo/scripts"
  [ -e "$repo/scripts/ai-fix.sh" ] || cp -v "$here/scripts/ai-fix.sh" "$repo/scripts/" | tee -a "$log"
  [ -e "$repo/scripts/deadnix-fix.sh" ] || cp -v "$here/scripts/deadnix-fix.sh" "$repo/scripts/" | tee -a "$log"

  # Run tools and capture outputs
  repo_ok=true
  {
    echo "-- statix --"
    (cd "$repo" && statix fix) || { (cd "$repo" && statix check || true); repo_ok=false; }
    echo
    echo "-- deadnix --"
    (cd "$repo" && ./scripts/deadnix-fix.sh) || repo_ok=false
    echo
    echo "-- treefmt --"
    (cd "$repo" && treefmt) || repo_ok=false
    echo
    echo "-- git status --"
    git -C "$repo" status -s || true
    echo
  } 2>&1 | tee -a "$log"

  status_summary+=("$repo: $([ "$repo_ok" = true ] && echo OK || echo CHECK)")
done

# Build error-focused view
{
  echo "== Error/Warning summary (grep-driven) =="
  echo "From: $log"
  echo
  grep -Eni "\b(error|failed|unused|warning)\b|statix|deadnix" "$log" || echo "No matching warnings/errors found."
  echo
  echo "== Per-repo status =="
  for s in "${status_summary[@]}"; do echo "$s"; done
} > "$errlog"

echo "All done."
echo "Logs written:"
echo "  $log"
echo "  $errlog (errors/warnings view)"

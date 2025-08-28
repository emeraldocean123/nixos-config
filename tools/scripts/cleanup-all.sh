#!/usr/bin/env bash
set -euo pipefail

here=$(cd "$(dirname "$0")/.." && pwd)
mkdir -p "$here/logs"
ts=$(date +%F_%H%M%S)
log="$here/logs/cleanup_${ts}.log"
errlog="$here/logs/cleanup_errors_${ts}.log"

if [ "$#" -eq 0 ]; then
  set -- ../bmad-method ../bookmark-cleaner ../docs ../dotfiles ../nixos-config
  echo "No repos provided; using defaults: $*" | tee -a "$log"
fi

{
  echo "== Nix local cleanup run =="
  echo "Timestamp: $ts"
  echo "Working dir: $here"
  echo "Repos: $*"
  echo
} | tee -a "$log"

if ! command -v statix >/dev/null 2>&1 || ! command -v treefmt >/dev/null 2>&1 || ! command -v nix >/dev/null 2>&1; then
  echo "[hint] Tools not on PATH. Run inside 'nix develop' in $here for tools to be available." | tee -a "$log"
fi

status_summary=()

for repo in "$@"; do
  if [ ! -d "$repo/.git" ]; then
    echo "Skipping $repo (not a git repo)" | tee -a "$log"
    continue
  fi
  echo "==> Processing $repo" | tee -a "$log"

  # Ensure configs exist
  for f in treefmt.toml pre-commit-config.yaml justfile .statix.toml; do
    [ -e "$repo/$f" ] || cp -v "$here/$f" "$repo/" | tee -a "$log"
  done
  mkdir -p "$repo/scripts"
  [ -e "$repo/scripts/deadnix-fix.sh" ] || cp -v "$here/scripts/deadnix-fix.sh" "$repo/scripts/" | tee -a "$log"
  # Attempt pre-commit install if available (best-effort)
  if ! command -v pre-commit >/dev/null 2>&1; then
    python3 -m pip install --user pre-commit >/dev/null 2>&1 || true
  fi
  (cd "$repo" && pre-commit install -f >/dev/null 2>&1) || true

  repo_ok=true
  {
    echo "-- statix fix --"
    (cd "$repo" && statix fix) || { (cd "$repo" && statix check || true); repo_ok=false; }
    echo
    echo "-- deadnix JSON and underscore/remove pass --"
    # Run deadnix JSON (no excludes to avoid CLI incompatibility) and apply underscore/remove fixes
    (cd "$repo" && NO_COLOR=1 deadnix -o json . | python3 "$here/scripts/underscore-or-remove-unused.py") || true
    # Fallback to editing with latest deadnix if python3 is unavailable
    if ! command -v python3 >/dev/null 2>&1; then
      (cd "$repo" && NO_COLOR=1 nix --extra-experimental-features 'nix-command flakes' run nixpkgs#deadnix -- --edit) || true
    fi
    echo
    echo "-- treefmt --"
    (cd "$repo" && treefmt) || repo_ok=false
    echo
    echo "-- git status before commit --"
    git -C "$repo" status -s || true
    echo
  } 2>&1 | tee -a "$log"

  # Commit if there are changes
  if [ -n "$(git -C "$repo" status --porcelain)" ]; then
    (
      cd "$repo"
      git add -A
      GIT_AUTHOR_NAME=${GIT_AUTHOR_NAME:-"joseph"} \
      GIT_AUTHOR_EMAIL=${GIT_AUTHOR_EMAIL:-"joseph@users.noreply.github.com"} \
      GIT_COMMITTER_NAME=${GIT_COMMITTER_NAME:-"joseph"} \
      GIT_COMMITTER_EMAIL=${GIT_COMMITTER_EMAIL:-"joseph@users.noreply.github.com"} \
      git commit -m "chore(nix): format (treefmt), lint (statix), cleanup (deadnix --remove)"
    ) | tee -a "$log" || repo_ok=false
  fi

  echo "-- git status after commit --" | tee -a "$log"
  git -C "$repo" status -s | tee -a "$log" || true
  echo | tee -a "$log"

  status_summary+=("$repo: $([ "$repo_ok" = true ] && echo OK || echo CHECK)")
done

# Build error-focused view and remaining warnings summary
{
  echo "== Error/Warning summary (grep-driven) =="
  echo "From: $log"
  echo
  grep -Eni "\b(error|failed|unused|warning)\b|statix|deadnix" "$log" || echo "No matching warnings/errors found."
  echo
  echo "== Per-repo status =="
  for s in "${status_summary[@]}"; do echo "$s"; done
} > "$errlog"

# Per-repo remaining warnings quick count
remain="$here/logs/remaining_${ts}.txt"
{
  echo "Remaining warnings (quick count)"
  for repo in "$@"; do
    [ -d "$repo/.git" ] || continue
    EXCL=(node_modules .direnv .git result dist build)
    EXARGS=(); for e in "${EXCL[@]}"; do EXARGS+=(--exclude "$e"); done
    cd "$repo"
    dcount=$(NO_COLOR=1 deadnix -o json . "${EXARGS[@]}" 2>/dev/null | grep -c '"message"' || true)
    scount=$(statix check 2>/dev/null | wc -l || echo 0)
    cd - >/dev/null
    printf "%s\n  deadnix messages: %s\n  statix lines: %s\n\n" "$repo" "$dcount" "$scount"
  done
} > "$remain"

echo "All done."
echo "Logs written:"
echo "  $log"
echo "  $errlog (errors/warnings view)"
echo "  $remain (remaining warnings quick count)"

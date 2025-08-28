#!/usr/bin/env bash
set -euo pipefail
here=$(cd "$(dirname "$0")/.." && pwd)
shopt -s nullglob
logs=("$here/logs/run_"*.log)
errs=("$here/logs/errors_"*.log)
if [ ${#logs[@]} -eq 0 ]; then
  echo "No logs found in $here/logs" >&2
  exit 1
fi
last_log=${logs[-1]}
last_err=${errs[-1]:-}
echo "Last full log: $last_log"
[ -n "${last_err:-}" ] && echo "Last errors summary: $last_err" || echo "No error summary found."
echo
echo "--- Errors summary (if any) ---"
[ -n "${last_err:-}" ] && sed -n '1,200p' "$last_err" || echo "(none)"
echo
echo "--- Tail of full log ---"
tail -n 200 "$last_log"


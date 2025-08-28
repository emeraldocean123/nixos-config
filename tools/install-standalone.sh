#!/usr/bin/env bash
set -euo pipefail

# Install standalone binaries of alejandra, statix, deadnix, treefmt into ./bin without Nix
DIR=$(cd "$(dirname "$0")" && pwd)
BIN_DIR="$DIR/bin"
mkdir -p "$BIN_DIR"

py() { python3 - "$@"; }

fetch_latest_asset() {
  local repo="$1" pattern="$2" out="$3"
  echo "Fetching latest release asset for $repo matching $pattern"
  url=$(py <<PY
import json, sys, re, urllib.request
repo = sys.argv[1]
pat = re.compile(sys.argv[2])
req = urllib.request.Request(f'https://api.github.com/repos/{repo}/releases/latest', headers={'User-Agent':'local-installer'})
with urllib.request.urlopen(req) as r:
    data = json.load(r)
for a in data.get('assets', []):
    name = a.get('name','')
    if pat.search(name):
        print(a['browser_download_url'])
        break
PY
"$repo" "$pattern") || true
  if [ -z "${url:-}" ]; then
    echo "No asset matched for $repo" >&2; return 1
  fi
  tmp=$(mktemp)
  curl -fsSL "$url" -o "$tmp"
  case "$url" in
    *.tar.gz|*.tgz)
      tar -xzf "$tmp" -C "$BIN_DIR" || { echo "Extract failed for $url" >&2; return 1; } ;;
    *.zip)
      unzip -o "$tmp" -d "$BIN_DIR" ;; 
    *)
      mv "$tmp" "$BIN_DIR/$out" ; chmod +x "$BIN_DIR/$out" ; tmp="" ;;
  esac
  [ -n "$tmp" ] && rm -f "$tmp" || true
}

# alejandra (static musl preferred)
fetch_latest_asset "kamadorueda/alejandra" "alejandra-.*unknown-linux-(musl|gnu)$" "alejandra" || true

# treefmt
fetch_latest_asset "numtide/treefmt" "treefmt-.*unknown-linux-(musl|gnu)$" "treefmt" || true

# statix (tar.gz, contains 'statix')
fetch_latest_asset "nerdypepper/statix" "linux.*(x86_64|amd64).*\.tar\.gz$" "statix" || true
# If tar created a dir, try to move binary into BIN_DIR
if [ -d "$BIN_DIR/statix" ]; then mv "$BIN_DIR/statix"/* "$BIN_DIR/" && rmdir "$BIN_DIR/statix" || true; fi

# deadnix
fetch_latest_asset "astro/deadnix" "deadnix-.*unknown-linux-(musl|gnu)$" "deadnix" || true

echo "Installed binaries in $BIN_DIR:"; ls -la "$BIN_DIR"


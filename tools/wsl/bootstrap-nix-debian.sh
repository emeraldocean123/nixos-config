#!/usr/bin/env bash
set -euo pipefail

# Debian WSL bootstrap for Nix + flakes and repo checkout
# Usage:
#   ./bootstrap-nix-debian.sh                 # user-level setup (recommended)
#   sudo ./bootstrap-nix-debian.sh --write-wslconf  # enable systemd in /etc/wsl.conf

log() { printf "[bootstrap] %s\n" "$*"; }
err() { printf "[bootstrap][ERROR] %s\n" "$*" >&2; }

WRITE_WSLCONF=0
WIN_USER="josep"
WIN_SSH="/mnt/c/Users/${WIN_USER}/.ssh/id_ed25519_unified"
REPO_SSH="git@github.com:emeraldocean123/nixos-config.git"
CHECKOUT_DIR="$HOME/projects/nixos-config"

for arg in "$@"; do
  case "$arg" in
    --write-wslconf) WRITE_WSLCONF=1 ;;
    --repo=*) REPO_SSH="${arg#--repo=}" ;;
    --dir=*) CHECKOUT_DIR="${arg#--dir=}" ;;
    --win-user=*) WIN_USER="${arg#--win-user=}"; WIN_SSH="/mnt/c/Users/${WIN_USER}/.ssh/id_ed25519_unified" ;;
    *) err "Unknown arg: $arg"; exit 2 ;;
  esac
done

# 1) Optionally enable systemd in /etc/wsl.conf
if [[ "$WRITE_WSLCONF" -eq 1 ]]; then
  if [[ $EUID -ne 0 ]]; then
    err "--write-wslconf requires root (sudo). Rerun with sudo."; exit 1
  fi
  log "Writing /etc/wsl.conf (enable systemd)"
  install -m 644 /dev/null /etc/wsl.conf
  cat >/etc/wsl.conf <<'WSL'
[boot]
systemd=true
WSL
  log "Done. From Windows PowerShell run: wsl --shutdown, then reopen Debian."
fi

# 2) Ensure basic deps
if command -v apt >/dev/null 2>&1; then
  log "Updating APT metadata (sudo may prompt)"
  sudo apt-get update -y >/dev/null 2>&1 || true
  sudo apt-get install -y curl git ca-certificates >/dev/null 2>&1 || true
fi

# 3) Install Nix (daemon mode) if missing
if ! command -v nix >/dev/null 2>&1; then
  log "Installing Nix (daemon mode) via Determinate Systems installer"
  sh <(curl -L https://install.determinate.systems/nix) install || {
    err "Nix install failed"; exit 1; }
fi

# 4) Enable flakes globally for user
mkdir -p "$HOME/.config/nix"
if ! grep -q "experimental-features" "$HOME/.config/nix/nix.conf" 2>/dev/null; then
  log "Enabling nix-command and flakes"
  printf "experimental-features = nix-command flakes\n" >> "$HOME/.config/nix/nix.conf"
fi

# 5) SSH key setup: prefer Windows unified key, otherwise keep user's key
if [[ -f "$WIN_SSH" ]]; then
  log "Referencing Windows unified SSH key at $WIN_SSH"
  mkdir -p "$HOME/.ssh"
  ln -sf "$WIN_SSH" "$HOME/.ssh/id_ed25519_unified"
  chmod 600 "$HOME/.ssh/id_ed25519_unified" 2>/dev/null || true
  # Known hosts hardened fetch
  touch "$HOME/.ssh/known_hosts"; chmod 600 "$HOME/.ssh/known_hosts"
  if ! ssh-keygen -F github.com >/dev/null; then
    ssh-keyscan -t rsa,ed25519 github.com >> "$HOME/.ssh/known_hosts" 2>/dev/null || true
  fi
else
  log "Windows key not found at $WIN_SSH. Ensure an SSH key exists in ~/.ssh."
fi

# 6) Clone or update repo on Linux FS
mkdir -p "$(dirname "$CHECKOUT_DIR")"
if [[ -d "$CHECKOUT_DIR/.git" ]]; then
  log "Updating existing repo at $CHECKOUT_DIR"
  git -C "$CHECKOUT_DIR" remote set-url origin "$REPO_SSH" || true
  git -C "$CHECKOUT_DIR" fetch --all --prune || true
  git -C "$CHECKOUT_DIR" pull --ff-only || true
else
  log "Cloning $REPO_SSH to $CHECKOUT_DIR"
  git clone "$REPO_SSH" "$CHECKOUT_DIR" || {
    err "Clone failed. Check SSH auth."; exit 1; }
fi

# 7) Run flake check
if command -v nix >/dev/null 2>&1; then
  log "Running: nix flake check -L"
  (cd "$CHECKOUT_DIR" && nix flake check -L) || {
    err "nix flake check reported issues"; exit 1; }
fi

log "Bootstrap completed successfully."


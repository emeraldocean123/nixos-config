#!/usr/bin/env bash
# A comprehensive script to capture the state of a NixOS or other Bash system.

# --- SECTION 1: SYSTEM INFORMATION ---
echo "################################################################################"
echo "### SECTION 1: SYSTEM INFORMATION"
echo "################################################################################"
echo "Generated on:      $(date)"
echo "Hostname:          $(hostname)"
echo "OS Type:           $(uname -s)"
if command -v nixos-version &>/dev/null; then
  echo "NixOS Version:     $(nixos-version)"
fi
echo "Kernel Version:    $(uname -r)"
echo "################################################################################"
echo

# --- SECTION 2: NixOS SYSTEM CONFIGURATION (/etc/nixos) ---
echo "################################################################################"
echo "### SECTION 2: NixOS SYSTEM CONFIGURATION (/etc/nixos)"
echo "################################################################################"
BASE_DIR="/etc/nixos"
if [ -d "$BASE_DIR" ]; then
  find "$BASE_DIR" -name ".git" -prune -o -type f -print | sort | while IFS= read -r file; do
      echo "--- FILE: ${file} ---"
      if grep -Iq . "${file}"; then cat "${file}"; else echo "(Binary file, contents omitted)"; fi
      echo
  done
else
  echo "Directory $BASE_DIR not found (this is normal on non-NixOS systems)."
fi
echo

# --- SECTION 3: USER DOTFILES REPOSITORY ---
echo "################################################################################"
echo "### SECTION 3: USER DOTFILES REPOSITORY"
echo "################################################################################"
# Use different paths for Windows (Git Bash) vs Linux
if [[ "$OSTYPE" == "msys"* ]]; then
  DOTFILES_DIR="$HOME/Documents/dotfiles"
else
  DOTFILES_DIR="$HOME/dotfiles"
fi

echo "Searching for dotfiles in: ${DOTFILES_DIR}"
if [ -d "$DOTFILES_DIR" ]; then
  find "$DOTFILES_DIR" -name ".git" -prune -o -type f -print | sort | while IFS= read -r file; do
      echo "--- FILE: ${file} ---"
      if grep -Iq . "${file}"; then cat "${file}"; else echo "(Binary file, contents omitted)"; fi
      echo
  done
else
  echo "Directory $DOTFILES_DIR not found."
fi
echo

# --- SECTION 4: ACTIVE USER ENVIRONMENT ---
echo "################################################################################"
echo "### SECTION 4: ACTIVE USER ENVIRONMENT"
echo "################################################################################"
echo

echo "--- 4.1: Home Directory Listing ---"
ls -la "$HOME"
echo

echo "--- 4.2: Sorted Environment Variables ---"
env | sort
echo

echo "--- 4.3: Active Shell Aliases ---"
alias
echo

echo "--- 4.4: Nix & Home Manager Status ---"
if command -v home-manager &>/dev/null; then
  echo "--- Home Manager Generations ---"
  home-manager generations
else
  echo "--- Home Manager: Command not found (this is normal on non-NixOS systems). ---"
fi
echo

echo "### End of Snapshot ###"

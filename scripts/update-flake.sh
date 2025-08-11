#!/bin/bash
# Update flake dependencies for NixOS configuration
set -euo pipefail

echo "=== Updating flake dependencies ==="
cd /etc/nixos
sudo nix flake update

echo ""
echo "=== Updated flake.lock ==="
git diff flake.lock | head -50

echo ""
echo "=== Testing configuration ==="
sudo nixos-rebuild dry-build --flake .

echo ""
echo "Done! If the dry-build succeeded, you can rebuild with:"
echo "  sudo nixos-rebuild switch --flake ."
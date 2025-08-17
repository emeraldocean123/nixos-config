#!/usr/bin/env bash
# Format all Nix files in the repository
# Run this script on a NixOS machine or in WSL with Nix installed

set -e

echo "🔧 Formatting all Nix files in the repository..."

# Check if nix is available
if ! command -v nix &> /dev/null; then
    echo "❌ Error: nix command not found. Please run this on NixOS or install Nix."
    exit 1
fi

# Change to the repository directory
cd "$(dirname "$0")"

# Run nix fmt
echo "📝 Running nix fmt..."
nix fmt

echo "✅ Formatting complete!"
echo ""
echo "To apply these changes on your NixOS machines:"
echo "1. Commit and push the changes to GitHub"
echo "2. On each NixOS machine, pull the changes:"
echo "   cd /etc/nixos && sudo git pull"
echo "3. Rebuild the system:"
echo "   sudo nixos-rebuild switch --flake .#\$(hostname)"
#!/usr/bin/env bash
# fix-follett-user.sh - Quick fix for the follett user issue
# Run this if you get "Failed to look up user follett" errors

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Follett User Fix Script ===${NC}"
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: This script must be run as root (use sudo)${NC}"
   exit 1
fi

# Check if follett user exists
if id "follett" &>/dev/null; then
    echo -e "${GREEN}✓ User 'follett' already exists${NC}"
    echo "  No action needed."
else
    echo -e "${YELLOW}User 'follett' not found. Creating...${NC}"
    
    # Create the user with the same settings as in the NixOS config
    useradd -m \
        -c "Follett" \
        -s /bin/bash \
        -G networkmanager,wheel \
        follett
    
    echo -e "${GREEN}✓ User 'follett' created successfully${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Set a password for follett (optional):"
    echo "   sudo passwd follett"
    echo ""
    echo "2. Retry the NixOS rebuild:"
    echo "   sudo nixos-rebuild switch --flake .#msi-ge75-raider-nixos"
fi

echo ""
echo -e "${YELLOW}Note:${NC} If you don't need the follett user, you can remove it from:"
echo "  - flake.nix (home-manager.users.follett lines)"
echo "  - modules/*/users.nix files"
echo "  - home/*/follett.nix files"
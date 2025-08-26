#!/usr/bin/env bash
# prepare-migration.sh - Prepare system for NixOS configuration migration
# Run this BEFORE applying the custom nixos-config to avoid user lookup failures

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== NixOS Migration Preparation Script ===${NC}"
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: This script must be run as root (use sudo)${NC}"
   exit 1
fi

# Function to check if user exists
user_exists() {
    id "$1" &>/dev/null
}

# Function to check if group exists
group_exists() {
    getent group "$1" &>/dev/null
}

echo -e "${YELLOW}Step 1: Checking system users...${NC}"

# Create joseph user if doesn't exist
if user_exists "joseph"; then
    echo -e "${GREEN}✓ User 'joseph' already exists${NC}"
else
    echo -e "${YELLOW}Creating user 'joseph'...${NC}"
    # Create joseph's group first
    if ! group_exists "joseph"; then
        groupadd joseph
    fi
    useradd -m -g joseph -G wheel,networkmanager -s /bin/bash -c "Joseph" joseph
    echo -e "${GREEN}✓ User 'joseph' created${NC}"
    echo -e "${YELLOW}  Remember to set password: passwd joseph${NC}"
fi

# Create follett user if doesn't exist
if user_exists "follett"; then
    echo -e "${GREEN}✓ User 'follett' already exists${NC}"
else
    echo -e "${YELLOW}Creating user 'follett'...${NC}"
    useradd -m -G networkmanager,wheel -s /bin/bash -c "Follett" follett
    echo -e "${GREEN}✓ User 'follett' created${NC}"
    echo -e "${YELLOW}  Remember to set password: passwd follett${NC}"
fi

echo ""
echo -e "${YELLOW}Step 2: Backing up current hardware configuration...${NC}"

# Create backup directory
BACKUP_DIR="/root/hardware-config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup current hardware configuration if it exists
if [ -f /etc/nixos/hardware-configuration.nix ]; then
    cp /etc/nixos/hardware-configuration.nix "$BACKUP_DIR/"
    echo -e "${GREEN}✓ Hardware configuration backed up to: $BACKUP_DIR${NC}"
else
    echo -e "${YELLOW}  No existing hardware-configuration.nix found${NC}"
fi

# Save current disk configuration
echo -e "${YELLOW}Step 3: Documenting current disk setup...${NC}"
lsblk -f > "$BACKUP_DIR/disk-layout.txt"
blkid > "$BACKUP_DIR/disk-uuids.txt"
findmnt --verify --all > "$BACKUP_DIR/mount-points.txt" 2>/dev/null || true
echo -e "${GREEN}✓ Disk configuration saved to: $BACKUP_DIR${NC}"

echo ""
echo -e "${YELLOW}Step 4: Verifying system requirements...${NC}"

# Check for required groups
for group in wheel networkmanager; do
    if group_exists "$group"; then
        echo -e "${GREEN}✓ Group '$group' exists${NC}"
    else
        echo -e "${RED}✗ Group '$group' missing - this may cause issues${NC}"
    fi
done

# Check for network connectivity
if ping -c 1 github.com &>/dev/null; then
    echo -e "${GREEN}✓ Network connectivity confirmed${NC}"
else
    echo -e "${YELLOW}⚠ Cannot reach github.com - may have issues fetching configuration${NC}"
fi

echo ""
echo -e "${GREEN}=== Preparation Complete ===${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Set passwords for users if needed:"
echo "   sudo passwd joseph"
echo "   sudo passwd follett"
echo ""
echo "2. Clone and apply the configuration:"
echo "   git clone https://github.com/emeraldocean123/nixos-config.git"
echo "   cd nixos-config"
echo ""
echo "3. CRITICAL: Generate hardware configuration for THIS machine:"
echo "   sudo nixos-generate-config --dir ./hosts/$(hostname)"
echo "   # Or if using MSI configuration:"
echo "   sudo nixos-generate-config --dir ./hosts/msi-ge75-raider-nixos"
echo ""
echo "4. Apply the configuration:"
echo "   sudo nixos-rebuild switch --flake .#msi-ge75-raider-nixos"
echo ""
echo -e "${GREEN}Hardware backup saved at: $BACKUP_DIR${NC}"
echo -e "${YELLOW}Keep this backup safe in case you need to recover!${NC}"

# prepare-migration-remote.ps1 - Prepare remote NixOS system for configuration migration
# Run this from Windows to prepare a remote NixOS system via SSH

param(
    [Parameter(Mandatory=$true)]
    [string]$HostIP,
    
    [Parameter(Mandatory=$false)]
    [string]$SSHUser = "root",
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipFollett
)

Write-Host "=== NixOS Remote Migration Preparation ===" -ForegroundColor Green
Write-Host ""

# Test SSH connection
Write-Host "Testing SSH connection to $HostIP..." -ForegroundColor Yellow
try {
    ssh "${SSHUser}@${HostIP}" "echo 'Connection successful'" 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "SSH connection failed"
    }
    Write-Host "✓ SSH connection established" -ForegroundColor Green
} catch {
    Write-Host "✗ Cannot connect to $HostIP via SSH" -ForegroundColor Red
    Write-Host "  Ensure SSH is enabled and you can connect as $SSHUser" -ForegroundColor Yellow
    exit 1
}

# Create the preparation script content
$scriptContent = @'
#!/usr/bin/env bash
set -euo pipefail

echo "=== Preparing NixOS System ==="

# Function to check if user exists
user_exists() {
    id "$1" &>/dev/null
}

# Function to check if group exists  
group_exists() {
    getent group "$1" &>/dev/null
}

# Create joseph user if doesn't exist
if user_exists "joseph"; then
    echo "✓ User 'joseph' already exists"
else
    echo "Creating user 'joseph'..."
    if ! group_exists "joseph"; then
        groupadd joseph
    fi
    useradd -m -g joseph -G wheel,networkmanager -s /bin/bash -c "Joseph" joseph
    echo "✓ User 'joseph' created"
fi

# Create follett user if requested
if [ "$1" != "skip-follett" ]; then
    if user_exists "follett"; then
        echo "✓ User 'follett' already exists"
    else
        echo "Creating user 'follett'..."
        useradd -m -G networkmanager,wheel -s /bin/bash -c "Follett" follett
        echo "✓ User 'follett' created"
    fi
else
    echo "Skipping follett user creation"
fi

# Backup hardware configuration
BACKUP_DIR="/root/hardware-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

if [ -f /etc/nixos/hardware-configuration.nix ]; then
    cp /etc/nixos/hardware-configuration.nix "$BACKUP_DIR/"
    echo "✓ Hardware configuration backed up to: $BACKUP_DIR"
fi

# Save disk information
lsblk -f > "$BACKUP_DIR/disk-layout.txt"
blkid > "$BACKUP_DIR/disk-uuids.txt"
echo "✓ Disk configuration documented"

# Generate fresh hardware configuration
echo "Generating fresh hardware configuration..."
nixos-generate-config --root / --dir /tmp/fresh-hw-config 2>/dev/null || true
if [ -f /tmp/fresh-hw-config/hardware-configuration.nix ]; then
    cp /tmp/fresh-hw-config/hardware-configuration.nix "$BACKUP_DIR/hardware-configuration-fresh.nix"
    echo "✓ Fresh hardware configuration saved"
fi

echo ""
echo "=== Preparation Complete ==="
echo "Backup location: $BACKUP_DIR"
echo ""
echo "IMPORTANT: After cloning nixos-config, copy the hardware configuration:"
echo "  cp $BACKUP_DIR/hardware-configuration-fresh.nix ~/nixos-config/hosts/msi-ge75-raider-nixos/hardware-configuration.nix"
'@

# Determine follett parameter
$follettParam = if ($SkipFollett) { "skip-follett" } else { "include-follett" }

Write-Host ""
Write-Host "Executing preparation on remote host..." -ForegroundColor Yellow

# Execute the script on remote host
$remoteCommand = "echo '$scriptContent' > /tmp/prepare-migration.sh && chmod +x /tmp/prepare-migration.sh && sudo /tmp/prepare-migration.sh $follettParam"

ssh "${SSHUser}@${HostIP}" $remoteCommand

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=== Remote Preparation Successful ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps on the NixOS system:" -ForegroundColor Yellow
    Write-Host "1. Set user passwords if needed:"
    Write-Host "   sudo passwd joseph"
    if (-not $SkipFollett) {
        Write-Host "   sudo passwd follett"
    }
    Write-Host ""
    Write-Host "2. Clone the configuration:"
    Write-Host "   git clone https://github.com/emeraldocean123/nixos-config.git"
    Write-Host ""
    Write-Host "3. Copy the backed-up hardware configuration:"
    Write-Host "   Check /root/hardware-backup-* for the backup location"
    Write-Host ""
    Write-Host "4. Rebuild NixOS:"
    Write-Host "   cd nixos-config"
    Write-Host "   sudo nixos-rebuild switch --flake .#msi-ge75-raider-nixos"
} else {
    Write-Host "✗ Remote preparation failed" -ForegroundColor Red
    exit 1
}
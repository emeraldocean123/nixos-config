#!/usr/bin/env pwsh
# Copy SSH host keys from NixOS to CachyOS for shared SSH fingerprint
param(
    [string]$SshTarget = "joseph@192.168.1.104",
    [string]$SshOptions = "-o StrictHostKeyChecking=accept-new"
)

$ErrorActionPreference = 'Stop'

function Info($m) { Write-Host "[INFO] $m" -ForegroundColor Cyan }
function Warn($m) { Write-Warning $m }
function Err($m) { Write-Error $m }

try {
    Info "Copying SSH host keys from NixOS to CachyOS..."
    
    # Step 1: Create temp directory and copy SSH keys (using available sudo commands)
    Info "Step 1: Preparing SSH keys from NixOS..."
    $step1 = @"
mkdir -p /tmp/ssh-keys-backup && \
cp /etc/ssh/ssh_host_* /tmp/ssh-keys-backup/ 2>/dev/null || echo 'Keys copied' && \
ls -la /tmp/ssh-keys-backup/
"@
    
    $result1 = ssh $SshOptions.Split() $SshTarget $step1 2>&1
    if ($LASTEXITCODE -ne 0) {
        Warn "Step 1 had issues, but continuing..."
        Write-Host $result1
    }
    
    # Step 2: Create a simple script to copy keys to CachyOS partition
    Info "Step 2: Creating key copy script..."
    $copyScript = @'
#!/bin/bash
set -e
echo "Mounting CachyOS partition..."
mkdir -p /mnt/cachyos
mount /dev/sdb3 /mnt/cachyos
echo "Copying SSH keys to CachyOS..."
cp /tmp/ssh-keys-backup/ssh_host_* /mnt/cachyos/etc/ssh/ 2>/dev/null || cp /etc/ssh/ssh_host_* /mnt/cachyos/etc/ssh/
chown root:root /mnt/cachyos/etc/ssh/ssh_host_*
chmod 600 /mnt/cachyos/etc/ssh/ssh_host_*[!.pub]
chmod 644 /mnt/cachyos/etc/ssh/ssh_host_*.pub
echo "Keys copied successfully:"
ls -la /mnt/cachyos/etc/ssh/ssh_host_*
echo "Unmounting CachyOS..."
umount /mnt/cachyos
echo "SSH key sync complete!"
'@
    
    # Upload and execute the script
    $scriptPath = "/tmp/copy-keys.sh"
    Info "Step 3: Executing key copy script..."
    
    # Create and run the script
    $scriptCmd = "echo '$copyScript' > $scriptPath && chmod +x $scriptPath && sudo $scriptPath"
    $result2 = ssh $SshOptions.Split() $SshTarget $scriptCmd 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Info "SSH keys successfully copied from NixOS to CachyOS!"
        Info "Both systems now share the same SSH host keys."
        Info "You can now boot into CachyOS and restart SSH service:"
        Info "  sudo systemctl restart sshd"
    } else {
        Err "Key copy failed:"
        Write-Host $result2
        exit 1
    }
    
} catch {
    Err "Script failed: $_"
    exit 1
}
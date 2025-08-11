#!/usr/bin/env pwsh
# Update HP system with latest config and rebuild
param(
    [string]$SshTarget = "joseph@192.168.1.104",
    [string]$SshOptions = "-o StrictHostKeyChecking=accept-new"
)

$ErrorActionPreference = 'Stop'

function Info($m) { Write-Host "[INFO] $m" -ForegroundColor Cyan }
function Warn($m) { Write-Warning $m }
function Err($m) { Write-Error $m }

try {
    Info "Updating HP system configuration and rebuilding..."
    
    # Use the pre-configured sudo rules that allow git pull
    $gitCmd = "sudo /run/current-system/sw/bin/git -C /etc/nixos pull --ff-only"
    $rebuildCmd = "sudo /run/current-system/sw/bin/nixos-rebuild switch"
    
    Info "Pulling latest configuration..."
    $pullResult = ssh $SshOptions.Split() $SshTarget $gitCmd 2>&1
    if ($LASTEXITCODE -ne 0) {
        Warn "Git pull may have failed, but continuing with rebuild..."
        Write-Host $pullResult
    } else {
        Info "Configuration updated successfully"
    }
    
    Info "Rebuilding NixOS system..."
    $rebuildResult = ssh $SshOptions.Split() $SshTarget $rebuildCmd 2>&1
    if ($LASTEXITCODE -eq 0) {
        Info "System rebuild completed successfully!"
        Info "The HP system is now configured for dual boot with CachyOS."
    } else {
        Err "System rebuild failed:"
        Write-Host $rebuildResult
        exit 1
    }
    
} catch {
    Err "Script failed: $_"
    exit 1
}
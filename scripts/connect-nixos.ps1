#!/usr/bin/env pwsh
# Quick SSH connection to NixOS (Build 28)
param(
    [string]$Command = "",
    [switch]$Interactive,
    [string]$IpAddress = "192.168.1.104"  # Default IP, can be overridden
)

$SshTarget = "joseph@$IpAddress"
$SshOptions = @("-o", "StrictHostKeyChecking=accept-new")

Write-Host "🐧 Connecting to NixOS..." -ForegroundColor Blue

if ($Command) {
    # Execute command and return
    ssh @SshOptions $SshTarget $Command
} elseif ($Interactive) {
    # Interactive session
    ssh @SshOptions $SshTarget
} else {
    # Quick system info
    ssh @SshOptions $SshTarget "echo '=== NixOS System Info ===' && hostname && whoami && nixos-rebuild list-generations | head -2 && uptime"
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ NixOS connection successful" -ForegroundColor Green
} else {
    Write-Host "❌ NixOS connection failed" -ForegroundColor Red
}
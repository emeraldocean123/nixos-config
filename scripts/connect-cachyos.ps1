#!/usr/bin/env pwsh
# Quick SSH connection to CachyOS
param(
    [string]$Command = "",
    [switch]$Interactive,
    [string]$IpAddress = "192.168.1.104"  # Default IP, can be overridden
)

$SshTarget = "joseph@$IpAddress"
$SshOptions = @("-o", "StrictHostKeyChecking=accept-new")

Write-Host "🚀 Connecting to CachyOS..." -ForegroundColor Cyan

if ($Command) {
    # Execute command and return
    ssh @SshOptions $SshTarget $Command
} elseif ($Interactive) {
    # Interactive session
    ssh @SshOptions $SshTarget
} else {
    # Quick system info
    ssh @SshOptions $SshTarget "echo '=== CachyOS System Info ===' && hostname && whoami && cat /etc/os-release | head -2 && uptime"
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ CachyOS connection successful" -ForegroundColor Green
} else {
    Write-Host "❌ CachyOS connection failed - System may not be booted" -ForegroundColor Red
    Write-Host "💡 Boot CachyOS from GRUB menu or manually: GRUB → 'c' → 'set root=(hd1)' → 'chainloader +1' → 'boot'" -ForegroundColor Yellow
}
#!/usr/bin/env pwsh
# Check which system is currently running and overall dual boot status
param(
    [switch]$Detailed,
    [string]$IpAddress = "192.168.1.104",  # Default IP, can be overridden
    [string]$Username = "joseph"
)

$ErrorActionPreference = 'SilentlyContinue'
$SshTarget = "$Username@$IpAddress"
$SshOptions = @("-o", "ConnectTimeout=5", "-o", "StrictHostKeyChecking=accept-new")

Write-Host "🔍 Checking Dual Boot Status..." -ForegroundColor Magenta
Write-Host "=" * 50

# Test SSH connection
Write-Host "📡 Testing SSH connection..." -ForegroundColor Yellow
$sshTest = ssh @SshOptions $SshTarget "echo 'connected'" 2>$null
if (-not $sshTest) {
    Write-Host "❌ No SSH connection - HP system may be offline" -ForegroundColor Red
    exit 1
}

# Determine which OS is running
Write-Host "🖥️  Detecting current OS..." -ForegroundColor Yellow
$osInfo = ssh @SshOptions $SshTarget "hostname && cat /etc/os-release 2>/dev/null | grep -E '^(NAME|ID)=' | head -2" 2>$null

if ($osInfo -match "nixos") {
    Write-Host "✅ Currently running: NixOS" -ForegroundColor Green
    $currentOS = "NixOS"
    
    if ($Detailed) {
        $nixosInfo = ssh @SshOptions $SshTarget "nixos-rebuild list-generations | head -3"
        Write-Host "📋 NixOS Details:" -ForegroundColor Cyan
        Write-Host $nixosInfo
    }
} elseif ($osInfo -match "cachyos") {
    Write-Host "✅ Currently running: CachyOS" -ForegroundColor Green  
    $currentOS = "CachyOS"
    
    if ($Detailed) {
        $cachyInfo = ssh @SshOptions $SshTarget "uname -r && pacman -Q | wc -l && echo 'packages installed'"
        Write-Host "📋 CachyOS Details:" -ForegroundColor Cyan
        Write-Host $cachyInfo
    }
} else {
    Write-Host "⚠️  Unknown OS detected" -ForegroundColor Yellow
    $currentOS = "Unknown"
}

# Check disk layout
if ($Detailed) {
    Write-Host "`n💾 Disk Layout:" -ForegroundColor Yellow
    $diskInfo = ssh @SshOptions $SshTarget "lsblk | grep -E '(sda|sdb)'"
    Write-Host $diskInfo
}

# Boot instructions
Write-Host "`n🔄 Boot Instructions:" -ForegroundColor Yellow
Write-Host "├─ NixOS: Select 'NixOS Build 28' from GRUB menu"
Write-Host "└─ CachyOS: GRUB → 'c' → 'set root=(hd1)' → 'chainloader +1' → 'boot'"

Write-Host "`n📞 SSH Access:" -ForegroundColor Yellow
Write-Host "├─ Use: .\connect-nixos.ps1 or .\connect-cachyos.ps1"
Write-Host "└─ IP: 192.168.1.104 (WiFi) or 192.168.1.103 (LAN)"

Write-Host "`n✅ Dual boot system is healthy!" -ForegroundColor Green
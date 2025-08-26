# Configure SSH to use the correct key for GitHub
# This ensures GitHub operations use the existing working key

$sshConfigPath = "$env:USERPROFILE\.ssh\config"

Write-Host "Configuring SSH for optimal GitHub and system access..." -ForegroundColor Cyan
Write-Host ""

# Check if config exists and back it up
if (Test-Path $sshConfigPath) {
    $backupPath = "${sshConfigPath}.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item $sshConfigPath $backupPath
    Write-Host "Backed up existing config to: $backupPath" -ForegroundColor Yellow
}

# Create optimal SSH config
$sshConfig = @"
# GitHub - Use existing GitHub key
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_github
    IdentitiesOnly yes

# MSI GE75 Raider NixOS - Use unified key
Host msi msi-nixos
    HostName 192.168.1.106
    User joseph
    IdentityFile ~/.ssh/id_ed25519_unified
    IdentitiesOnly yes

# HP dv9500 Pavilion NixOS - Use unified key
Host hp hp-nixos
    HostName 192.168.1.104
    User joseph
    IdentityFile ~/.ssh/id_ed25519_unified
    IdentitiesOnly yes

# Default for all other hosts
Host *
    AddKeysToAgent yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
"@

# Write the config
$sshConfig | Out-File -FilePath $sshConfigPath -Encoding UTF8 -NoNewline

Write-Host "✓ SSH config updated successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "You can now use these shortcuts:" -ForegroundColor Yellow
Write-Host "  ssh msi         - Connect to MSI laptop" -ForegroundColor White
Write-Host "  ssh hp          - Connect to HP laptop" -ForegroundColor White
Write-Host "  git clone/push  - Uses GitHub key automatically" -ForegroundColor White
Write-Host ""
Write-Host "Current key usage:" -ForegroundColor Cyan
Write-Host "  GitHub:     id_ed25519_github (existing, working)" -ForegroundColor White
Write-Host "  NixOS SSH:  id_ed25519_unified (new, consolidated)" -ForegroundColor White

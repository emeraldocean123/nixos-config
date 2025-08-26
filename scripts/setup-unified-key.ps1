# Setup Unified SSH Key for Everything
Write-Host "===== SETTING UP UNIFIED SSH KEY =====" -ForegroundColor Cyan
Write-Host ""

# Step 1: Copy unified key to clipboard for GitHub
$publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBdb5WWyH4atlYewmthJGTVAkJysN3UHp5ZhUDtfbp2 joseph@unified-key"
$publicKey | Set-Clipboard

Write-Host "Step 1: Add Unified Key to GitHub" -ForegroundColor Yellow
Write-Host "---------------------------------------"
Write-Host "1. Opening GitHub SSH settings..." -ForegroundColor White
Start-Process "https://github.com/settings/keys"
Write-Host ""
Write-Host "2. Click 'New SSH key'" -ForegroundColor White
Write-Host "3. Title: 'Unified Key - All Systems (Primary)'" -ForegroundColor White
Write-Host "4. Key type: 'Authentication Key'" -ForegroundColor White
Write-Host "5. Paste the key (already in clipboard)" -ForegroundColor White
Write-Host ""
Write-Host "✓ Public key copied to clipboard!" -ForegroundColor Green
Write-Host ""
Write-Host "Press Enter after adding the key to GitHub..." -ForegroundColor Yellow
Read-Host

Write-Host ""
Write-Host "Step 2: After testing, remove old keys from GitHub:" -ForegroundColor Yellow
Write-Host "---------------------------------------"
Write-Host "Delete these keys from GitHub settings:" -ForegroundColor White
Write-Host "  - 'Windows 11' (SHA256:6BRj6x...)" -ForegroundColor Red
Write-Host "  - 'hp-dv9500-pavilion-nixos' (SHA256:KIvefn...)" -ForegroundColor Red
Write-Host ""
Write-Host "Keep only: 'Unified Key - All Systems (Primary)'" -ForegroundColor Green
Write-Host ""

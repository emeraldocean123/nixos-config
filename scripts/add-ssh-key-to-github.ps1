# Script to add unified SSH key to GitHub
# Run this script or follow the manual steps below

$publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBdb5WWyH4atlYewmthJGTVAkJysN3UHp5ZhUDtfbp2 joseph@unified-key"

Write-Host "===== ADD SSH KEY TO GITHUB =====" -ForegroundColor Cyan
Write-Host ""
Write-Host "Option 1: Open GitHub SSH settings directly" -ForegroundColor Yellow
Write-Host "Opening browser to GitHub SSH settings..."
Start-Process "https://github.com/settings/keys"

Write-Host ""
Write-Host "Option 2: Manual steps:" -ForegroundColor Yellow
Write-Host "1. Go to: https://github.com/settings/keys"
Write-Host "2. Click 'New SSH key'"
Write-Host "3. Title: 'Unified Key - All Systems'"
Write-Host "4. Key type: 'Authentication Key'"
Write-Host "5. Paste this key:"
Write-Host ""
Write-Host $publicKey -ForegroundColor Green
Write-Host ""

# Copy to clipboard
$publicKey | Set-Clipboard
Write-Host "✓ Public key copied to clipboard!" -ForegroundColor Green
Write-Host ""
Write-Host "After adding to GitHub, you can remove the old GitHub key"
Write-Host ""
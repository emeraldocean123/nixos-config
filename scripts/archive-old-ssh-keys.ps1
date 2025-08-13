# Archive old SSH keys
$backupDir = "$env:USERPROFILE\.ssh\archived_keys_$(Get-Date -Format 'yyyyMMdd')"

Write-Host "Archiving old SSH keys..." -ForegroundColor Yellow

# Create archive directory
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

# List of old keys to archive
$oldKeys = @(
    "id_ed25519",
    "id_ed25519.pub",
    "id_ed25519_github", 
    "id_ed25519_github.pub"
)

foreach ($key in $oldKeys) {
    $sourcePath = "$env:USERPROFILE\.ssh\$key"
    if (Test-Path $sourcePath) {
        Move-Item -Path $sourcePath -Destination $backupDir -Force
        Write-Host "Archived: $key" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Old keys archived to:" -ForegroundColor Cyan
Write-Host $backupDir
Write-Host ""
Write-Host "Archived files:" -ForegroundColor Yellow
Get-ChildItem $backupDir | Select-Object Name | Format-Table -HideTableHeaders

Write-Host ""
Write-Host "✓ Archive complete. You can now use the unified key for all systems." -ForegroundColor Green
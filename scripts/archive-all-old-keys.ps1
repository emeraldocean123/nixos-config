# Archive ALL old SSH keys
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$backupDir = "$env:USERPROFILE\.ssh\archived_keys_$timestamp"

Write-Host "===== ARCHIVING OLD SSH KEYS =====" -ForegroundColor Cyan
Write-Host ""

# Create archive directory
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

# List of old keys to archive (everything except unified)
$oldKeys = @(
    "id_ed25519",
    "id_ed25519.pub",
    "id_ed25519_github", 
    "id_ed25519_github.pub",
    "id_rsa",
    "id_rsa.pub",
    "id_dsa",
    "id_dsa.pub"
)

$archivedCount = 0

foreach ($key in $oldKeys) {
    $sourcePath = "$env:USERPROFILE\.ssh\$key"
    if (Test-Path $sourcePath) {
        Move-Item -Path $sourcePath -Destination $backupDir -Force
        Write-Host "✓ Archived: $key" -ForegroundColor Green
        $archivedCount++
    }
}

# Also backup old configs
$configBackups = Get-ChildItem "$env:USERPROFILE\.ssh\config.backup.*" -ErrorAction SilentlyContinue
if ($configBackups) {
    foreach ($backup in $configBackups) {
        Move-Item -Path $backup.FullName -Destination $backupDir -Force
        Write-Host "✓ Archived: $($backup.Name)" -ForegroundColor Green
        $archivedCount++
    }
}

Write-Host ""
Write-Host "Archive Summary:" -ForegroundColor Yellow
Write-Host "----------------"
Write-Host "Location: $backupDir" -ForegroundColor White
Write-Host "Files archived: $archivedCount" -ForegroundColor White
Write-Host ""

if ($archivedCount -gt 0) {
    Write-Host "Archived files:" -ForegroundColor Cyan
    Get-ChildItem $backupDir | Select-Object Name, Length | Format-Table -AutoSize
}

Write-Host ""
Write-Host "✓ COMPLETE: All old keys archived!" -ForegroundColor Green
Write-Host ""
Write-Host "You now have only ONE key:" -ForegroundColor Yellow
Write-Host "  ~/.ssh/id_ed25519_unified (active)" -ForegroundColor White
Write-Host "  ~/.ssh/id_ed25519_unified.pub" -ForegroundColor White
Write-Host ""
Write-Host "This unified key is used for:" -ForegroundColor Cyan
Write-Host "  - GitHub authentication" -ForegroundColor White
Write-Host "  - SSH to all NixOS systems" -ForegroundColor White
Write-Host "  - Any future systems" -ForegroundColor White
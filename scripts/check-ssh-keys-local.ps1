<#
  Lists standard SSH key files if present; does not print key contents.
#>
$ErrorActionPreference = 'Stop'
$sshDir = Join-Path $env:USERPROFILE '.ssh'
if (-not (Test-Path $sshDir)) {
  Write-Host "No local ~/.ssh directory found"
  exit 0
}
Write-Host "Local SSH dir: $sshDir"
$files = Get-ChildItem -Force $sshDir | Where-Object { $_.Name -match '^(id_ed25519|id_rsa)(\.pub)?$' }
if ($files) {
  $files | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize
} else {
  Write-Host "No standard SSH key files found (id_ed25519/id_rsa)"
}
$authKeys = Join-Path $sshDir 'authorized_keys'
if (Test-Path $authKeys) {
  $count = (Get-Content -ErrorAction SilentlyContinue $authKeys).Count
  Write-Host "authorized_keys lines: $count"
} else {
  Write-Host "No authorized_keys file"
}

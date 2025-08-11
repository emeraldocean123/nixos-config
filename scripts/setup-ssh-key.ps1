# Checks for an existing SSH key and generates one only if missing; optionally installs the public key on a remote host.
param(
    [string]$KeyType = "ed25519",
    [string]$KeyPath = "$env:USERPROFILE/.ssh/id_ed25519",
    [string]$KeyComment = "$env:USERNAME@$(hostname)",
    [string]$SshTarget = "",
    [string]$SshOptions = "-o StrictHostKeyChecking=accept-new"
)

$ErrorActionPreference = 'Stop'

function Write-Info($msg) { Write-Host "[INFO] $msg" }
function Write-Warn($msg) { Write-Warning $msg }
function Write-Err($msg) { Write-Error $msg }

try {
    $sshDir = Join-Path $env:USERPROFILE ".ssh"
    if (-not (Test-Path $sshDir)) {
        New-Item -ItemType Directory -Path $sshDir | Out-Null
    }

    $existing = @()
    $candidatePriv = @(
        Join-Path $sshDir "id_ed25519",
        Join-Path $sshDir "id_rsa"
    )
    foreach ($p in $candidatePriv) { if (Test-Path $p) { $existing += $p } }

    if ($existing.Count -gt 0) {
        Write-Info "Found existing SSH private key(s): $($existing -join ', ')"
        $KeyPath = $existing | Select-Object -First 1
        Write-Info "Using existing key: $KeyPath"
    } else {
        # Generate a new key
        $KeyPathDir = Split-Path -Parent $KeyPath
        if (-not (Test-Path $KeyPathDir)) { New-Item -ItemType Directory -Path $KeyPathDir | Out-Null }
        Write-Info "Generating new $KeyType SSH key at $KeyPath (no passphrase)"
        $sshKeygen = Get-Command ssh-keygen -ErrorAction SilentlyContinue
        if (-not $sshKeygen) { throw "ssh-keygen not found. Install OpenSSH Client from Windows Optional Features or winget." }
        & $sshKeygen.Path -t $KeyType -C $KeyComment -f $KeyPath -N "" | Out-Null
    }

    $pubPath = "$KeyPath.pub"
    if (-not (Test-Path $pubPath)) {
        # Derive the pub file if missing (ssh-keygen -y)
        $sshKeygen = Get-Command ssh-keygen -ErrorAction SilentlyContinue
        if (-not $sshKeygen) { throw "ssh-keygen not found to derive public key." }
        Write-Info "Public key not found; deriving from private key"
        (& $sshKeygen.Path -y -f $KeyPath) | Out-File -FilePath $pubPath -Encoding ascii -NoNewline
    }

    Write-Info "Public key: $pubPath"

    if ($SshTarget) {
        $ssh = Get-Command ssh -ErrorAction SilentlyContinue
        if (-not $ssh) { throw "ssh not found. Install OpenSSH Client from Windows Optional Features or winget." }
        Write-Info "Installing public key on $SshTarget"
        # Pipe the public key content to the remote authorized_keys safely
        $remoteCmd = "mkdir -p ~/.ssh && chmod 700 ~/.ssh && touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && cat >> ~/.ssh/authorized_keys"
        Get-Content -LiteralPath $pubPath -Raw -Encoding ascii | & $ssh.Path $SshOptions $SshTarget $remoteCmd
        Write-Info "Key installed. Test with: ssh $SshOptions $SshTarget"
    } else {
        Write-Info "Skip remote install (no -SshTarget provided)."
    }

    exit 0
} catch {
    Write-Err $_
    exit 1
}

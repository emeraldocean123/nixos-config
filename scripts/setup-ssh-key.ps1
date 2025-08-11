# Checks for an existing SSH key and generates one only if missing; optionally installs the public key on a remote host.
param(
    [string]$KeyType = "ed25519",
    [string]$KeyPath = "$env:USERPROFILE/.ssh/id_ed25519",
    [string]$KeyComment = "$env:USERNAME@$(hostname)",
    [string]$SshTarget = "",
    [string]$SshOptions = "-o StrictHostKeyChecking=accept-new",
    [int]$ConnectTimeoutSec = 8
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
    # Build candidate private key paths explicitly to avoid Join-Path receiving an array
    $candidatePriv = @(
        (Join-Path $sshDir 'id_ed25519'),
        (Join-Path $sshDir 'id_rsa')
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

        # Prepare SSH options as proper argv tokens. If provided as a single string like
        # "-o StrictHostKeyChecking=accept-new", convert to a compact form accepted as one token
        # by ssh ("-oStrictHostKeyChecking=accept-new"). For other options, pass through.
        $opts = @()
        if ($SshOptions) {
            if ($SshOptions -match '^-o\s+.+') {
                $opts += ($SshOptions -replace '^-o\s+', '-o')
            } elseif ($SshOptions -match '\s' -and -not ($SshOptions.Trim().StartsWith('"') -or $SshOptions.Trim().StartsWith("'"))) {
                $opts += ($SshOptions -split '\s+')
            } else {
                $opts += $SshOptions
            }
        }
        # Ensure a connect timeout is present to avoid hanging in non-interactive runs
        if (-not ($opts -match '^-o?ConnectTimeout')) { $opts += "-oConnectTimeout=$ConnectTimeoutSec" }

        # First, test if passwordless auth already works to avoid prompts in automation
        $testArgs = @($opts + @('-oBatchMode=yes', $SshTarget, 'true'))
        $test = Start-Process -FilePath $ssh.Path -ArgumentList $testArgs -NoNewWindow -PassThru -Wait -RedirectStandardOutput ([System.IO.Path]::GetTempFileName()) -RedirectStandardError ([System.IO.Path]::GetTempFileName())
        if ($test.ExitCode -ne 0) {
            Write-Warn "Passwordless SSH not available yet or host unreachable."
            Write-Info "Attempting interactive install; you may be prompted for your password on $SshTarget."
        }

        Get-Content -LiteralPath $pubPath -Raw -Encoding ascii | & $ssh.Path @opts $SshTarget $remoteCmd
        Write-Info "Key installed. Test with: ssh $($opts -join ' ') $SshTarget"
    } else {
        Write-Info "Skip remote install (no -SshTarget provided)."
    }

    exit 0
} catch {
    Write-Err $_
    exit 1
}

param(
    [Parameter(Mandatory = $true)] [string] $SshTarget,
    [string] $SshOptions = "-o StrictHostKeyChecking=accept-new",
    [int] $ConnectTimeoutSec = 5
)

$ErrorActionPreference = 'Stop'

function Info ($m) { Write-Host "[INFO] $m" }
function Warn ($m) { Write-Warning $m }
function Err ($m) { Write-Error $m }

try {
    $ssh = Get-Command ssh -ErrorAction SilentlyContinue
    if (-not $ssh) { throw "ssh not found. Install OpenSSH Client from Windows Optional Features or winget." }

    $opts = @()
    if ($SshOptions) {
        if ($SshOptions -match '^-o\s+.+') {
            $opts += ($SshOptions -replace '^-o\s+', '-o')
        } elseif ($SshOptions -match '\s' -and -not ($SshOptions.Trim().StartsWith('"') -or $SshOptions.Trim().StartsWith("'"))) {
            $opts += ($SshOptions -split '\\s+')
        } else {
            $opts += $SshOptions
        }
    }
    if (-not ($opts -match '^-o?ConnectTimeout')) { $opts += "-oConnectTimeout=$ConnectTimeoutSec" }

    Info "Checking SSH connectivity to $SshTarget (no login prompt)"
    $argv = @($opts + @('-oBatchMode=yes', $SshTarget, 'true'))
    $p = Start-Process -FilePath $ssh.Path -ArgumentList $argv -NoNewWindow -PassThru -Wait -RedirectStandardOutput ([System.IO.Path]::GetTempFileName()) -RedirectStandardError ([System.IO.Path]::GetTempFileName())
    if ($p.ExitCode -eq 0) {
        Info "OK: passwordless connection works"
        exit 0
    } else {
        Warn "Not reachable or passwordless login not set. Try interactive: ssh $($opts -join ' ') $SshTarget"
        exit 2
    }
} catch {
    Err $_
    exit 1
}

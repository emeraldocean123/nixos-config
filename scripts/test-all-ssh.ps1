# Test SSH connectivity to all systems
Write-Host "===== TESTING SSH CONNECTIVITY =====" -ForegroundColor Cyan
Write-Host ""

$systems = @(
    @{Name="GitHub"; Host="github.com"; User="git"; Test="ssh -T"},
    @{Name="Synology NAS"; Host="nas"; User="joseph"; Test="ssh"},
    @{Name="HP Laptop"; Host="hp"; User="joseph"; Test="ssh"},
    @{Name="MSI Laptop"; Host="msi"; User="joseph"; Test="ssh"},
    @{Name="Proxmox Host"; Host="proxmox"; User="root"; Test="ssh"},
    @{Name="WireGuard LXC"; Host="wireguard"; User="root"; Test="ssh"},
    @{Name="Tailscale LXC"; Host="tailscale"; User="root"; Test="ssh"},
    @{Name="Omada LXC"; Host="omada"; User="root"; Test="ssh"},
    @{Name="NetBox LXC"; Host="netbox"; User="root"; Test="ssh"},
    @{Name="iVentoy LXC"; Host="iventoy"; User="root"; Test="ssh"},
    @{Name="Docker LXC"; Host="docker"; User="root"; Test="ssh"},
    @{Name="Syncthing LXC"; Host="syncthing"; User="root"; Test="ssh"}
)

$successful = 0
$failed = 0

foreach ($system in $systems) {
    Write-Host -NoNewline "$($system.Name): " -ForegroundColor Yellow
    
    if ($system.Host -eq "github.com") {
        # Special handling for GitHub
        $result = & ssh -T git@github.com 2>&1
        if ($result -like "*successfully authenticated*") {
            Write-Host "Connected" -ForegroundColor Green
            $successful++
        } else {
            Write-Host "Failed" -ForegroundColor Red
            $failed++
        }
    } else {
        # Test other systems
        $result = & ssh -o ConnectTimeout=2 -o PasswordAuthentication=no $system.Host "hostname" 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Connected ($result)" -ForegroundColor Green
            $successful++
        } else {
            Write-Host "Failed" -ForegroundColor Red
            $failed++
        }
    }
}

Write-Host ""
Write-Host "===== SUMMARY =====" -ForegroundColor Cyan
Write-Host "Successful: $successful" -ForegroundColor Green
Write-Host "Failed: $failed" -ForegroundColor Red
Write-Host ""

if ($failed -eq 0) {
    Write-Host "All systems accessible with unified SSH key!" -ForegroundColor Green
} else {
    Write-Host "Some systems need attention" -ForegroundColor Yellow
}
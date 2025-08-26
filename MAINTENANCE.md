# NixOS Configuration Maintenance Guide

This document provides comprehensive maintenance procedures for the NixOS configuration repository.

## Security Updates and Version Management

### Update Schedule

- **Security Updates**: Apply immediately when available
- **Regular Updates**: Monthly on the first weekend
- **Major Version Updates**: Follow NixOS release cycle (typically every 6 months)

### Update Procedures

#### 1. Preview Available Updates

```bash
# Check what updates are available
./scripts/update-flake-inputs.sh preview

# Or manually:
nix flake update --dry-run
```

#### 2. Update All Inputs (Monthly)

```bash
# Update all inputs with automatic validation
./scripts/update-flake-inputs.sh update

# Manual process:
nix flake update
nix build .#nixosConfigurations.hp-dv9500-pavilion-nixos.config.system.build.toplevel --dry-run
nix build .#nixosConfigurations.msi-ge75-raider-nixos.config.system.build.toplevel --dry-run
```

#### 3. Security-Only Updates

```bash
# Pin to latest stable security versions
./scripts/update-flake-inputs.sh pin-security

# Update specific critical inputs only:
./scripts/update-flake-inputs.sh update-input nixpkgs
./scripts/update-flake-inputs.sh update-input home-manager
```

#### 4. Validate Configuration

```bash
# Validate current configuration
./scripts/update-flake-inputs.sh validate

# Or manually:
nix flake check
nix build .#nixosConfigurations.hp-dv9500-pavilion-nixos.config.system.build.toplevel --dry-run
nix build .#nixosConfigurations.msi-ge75-raider-nixos.config.system.build.toplevel --dry-run
```

## Backup and Recovery

### Automated Backups

The system automatically creates backups:
- **Daily**: Configuration backup at 3 AM
- **Retention**: 10 most recent backups
- **Location**: `/var/backups/nixos/`

### Manual Backup Operations

```bash
# Create immediate backup
sudo systemctl start backup-nixos-config.service

# Check backup status
nixos-backup-status

# List available backups
ls -la /var/backups/nixos/config/
```

### Recovery Procedures

#### Restore from Backup

```bash
# Restore latest backup
sudo nixos-config-restore latest

# Restore specific backup
sudo nixos-config-restore /var/backups/nixos/config/nixos-config-20250118_030000.tar.gz

# Apply restored configuration
sudo nixos-rebuild switch
```

#### Emergency Recovery

If the system is unbootable:

1. Boot from NixOS installer USB
2. Mount the system:
   ```bash
   sudo mount /dev/disk/by-label/nixos /mnt
   sudo mount /dev/disk/by-label/boot /mnt/boot  # For UEFI systems
   ```
3. Restore configuration:
   ```bash
   sudo tar -xzf /mnt/var/backups/nixos/config/nixos-config-*.tar.gz -C /mnt/etc/nixos/
   ```
4. Rebuild:
   ```bash
   sudo nixos-rebuild switch --root /mnt
   ```

## Hardware Configuration Updates

### HP dv9500 Pavilion

**Current Status**: Uses template hardware configuration with placeholders.

**Required Action on First Deployment**:
```bash
# On the HP machine:
sudo nixos-generate-config --root /etc/nixos --show-hardware-config > /tmp/hardware-configuration.nix

# Replace the template:
sudo cp /tmp/hardware-configuration.nix /etc/nixos/hosts/hp-dv9500-pavilion-nixos/hardware-configuration.nix

# Commit changes:
cd /etc/nixos
git add hosts/hp-dv9500-pavilion-nixos/hardware-configuration.nix
git commit -m "Add real hardware configuration for HP dv9500"
git push
```

### MSI GE75 Raider

**Current Status**: Has real hardware configuration generated from actual hardware.

**Maintenance**: No action required unless hardware changes.

## Security Monitoring

### Regular Security Checks

```bash
# Check for security advisories
nix flake update --dry-run 2>&1 | grep -i security

# Review SSH configuration
sudo systemctl status sshd
sudo journalctl -u sshd -f

# Check firewall status
sudo systemctl status firewall
sudo iptables -L

# Review fail2ban logs
sudo systemctl status fail2ban
sudo fail2ban-client status
```

### Security Hardening Verification

```bash
# Verify CPU mitigations are enabled
cat /proc/cmdline | grep -o mitigations=.*

# Check SSH hardening
sudo sshd -T | grep -E "(PasswordAuthentication|PermitRootLogin|Protocol)"

# Verify audit daemon
sudo systemctl status auditd
```

## Performance Monitoring

### System Performance

```bash
# Check boot time
systemd-analyze
systemd-analyze blame
systemd-analyze critical-chain

# Monitor resource usage
htop
iotop
nethogs

# Check gaming optimizations (MSI only)
gamemode --status
```

### Storage Management

```bash
# Check Nix store usage
du -sh /nix/store/

# Clean up old generations
sudo nix-collect-garbage --delete-older-than 30d

# Optimize Nix store
sudo nix-store --optimize

# Check SSD health (if applicable)
sudo smartctl -a /dev/nvme0n1  # For NVMe drives
sudo smartctl -a /dev/sda      # For SATA drives
```

## Common Maintenance Tasks

### Weekly Tasks

1. Check system logs: `sudo journalctl --since "1 week ago" | grep -i error`
2. Update package cache: `nix-channel --update`
3. Check disk usage: `df -h`
4. Verify backup status: `nixos-backup-status`

### Monthly Tasks

1. Update flake inputs: `./scripts/update-flake-inputs.sh update`
2. Clean old generations: `sudo nix-collect-garbage --delete-older-than 30d`
3. Review security logs: `sudo journalctl -u fail2ban --since "1 month ago"`
4. Check hardware health: `sudo sensors` and `sudo smartctl -a /dev/nvme0n1`

### After Major Updates

1. Test both host configurations: `nix build .#nixosConfigurations.{hp-dv9500-pavilion-nixos,msi-ge75-raider-nixos}.config.system.build.toplevel`
2. Verify services: `sudo systemctl --failed`
3. Check logs: `sudo journalctl -p err --since today`
4. Test SSH access from Windows machine
5. Verify graphics and desktop environments work correctly

## Troubleshooting

### Common Issues

#### Build Failures
```bash
# Clean build environment
nix-collect-garbage
nix-store --verify --check-contents

# Rebuild with verbose output
sudo nixos-rebuild switch --show-trace -v
```

#### SSH Connection Issues
```bash
# Check SSH service
sudo systemctl status sshd
sudo journalctl -u sshd -f

# Test configuration
sudo sshd -T

# Check firewall
sudo iptables -L | grep ssh
```

#### Graphics Issues
```bash
# Check graphics drivers (HP)
lspci | grep VGA
lsmod | grep radeon

# Check NVIDIA status (MSI)
nvidia-smi
lsmod | grep nvidia
```

### Emergency Contacts

- **System Administrator**: User (emeraldocean123@users.noreply.github.com)
- **NixOS Community**: [NixOS Discourse](https://discourse.nixos.org/)
- **Security Issues**: Report to NixOS security team

## Change Log

All maintenance activities should be logged here:

### 2025-01-18
- Implemented comprehensive maintenance procedures
- Added automated backup system
- Enhanced security hardening
- Fixed critical CPU mitigation bypass
- Removed duplicate user configurations
- Added gaming optimizations for MSI laptop
- Enhanced legacy hardware support for HP laptop

---

**Next Scheduled Maintenance**: First weekend of February 2025
**Last Security Update**: 2025-01-18
**Configuration Version**: v2.0.0 (major security update)

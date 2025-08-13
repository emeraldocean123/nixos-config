# MSI GE75 Raider NixOS Migration Guide

## ⚠️ CRITICAL: Never Copy hardware-configuration.nix!

The `hardware-configuration.nix` file contains machine-specific UUIDs and device paths that are UNIQUE to each installation. Using the wrong UUIDs will cause your system to fail to boot!

## Safe Migration Process

### Step 1: Fresh NixOS Installation
1. Install NixOS normally using the installer
2. Let the installer generate the correct `hardware-configuration.nix` for YOUR hardware
3. Boot into your new NixOS system to verify it works

### Step 2: Note Your Hardware Configuration
**Before applying any custom configuration**, save your working hardware config:

```bash
# Save your current working hardware configuration
sudo cp /etc/nixos/hardware-configuration.nix ~/hardware-configuration.backup

# View your actual disk UUIDs
lsblk -f
blkid
```

### Step 3: Apply Custom Configuration

#### Option A: Using Git (Recommended)
```bash
# Clone the configuration
cd ~
git clone https://github.com/emeraldocean123/nixos-config.git

# IMPORTANT: Preserve YOUR hardware configuration
cp ~/hardware-configuration.backup ~/nixos-config/hosts/msi-ge75-raider-nixos/hardware-configuration.nix

# Now rebuild with YOUR hardware config
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#msi-ge75-raider-nixos
```

#### Option B: Direct Copy
```bash
# Copy configuration to /etc/nixos
sudo cp -r ~/nixos-config/* /etc/nixos/

# CRITICAL: Restore YOUR hardware configuration
sudo cp ~/hardware-configuration.backup /etc/nixos/hardware-configuration.nix

# Rebuild
sudo nixos-rebuild switch
```

## What the Assertions Check

The configuration includes safety assertions that will PREVENT a build if:

1. **Placeholder UUIDs detected** (all zeros)
2. **Repository example UUIDs detected** (from GitHub)
3. **Missing or empty hardware-configuration.nix**

These will show an error like:
```
error: FATAL: Repository's example UUIDs detected! Run 'sudo nixos-generate-config' to create YOUR machine-specific configuration!
```

## If System Won't Boot (Recovery)

If you accidentally used wrong UUIDs and can't boot:

1. Boot from NixOS installer USB
2. Mount your root partition:
   ```bash
   sudo mount /dev/nvme0n1p2 /mnt  # Adjust device as needed
   sudo mount /dev/nvme0n1p1 /mnt/boot  # Mount boot partition
   ```
3. Generate correct hardware config:
   ```bash
   sudo nixos-generate-config --root /mnt
   ```
4. Rebuild from chroot:
   ```bash
   sudo nixos-enter --root /mnt -- nixos-rebuild boot
   ```
5. Reboot

## Remember

- **ALWAYS** run `nixos-generate-config` on the target machine
- **NEVER** copy `hardware-configuration.nix` between machines
- **ALWAYS** test in a VM first if unsure
- **KEEP** a backup of your working `hardware-configuration.nix`

## Validation Checklist

Before rebuilding:
- [ ] I have run `nixos-generate-config` on THIS machine
- [ ] The UUIDs in `hardware-configuration.nix` match my `blkid` output
- [ ] I have tested the configuration syntax with `nixos-rebuild dry-build`
- [ ] I have a bootable USB ready in case of issues
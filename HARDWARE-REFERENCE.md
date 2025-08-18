# Hardware Reference Documentation

This file contains the definitive hardware specifications for all machines in the nixos-config repository. This information should be referenced whenever making configuration changes to ensure hardware-specific optimizations are accurate.

## MSI GE75 Raider 9SF (msi-ge75-raider-nixos)

**Last Updated**: August 17, 2025  
**Source**: Live fastfetch output from running system  
**Network Address**: 192.168.1.106

### System Information
- **Model**: MSI GE75 Raider 9SF (REV:1.0)
- **OS**: NixOS 25.05 (Warbler) x86_64
- **Kernel**: Linux 6.12.41
- **Uptime**: Current session shows good stability
- **Packages**: 1898 (nix-system)
- **Shell**: bash 5.2.37
- **Locale**: en_US.UTF-8

### CPU
- **Model**: Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
- **Architecture**: x86_64
- **Cores**: 12 threads (6 cores with hyperthreading)
- **Max Frequency**: 4.50 GHz (boost)
- **Generation**: 9th gen Intel Coffee Lake-H

### Graphics
- **GPU 1**: NVIDIA GeForce RTX 2070 Mobile [Discrete]
- **GPU 2**: Intel UHD Graphics 630 @ 1.15 GHz [Integrated]
- **Display Manager**: Wayland with KWin
- **Desktop Environment**: KDE Plasma 6

### Display
- **Panel**: AUO409D
- **Resolution**: 1920x1080 @ 144Hz
- **Size**: 17" Built-in
- **Type**: Gaming laptop display with high refresh rate

### Memory & Storage
- **RAM**: 64GB total (62.64 GiB usable)
- **Current Usage**: ~2.2GB used, 60GB available
- **Swap**: 68.91 GiB configured on NVMe
- **Primary Storage**: Dual NVMe SSD configuration
  - **NVMe0 (System)**: 1.8TB NVMe SSD (root, nix/store, boot)
  - **NVMe1 (Data)**: 1.9TB NVMe SSD (additional storage)
  - **External**: 239GB USB SDA device
- **Partitioning**: 
  - `/boot`: 1GB (nvme0n1p1)
  - `/` and `/nix/store`: 1.8TB (nvme0n1p2)
  - `[SWAP]`: 68.9GB (nvme0n1p3)

### Network
- **Interface**: wlp3s0f0 (WiFi)
- **IP Address**: 192.168.1.106/24
- **Connection**: Wireless

### Power
- **Battery**: BIF0_9
- **Status**: Supports charging with AC adapter
- **Current State**: 81% charged, AC connected

### Configuration Notes
- **Gaming Laptop**: High-performance laptop optimized for gaming and development
- **Dual GPU Setup**: Hybrid graphics with Intel UHD 630 integrated + RTX 2070 Mobile discrete
- **High Refresh Display**: 144Hz panel optimized for competitive gaming
- **Large RAM**: 64GB total - excellent for development, virtualization, and gaming
- **Dual NVMe Storage**: Fast dual SSD configuration with 3.7TB total capacity
- **Intel 9th Gen**: Coffee Lake-H architecture with 6 cores, 12 threads
- **KDE Plasma 6**: Running on Wayland with modern desktop environment
- **Current Status**: Stable, low memory usage, good thermals

---

## HP dv9500 Pavilion (hp-dv9500-pavilion-nixos)

**Last Updated**: August 17, 2025 (Configuration based on model specifications)  
**Network Address**: 192.168.1.104  
**Status**: Template configuration - hardware-configuration.nix needs generation on first boot

### System Information
- **Model**: HP dv9500 Pavilion
- **Year**: ~2007 (Legacy hardware)
- **Architecture**: x86_64

### CPU
- **Model**: AMD Turion 64 X2
- **Architecture**: AMD64 (x86_64)
- **Generation**: Legacy dual-core processor

### Graphics
- **GPU**: NVIDIA GeForce 7150M
- **Driver**: nvidia-304xx (legacy driver required)
- **Type**: Legacy mobile graphics from 2007
- **Features**: Basic 3D acceleration, limited modern driver support

### Memory & Storage
- **RAM**: Typically 2-4GB (exact amount TBD on first boot)
- **Storage**: Variable (will be determined by hardware-configuration.nix generation)

### Configuration Notes
- **Legacy Hardware**: Requires conservative power management
- **Limited Performance**: Optimized for stability over performance
- **Legacy Drivers**: Requires nvidia-304xx legacy driver package
- **First Boot Required**: Must generate hardware-configuration.nix with actual UUIDs and device paths

---

## Configuration Guidelines

### When modifying nixos-config:

1. **Always reference this file** before making hardware-specific changes
2. **Update this file** when hardware changes or new information is discovered
3. **Test on target hardware** before assuming configurations will work
4. **Use appropriate optimizations**:
   - MSI: Performance-focused (gaming, development)
   - HP: Stability-focused (legacy compatibility)

### Hardware Detection Commands

To update this documentation:

```bash
# Generate comprehensive hardware info
fastfetch > hardware-info.txt

# Check CPU details
cat /proc/cpuinfo

# Check memory
free -h

# Check graphics
lspci | grep -E "VGA|3D|Display"

# Check storage
lsblk
df -h

# Check network interfaces
ip a
```

### Updating This File

When hardware information changes:
1. Update the relevant section
2. Update the "Last Updated" timestamp
3. Commit changes with descriptive message
4. Ensure all team members are aware of hardware changes

This reference ensures all nixos-config modifications are made with accurate hardware knowledge.
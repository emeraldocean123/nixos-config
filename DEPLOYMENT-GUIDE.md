# 🚀 NixOS Dotfiles Deployment Guide

This guide will help you deploy the updated dotfiles configuration to your HP and MSI laptops.

## 📋 What's Been Updated

### ✅ **Shared Dotfiles Module** (`modules/shared/dotfiles.nix`)
- Comprehensive Git configuration with aliases
- Enhanced Bash configuration with 50+ aliases and functions
- Nano editor configuration
- Readline configuration for better command-line editing
- Oh My Posh integration with custom theme

### ✅ **Host-Specific Configurations**
- **HP dv9500**: Legacy hardware optimizations, battery monitoring
- **MSI GE75**: Gaming optimizations, GPU monitoring, performance modes

### ✅ **User Configurations Updated**
- Both HP and MSI joseph.nix files now import shared dotfiles
- Host-specific customizations preserved
- Oh My Posh theme properly configured

## 🔄 Deployment Steps

### 1. **Connect to Your Laptops**

#### For HP Laptop:
```bash
ssh joseph@hp-dv9500-pavilion-nixos.local
# or use the IP address if hostname doesn't resolve
ssh joseph@<HP_IP_ADDRESS>
```

#### For MSI Laptop:
```bash
ssh joseph@msi-ge75-raider-nixos.local
# or use the IP address if hostname doesn't resolve
ssh joseph@<MSI_IP_ADDRESS>
```

### 2. **Copy Updated Configuration Files**

You need to copy these files to `/etc/nixos/` on each laptop:

```bash
# On each laptop, copy the updated files from your local workspace
# Method 1: Using scp from your Windows machine
scp -r c:\Users\emera\OneDrive\Documents\VSCode\nixos-config\modules\shared joseph@<LAPTOP_IP>:/tmp/
scp c:\Users\emera\OneDrive\Documents\VSCode\nixos-config\home\<laptop-specific>\joseph.nix joseph@<LAPTOP_IP>:/tmp/
scp c:\Users\emera\OneDrive\Documents\VSCode\nixos-config\deploy-dotfiles.sh joseph@<LAPTOP_IP>:/tmp/

# Then on the laptop:
sudo cp -r /tmp/shared /etc/nixos/modules/
sudo cp /tmp/joseph.nix /etc/nixos/home/<laptop-specific>/
sudo cp /tmp/deploy-dotfiles.sh /etc/nixos/
sudo chmod +x /etc/nixos/deploy-dotfiles.sh
```

### 3. **Run Deployment Script**

On each laptop:

```bash
cd /etc/nixos
sudo ./deploy-dotfiles.sh
```

Choose option **6** for full deployment (recommended for first time).

### 4. **Alternative Manual Deployment**

If you prefer manual control:

```bash
# Check configuration syntax
sudo nixos-rebuild dry-build --flake /etc/nixos#$(hostname)

# Test configuration (temporary)
sudo nixos-rebuild test --flake /etc/nixos#$(hostname)

# Apply configuration (permanent)
sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)
```

## 🎯 What You'll Get After Deployment

### **Bash Aliases Available:**
- **Navigation**: `..`, `...`, `....`
- **Git shortcuts**: `gs`, `ga`, `gc`, `gp`, `gl`
- **File operations**: `ll`, `la`, `l`
- **System info**: `meminfo`, `cpuinfo`, `ports`
- **NixOS shortcuts**: `nrs`, `nrt`, `nfu`

### **Useful Functions:**
- `extract()` - Extract any compressed file
- `mkcd()` - Create and enter directory
- `ff()` - Find files by name
- `fd()` - Find directories by name
- `port()` - Show processes using a port

### **Host-Specific Features:**

#### HP dv9500:
- `battery` - Show battery percentage
- `temp` - Show temperature sensors
- `hpstatus` - Complete system status
- `legacy_mode()` - Legacy compatibility helpers

#### MSI GE75:
- `gpu-temp`, `gpu-usage`, `gpu-info` - GPU monitoring
- `performance`, `powersave` - CPU frequency control
- `sysperf` - Complete performance overview
- `gaming_mode()`, `power_save()` - Power management

### **Oh My Posh Prompt:**
- Beautiful colored prompt with git branch info
- Execution time display
- Current time display
- System status indicators

## 🔧 Troubleshooting

### **If SSH connection fails:**
1. Make sure the laptop is powered on and connected to network
2. Try using IP address instead of hostname
3. Check if SSH is enabled: `sudo systemctl status sshd`

### **If configuration fails:**
1. Check syntax: `sudo nixos-rebuild dry-build --flake /etc/nixos#$(hostname)`
2. Review error messages carefully
3. Check file permissions: `sudo chown -R root:root /etc/nixos`

### **If dotfiles don't work after deployment:**
1. Log out and log back in
2. Run: `source ~/.bashrc`
3. Check Oh My Posh: `oh-my-posh --version`

## 📝 Post-Deployment Verification

After successful deployment, verify everything works:

```bash
# Test aliases
gs  # Should show git status
ll  # Should show detailed file listing

# Test functions
extract --help  # Should show extraction help
mkcd test_dir   # Should create and enter directory

# Test host-specific features
# On HP: hpstatus
# On MSI: sysperf

# Test Oh My Posh
# You should see a colorful prompt with git info
```

## 🎉 Success!

Once deployed, you'll have a consistent, powerful dotfiles environment across both laptops with:
- ✅ Unified configuration management
- ✅ Host-specific optimizations
- ✅ Beautiful Oh My Posh prompt
- ✅ 50+ useful aliases and functions
- ✅ Git integration and shortcuts
- ✅ System monitoring tools

Your dotfiles are now managed declaratively through NixOS and will be consistent across rebuilds!

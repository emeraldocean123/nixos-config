# 🖥️ NixOS Configuration Repository

**Comprehensive NixOS and Home Manager configuration using Nix flakes**

This repository provides a modular, maintainable NixOS configuration for multiple hosts with integrated dotfiles management, user-specific configurations, and host-optimized settings.

## 🏠 **Supported Systems**

| Host | Hardware | Description | Status |
|------|----------|-------------|--------|
| `hp-dv9500-pavilion-nixos` | HP dv9500 Pavilion (2007)<br/>AMD Turion 64 X2, NVIDIA GeForce 7150M | Legacy laptop with LXQt desktop | ✅ Active |
| `msi-ge75-raider-nixos` | MSI GE75 Raider 9SF (2018)<br/>Intel i7-9750H, RTX 2070 | Gaming laptop with KDE Plasma | ✅ Active |

## 👥 **User Configurations**

- **joseph** - Primary user (available on both hosts)
- **follett** - Secondary user (HP laptop only)

## �️ **Repository Structure**

```
nixos-config/
├── 📄 flake.nix                       # Main flake configuration
├── 📄 flake.lock                      # Reproducible dependency versions
├── 📄 deploy-dotfiles.sh              # Automated deployment script
├── 📄 DEPLOYMENT-GUIDE.md             # Step-by-step deployment instructions
├── 📄 CLEANUP-REVIEW.md               # Repository cleanup documentation
│
├── 🏠 hosts/                          # Host-specific configurations
│   ├── hp-dv9500-pavilion-nixos/
│   │   ├── configuration.nix          # Host-specific settings
│   │   └── hardware-configuration.nix # Auto-generated hardware config
│   └── msi-ge75-raider-nixos/
│       ├── configuration.nix          # Host-specific settings
│       └── hardware-configuration.nix # Auto-generated hardware config
│
├── 🏡 home/                           # Home Manager user configurations
│   ├── hp-dv9500-pavilion-nixos/
│   │   ├── joseph.nix                 # Joseph's HP laptop config
│   │   └── follett.nix                # Follett's HP laptop config
│   └── msi-ge75-raider-nixos/
│       └── joseph.nix                 # Joseph's MSI laptop config
│
└── 🧩 modules/                        # Modular configuration components
    ├── common.nix                     # Shared across all hosts
    ├── shared/
    │   ├── dotfiles.nix               # Unified dotfiles management
    │   └── jandedobbeleer.omp.json    # Oh My Posh theme
    ├── hp-dv9500-pavilion-nixos/     # HP-specific modules
    │   ├── hardware.nix               # Hardware configuration
    │   ├── desktop.nix                # LXQt desktop environment
    │   ├── networking.nix             # Network settings
    │   ├── packages.nix               # System packages
    │   ├── services.nix               # System services
    │   └── users.nix                  # User management
    └── msi-ge75-raider-nixos/         # MSI-specific modules
        ├── hardware.nix               # Hardware configuration
        ├── desktop.nix                # KDE Plasma desktop
        ├── nvidia.nix                 # NVIDIA GPU settings
        ├── networking.nix             # Gaming-optimized networking
        ├── packages.nix               # Gaming packages
        ├── services.nix               # Gaming services
        └── users.nix                  # Gaming-optimized users
```

## 🚀 **Quick Start Guide**

### **Prerequisites**
- NixOS installed with flakes enabled
- Git available on the system
- Sudo access for system configuration

### **1. Initial Setup**

Clone this repository to `/etc/nixos`:
```bash
# Backup existing configuration
sudo cp -r /etc/nixos /etc/nixos.backup

# Clone the configuration
sudo rm -rf /etc/nixos
sudo git clone https://github.com/emeraldocean123/nixos-config.git /etc/nixos
cd /etc/nixos
```

### **2. Quick Deployment**

Use the automated deployment script:
```bash
# Make script executable
sudo chmod +x deploy-dotfiles.sh

# Run deployment wizard
sudo ./deploy-dotfiles.sh
```

**Recommended**: Choose option 6 (Full deployment) for first-time setup.

### **3. Manual Deployment**

For more control over the process:
```bash
# Check configuration syntax
sudo nixos-rebuild dry-build --flake .#$(hostname)

# Test configuration (temporary)
sudo nixos-rebuild test --flake .#$(hostname)

# Apply configuration (permanent)
sudo nixos-rebuild switch --flake .#$(hostname)
```

## ✨ **Features**

### **🎨 Unified Dotfiles Management**
- **50+ shell aliases** for productivity
- **Custom functions** for file management, system monitoring
- **Oh My Posh** integration with beautiful prompts
- **Git integration** with shortcuts and automation
- **Host-specific customizations** for HP and MSI laptops

### **🖥️ Host-Specific Optimizations**

#### **HP dv9500 Pavilion (Legacy Laptop)**
- **LXQt desktop** optimized for older hardware
- **Power management** for battery longevity
- **Legacy hardware support** with Nouveau drivers
- **Conservative resource usage**

#### **MSI GE75 Raider (Gaming Laptop)**
- **KDE Plasma** desktop with gaming enhancements
- **NVIDIA RTX 2070** support with optimizations
- **Gaming packages** (Steam, Lutris, GameMode)
- **Performance monitoring** tools

### **👤 User Environment Features**
- **Consistent shell experience** across hosts
- **Development tools** and productivity packages
- **Gaming optimizations** (MSI) vs. legacy support (HP)
- **SSH and remote development** support

## 🎯 **What You Get After Deployment**

### **🔧 Shell Aliases & Functions**
```bash
# Navigation
..          # cd ..
...         # cd ../..
ll          # ls -lah with colors

# Git shortcuts  
gs          # git status
ga          # git add
gc          # git commit
gp          # git push

# NixOS shortcuts
nrs         # nixos-rebuild switch
nrt         # nixos-rebuild test
nfu         # nix flake update

# Utilities
extract     # Extract any archive format
mkcd        # Create and enter directory
port 8080   # Show what's using port 8080
```

### **🖥️ Host-Specific Commands**

#### **HP Laptop**
```bash
hpstatus    # Complete system overview
battery     # Show battery percentage
temp        # Show temperature sensors
```

#### **MSI Laptop**
```bash
sysperf     # Gaming performance monitor
gpu-temp    # NVIDIA GPU temperature
gaming_mode # Activate performance mode
```

### **🎨 Beautiful Terminal**
- **Oh My Posh prompt** with git branch info
- **Execution time** display
- **System status** indicators
- **Custom theme** with consistent colors

2. Apply configuration for your host:
   ```bash
   # For HP dv9500 Pavilion
   sudo nixos-rebuild switch --flake .#hp-dv9500-pavilion-nixos
   
   # For MSI GE75 Raider (currently commented out in flake.nix)
   # sudo nixos-rebuild switch --flake .#msi-ge75-raider-nixos
   ```

### Daily Usage

```bash
# Rebuild system configuration
sudo nixos-rebuild switch --flake .

# Update flake inputs and rebuild
sudo nix flake update
sudo nixos-rebuild switch --flake .

# Test configuration without activation
sudo nixos-rebuild test --flake .

# Check what would be built without building
sudo nixos-rebuild dry-build --flake .
```

### Home Manager

Home Manager configurations are integrated into the flake and will be applied automatically with the system configuration.

## 🔧 Configuration Details

### NixOS Version
- **Channel**: NixOS 25.05 (stable)
- **Home Manager**: release-25.05

### Key Features
- **Flake-based configuration** for reproducibility
- **Multiple host support** with shared modules
- **Home Manager integration** for user-specific configurations
- **Modular structure** for easy maintenance

## 📝 Making Changes

1. Create a new branch for your changes:
   ```bash
   git checkout -b feature/your-change
   ```

2. Edit the appropriate configuration files

3. Test your changes:
   ```bash
   sudo nixos-rebuild test --flake .
   ```

4. If everything works, commit and apply:
   ```bash
   git add .
   git commit -m "Description of changes"
   sudo nixos-rebuild switch --flake .
   ```

## 🔧 **Troubleshooting**

### **Common Issues**

#### **Configuration Fails to Build**
```bash
# Check syntax first
sudo nixos-rebuild dry-build --flake .#$(hostname)

# Check for missing files
ls -la /etc/nixos/modules/shared/
ls -la /etc/nixos/home/$(hostname | cut -d'-' -f1-3)/
```

#### **SSH Connection Issues**
```bash
# Check SSH service status
sudo systemctl status sshd

# Find IP address
ip addr show | grep inet
```

#### **Oh My Posh Not Working**
```bash
# Check if Oh My Posh is installed
oh-my-posh --version

# Reload bash configuration
source ~/.bashrc
```

### **Rollback Instructions**
```bash
# Rollback to previous generation
sudo nixos-rebuild switch --rollback
```

## 🛠️ **Maintenance**

### **Regular Updates**
```bash
# Update flake inputs
sudo nix flake update /etc/nixos

# Rebuild with latest packages
sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)

# Clean up old generations
sudo nix-collect-garbage --delete-older-than 7d
```

### **Adding New Software**
Edit the appropriate packages.nix file:
- HP: `modules/hp-dv9500-pavilion-nixos/packages.nix`
- MSI: `modules/msi-ge75-raider-nixos/packages.nix`

Then rebuild: `sudo nixos-rebuild switch --flake .#$(hostname)`

## 📚 **Additional Documentation**

- **[DEPLOYMENT-GUIDE.md](DEPLOYMENT-GUIDE.md)** - Step-by-step deployment instructions
- **[CLEANUP-REVIEW.md](CLEANUP-REVIEW.md)** - Repository cleanup documentation
- **[modules/shared/dotfiles.nix](modules/shared/dotfiles.nix)** - Unified dotfiles management

## 🎯 **Post-Deployment Verification**

After successful deployment, you should have:
- ✅ **50+ shell aliases** for productivity
- ✅ **Beautiful Oh My Posh prompt** with git integration
- ✅ **Host-optimized desktop** (LXQt for HP, KDE for MSI)
- ✅ **Gaming setup** (MSI) or **legacy support** (HP)
- ✅ **SSH access** for remote development
- ✅ **Declarative system management** through NixOS

---

**🎉 Result**: Professional, maintainable NixOS configuration with integrated dotfiles across multiple systems!
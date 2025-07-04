# NixOS Configuration

NixOS and Home Manager configuration for multiple hosts and users using Nix flakes.

## 🖥️ Hosts

| Host | Hardware | Description |
|------|----------|-------------|
| `hp-dv9500-pavilion-nixos` | HP dv9500 Pavilion (2007, AMD Turion 64 X2, NVIDIA GeForce 7150M) | Legacy laptop configuration |
| `msi-ge75-raider-nixos` | MSI GE75 Raider 9SF (2018, Intel Core i7-9750H, RTX 2070) | Gaming laptop configuration |

## 👥 Users

- **joseph** - Available on both hosts
- **follett** - Available on hp-dv9500-pavilion-nixos

## 📁 Repository Structure

```
├── flake.nix                           # Main flake configuration
├── flake.lock                          # Lock file for reproducible builds
├── hosts/                              # Host-specific configurations
│   ├── hp-dv9500-pavilion-nixos/
│   │   ├── configuration.nix           # Host-specific NixOS config
│   │   └── hardware-configuration.nix  # Auto-generated hardware config
│   └── msi-ge75-raider-nixos/
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── home/                               # Home Manager configurations
│   ├── hp-dv9500-pavilion-nixos/
│   │   ├── joseph.nix                  # User joseph on HP Pavilion
│   │   └── follett.nix                 # User follett on HP Pavilion
│   └── msi-ge75-raider-nixos/
│       └── joseph.nix                  # User joseph on MSI Raider
└── modules/                            # Shared configuration modules
    ├── common.nix                      # Shared across all hosts
    ├── hp-dv9500-pavilion-nixos/      # HP Pavilion specific modules
    └── msi-ge75-raider-nixos/          # MSI Raider specific modules
```

## 🚀 Quick Start

### Initial Setup

1. Clone this repository to `/etc/nixos`:
   ```bash
   sudo rm -rf /etc/nixos
   sudo git clone https://github.com/emeraldocean123/nixos-config.git /etc/nixos
   cd /etc/nixos
   ```

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

## 🏷️ File Header Standard

All `.nix` files follow this header format:
```nix
# /etc/nixos/<relative-path>
# <Brief purpose description> for <Device Name> (<Year>, <CPU>, <GPU>)
```

For example:
- HP files: `# Hardware-specific configuration for HP dv9500 Pavilion (2007, AMD Turion 64 X2, NVIDIA GeForce 7150M)`
- MSI files: `# KDE Plasma desktop and SDDM configuration for MSI GE75 Raider 9SF (2018, Intel Core i7-9750H, RTX 2070)`

## 🤝 Contributing

1. Open an issue to discuss changes
2. Create a feature branch
3. Test thoroughly on appropriate hardware
4. Submit a pull request with clear description

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
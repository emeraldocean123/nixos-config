# 🖥️ NixOS Configuration Repository

**Comprehensive NixOS and Home Manager configuration using Nix flakes**

This repository provides a modular, maintainable NixOS configuration for multiple hosts with integrated dotfiles management, user-specific configurations, and host-optimized settings.

---

## 🏠 Supported Systems

| Host                         | Hardware                                                                 | Description                       | Status   |
| ---------------------------- | ------------------------------------------------------------------------ | --------------------------------- | -------- |
| `hp-dv9500-pavilion-nixos` | HP dv9500 Pavilion (2007)<br/>AMD Turion 64 X2, NVIDIA GeForce 7150M | Legacy laptop with LXQt desktop   | ✅ Active |
| `msi-ge75-raider-nixos`    | MSI GE75 Raider 9SF (2018)<br/>Intel i7-9750H, RTX 2070                  | Gaming laptop with KDE Plasma     | ✅ Active |

---

## ⚙️ Hardware Specifications

This section provides a general overview of the hardware for each host, which is useful for tailoring NixOS modules.

### HP Pavilion dv9500 (c. 2007)

This model series had many variants. The configuration is tailored for the AMD/NVIDIA version.

-   **CPU**: AMD Turion 64 X2 (TL-58) or Intel Core 2 Duo (T5xxx/T7xxx series).
-   **Chipset**: Mobile Intel GM965/PM965 Express.
-   **GPU**: NVIDIA GeForce 7150M (in this config), with other models using GeForce 8400M or 8600M GS.
-   **RAM**: 2x DDR2 SODIMM slots, max 4GB (667MHz).
-   **Storage**: 2x 2.5" SATA I (1.5 Gb/s) drive bays.
-   **Display**: 17-inch WXGA+ (1440x900) or WSXGA+ (1680x1050).
-   **Networking**: 10/100 Ethernet, Broadcom or Intel Wireless-G, optional Bluetooth 2.0.

### MSI GE75 Raider 9SF (c. 2018)

A high-performance gaming laptop from the Coffee Lake era.

-   **CPU**: Intel Core i7-9750H (6-core, 12-thread).
-   **Chipset**: Intel HM370.
-   **GPU**: NVIDIA GeForce RTX 2070 (8GB GDDR6).
-   **RAM**: 2x DDR4 SODIMM slots (2666MHz), max 64GB.
-   **Storage**: 1x M.2 NVMe PCIe Gen3, 1x M.2 Combo (NVMe/SATA), 1x 2.5" SATA III bay.
-   **Display**: 17.3-inch FHD (1920x1080) IPS-Level, 144Hz.
-   **Networking**: Killer E2500 Gigabit Ethernet, Killer Wi-Fi 5 (802.11ac), Bluetooth 5.0.

---

## 🚀 Deployment and Management

This section provides all the necessary steps for deploying, managing, and accessing your systems.

### 1. Initial Setup on a New Machine

To bootstrap a new NixOS system with this configuration:

1.  **Install NixOS**: Perform a minimal NixOS installation. Ensure you have network connectivity and can access a terminal.

2.  **Enable Flakes**: Enable flakes support if it wasn't done during installation.
    ```bash
    # Add to /etc/nixos/configuration.nix
    nix.settings.extra-experimental-features = [ "nix-command" "flakes" ];
    ```

3.  **Clone the Repository**:
    ```bash
    # Backup the default configuration
    sudo mv /etc/nixos /etc/nixos.backup

    # Clone your configuration
    sudo git clone [https://github.com/emeraldocean123/nixos-config.git](https://github.com/emeraldocean123/nixos-config.git) /etc/nixos
    cd /etc/nixos
    ```

4.  **Deploy the System**: Run `nixos-rebuild` with the flake pointing to the correct host configuration.
    ```bash
    # For the HP Laptop
    sudo nixos-rebuild switch --flake .#hp-dv9500-pavilion-nixos

    # For the MSI Laptop
    sudo nixos-rebuild switch --flake .#msi-ge75-raider-nixos
    ```
    After the reboot, your system will be fully configured.

### 2. Daily Management Commands

Use these commands from within `/etc/nixos` to manage your system.

-   **Apply Changes**:
    ```bash
    sudo nixos-rebuild switch --flake .#$(hostname)
    ```

-   **Test Changes (without making them permanent)**:
    ```bash
    sudo nixos-rebuild test --flake .#$(hostname)
    ```

-   **Update All Dependencies (Flakes)**:
    ```bash
    sudo nix flake update
    # Then apply the changes
    sudo nixos-rebuild switch --flake .#$(hostname)
    ```

-   **Clean Up Old Generations**:
    ```bash
    sudo nix-collect-garbage --delete-older-than 7d
    ```

### 3. Remote Management (SSH)

SSH is enabled on both hosts for remote management.

-   **Connect to a Host**:
    ```bash
    ssh <user>@<hostname-or-ip>
    ```

-   **Helper Script**: A convenience script is provided to connect to the HP laptop.
    ```bash
    # From the repository root
    ./support/scripts/connection/connect-hp.sh
    ```

---

## ✨ Features & Customizations

### Unified Dotfiles
- **50+ shell aliases** for productivity.
- **Custom functions** for file management and system monitoring.
- **Oh My Posh** integration with a custom theme.
- **Git integration** with shortcuts and automation.

### Host-Specific Optimizations
- **HP dv9500 (Legacy)**: LXQt desktop, Nouveau drivers, and conservative power management.
- **MSI GE75 (Gaming)**: KDE Plasma, NVIDIA drivers, GameMode, and performance-tuned settings.

---

## 🔧 Troubleshooting

-   **Build Fails**: Run `sudo nixos-rebuild dry-build --flake .#$(hostname)` to check for syntax errors.
-   **SSH Issues**: Check the service with `sudo systemctl status sshd` and find the IP with `ip addr`.
-   **Rollback**: If a build fails or causes issues, roll back to the previous working generation:
    ```bash
    sudo nixos-rebuild switch --rollback
    ```

---

## 🏗️ Repository Structure

The repository is organized into four main Nix directories:

-   `hosts/`: Contains the entry-point `configuration.nix` for each machine.
-   `home/`: Contains user-specific Home Manager configurations.
-   `modules/`: Contains modular NixOS system configurations, broken down by function.
-   `support/`: Contains non-Nix helper scripts and documentation.
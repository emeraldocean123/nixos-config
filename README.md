🖥️ NixOS Configuration Repository
A comprehensive NixOS and Home Manager configuration using Nix flakes
This repository provides a modular, maintainable NixOS configuration for multiple hosts, integrating dotfiles management, user-specific configurations, and host-optimized settings.

🏗️ Repository Structure
The repository is organized around a main flake and three core directories for managing system and user configurations:

.github/ – GitHub Actions workflows and issue templates
.gitignore – Files and directories to ignore in version control
README.md – This file
flake.lock – Locked dependencies for reproducible builds
flake.nix – Main flake configuration
home/ – Home Manager configurations
hp-dv9500-pavilion-nixos/ – User configurations for HP Pavilion
msi-ge75-raider-nixos/ – User configurations for MSI Raider


hosts/ – Host-specific NixOS configurations
hp-dv9500-pavilion-nixos/ – HP Pavilion system settings
msi-ge75-raider-nixos/ – MSI Raider system settings


modules/ – Reusable NixOS modules
common.nix – Shared settings across hosts
hp-dv9500-pavilion-nixos/ – HP-specific modules
msi-ge75-raider-nixos/ – MSI-specific modules
shared/ – Common modules for all hosts




🏠 Supported Systems



Host
Hardware
Description
Status



hp-dv9500-pavilion-nixos
HP Pavilion dv9500 (2007)AMD Turion 64 X2, NVIDIA GeForce 7150M
Legacy laptop with LXQt desktop
✅ Active


msi-ge75-raider-nixos
MSI GE75 Raider 9SF (2018)Intel i7-9750H, NVIDIA RTX 2070
Gaming laptop with KDE Plasma
✅ Active



⚙️ Hardware Specifications
This section outlines the hardware for each host, aiding in tailoring NixOS modules.
HP Pavilion dv9500 (c. 2007)

CPU: AMD Turion 64 X2 (TL-58) or Intel Core 2 Duo (T5xxx/T7xxx series)
GPU: NVIDIA GeForce 7150M (this config); other models may use GeForce 8400M or 8600M GS
RAM: 2x DDR2 SODIMM slots, max 4GB (667 MHz)
Storage: 2x 2.5" SATA I (1.5 Gb/s) drive bays
Networking: 10/100 Ethernet, Broadcom or Intel Wireless-G, optional Bluetooth 2.0

MSI GE75 Raider 9SF (c. 2018)

CPU: Intel Core i7-9750H (6-core, 12-thread)
GPU: NVIDIA GeForce RTX 2070 (8GB GDDR6)
RAM: 2x DDR4 SODIMM slots (2666 MHz), max 64GB
Storage: 1x M.2 NVMe PCIe Gen3, 1x M.2 Combo (NVMe/SATA), 1x 2.5" SATA III bay
Networking: Killer E2500 Gigabit Ethernet, Killer Wi-Fi 5 (802.11ac), Bluetooth 5.0


🚀 Deployment and Management
This section covers deploying and managing systems with this configuration.
1. Initial Setup on a New Machine
To bootstrap a new NixOS system:

Install NixOS: Perform a minimal NixOS installation from an ISO.
Enable Flakes: Add the following to /etc/nixos/configuration.nix:nix.settings.experimental-features = [ "nix-command" "flakes" ];


Clone the Repository:# Back up the default configuration
sudo mv /etc/nixos /etc/nixos.backup
# Clone your configuration
sudo git clone https://github.com/emeraldocean123/nixos-config.git /etc/nixos
cd /etc/nixos


Deploy the System: Apply the configuration for the target host:# For HP Pavilion
sudo nixos-rebuild switch --flake .#hp-dv9500-pavilion-nixos

# For MSI Raider
sudo nixos-rebuild switch --flake .#msi-ge75-raider-nixos



2. Daily Management Commands
Run these commands from /etc/nixos to manage your system:

Apply Changes: sudo nixos-rebuild switch --flake .#$(hostname)
Test Changes: sudo nixos-rebuild test --flake .#$(hostname)
Update Dependencies: sudo nix flake update followed by a rebuild
Clean Up Old Generations: sudo nix-collect-garbage --delete-older-than 7d

3. Remote Management (SSH)
SSH is enabled on both hosts. Connect using:
ssh <user>@<hostname-or-ip>


🔧 Troubleshooting

Build Fails: Check for syntax errors with:sudo nixos-rebuild dry-build --flake .#$(hostname)


Rollback: Revert to a previous generation if a build fails:sudo nixos-rebuild switch --rollback




📝 Notes

Regularly update flake.lock to keep dependencies current.
For advanced Home Manager configurations, refer to the home/ directory for each host.

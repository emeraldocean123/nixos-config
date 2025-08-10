🖥️ NixOS Configuration Repository
A comprehensive NixOS and Home Manager configuration using Nix flakes
This repository provides a modular, maintainable NixOS configuration for multiple hosts, integrating dotfiles management, user-specific configurations, and host-optimized settings. It supports two hosts: an HP Pavilion dv9500 (legacy laptop) and an MSI GE75 Raider 9SF (gaming laptop).

🏗️ Repository Structure
The repository is organized around a main flake and three core directories for system and user configurations:

.gitignore – Files and directories to ignore in version control
README.md – This file
flake.lock – Locked dependencies for reproducible builds
flake.nix – Main flake configuration
home/ – Home Manager user configurations
hp-dv9500-pavilion-nixos/
follett.nix – User configuration for follett
joseph.nix – User configuration for joseph


msi-ge75-raider-nixos/
follett.nix – User configuration for follett
joseph.nix – User configuration for joseph




hosts/ – Host-specific NixOS configurations
hp-dv9500-pavilion-nixos/
configuration.nix – Main host configuration
hardware-configuration.nix – Hardware-specific settings


msi-ge75-raider-nixos/
configuration.nix – Main host configuration
hardware-configuration.nix – Hardware-specific settings (placeholder, requires generation)




modules/ – Reusable NixOS modules
hp-dv9500-pavilion-nixos/
desktop.nix – LXQt desktop configuration
hardware.nix – Hardware-specific settings
networking.nix – Networking configuration
packages.nix – System-wide packages
services.nix – System services


msi-ge75-raider-nixos/
desktop.nix – KDE Plasma 6 desktop configuration
hardware.nix – Hardware-specific settings
networking.nix – Networking configuration
nvidia.nix – NVIDIA RTX 2070 configuration
packages.nix – System-wide packages
services.nix – System services
 (user accounts are defined in modules/common.nix and host-specific users.nix only where present)


shared/
dotfiles.nix – Shared Git, Bash, and editor configurations






🏠 Supported Systems



Host
Hardware
Description
Users
Status



hp-dv9500-pavilion-nixos
HP Pavilion dv9500 (2007)AMD Turion 64 X2, NVIDIA GeForce 7150M
Legacy laptop with LXQt desktop
joseph, follett
✅ Active


msi-ge75-raider-nixos
MSI GE75 Raider 9SF (2018)Intel i7-9750H, NVIDIA RTX 2070
Gaming laptop with KDE Plasma
joseph, follett
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
# Clone the configuration
sudo git clone https://github.com/emeraldocean123/nixos-config.git /etc/nixos
cd /etc/nixos


Deploy the System: Apply the configuration for the target host:# For HP Pavilion
sudo nixos-rebuild switch --flake .#hp-dv9500-pavilion-nixos

# For MSI Raider
sudo nixos-rebuild switch --flake .#msi-ge75-raider-nixos

Note: For the MSI host, ensure hosts/msi-ge75-raider-nixos/hardware-configuration.nix is generated using nixos-generate-config before deployment.

## ⚡ Quick start: Install on MSI GE75 Raider and migrate configs

Follow these steps after a minimal NixOS install and first boot on the MSI:

1) Enable flakes on the temporary base system

```bash
sudo sed -i 's/^\s*#\?\s*nix\.settings\.experimental-features.*/nix.settings.experimental-features = [ "nix-command" "flakes" ];/' /etc/nixos/configuration.nix
sudo nixos-rebuild switch
```

2) Generate hardware config and place it under this repo for MSI

```bash
sudo nixos-generate-config
# Back up and replace /etc/nixos with this repo
sudo mv /etc/nixos /etc/nixos.backup.$(date +%Y%m%d-%H%M%S)
sudo git clone https://github.com/emeraldocean123/nixos-config.git /etc/nixos
cd /etc/nixos

# Copy the generated hardware config into the MSI host path in the repo
sudo cp /etc/nixos.backup*/hardware-configuration.nix hosts/msi-ge75-raider-nixos/hardware-configuration.nix
```

3) Deploy the MSI configuration (includes NVIDIA + Plasma + greeter-only lid policy)

```bash
sudo nixos-rebuild switch --flake .#msi-ge75-raider-nixos
```

4) Home Manager users joseph/follett are created and configured by the flake modules. Log out/in after the first switch for all user services to settle.

Notes
- Dotfiles: On NixOS, your prompt/theme/fastfetch are managed by Home Manager. You do not need to run the dotfiles bootstrap scripts here. If you want to edit the Oh My Posh theme locally and test it live, you can clone your dotfiles to ~/Documents/dotfiles and temporarily override the flake input during a build:

	```bash
	# from /etc/nixos with your local dotfiles repo at ../dotfiles
	sudo nixos-rebuild switch --flake .#msi-ge75-raider-nixos --override-input dotfiles path:../dotfiles
	```

- Networking/SSH are enabled and hardened by default. If you’re on Wi‑Fi during the first boot, use the Plasma network applet to join; the system also guards against rfkill blocks and waits for network correctly.

- If the machine won’t suspend at the greeter but obeys GUI settings after login, that’s expected: the greeter-only lid inhibitor is active only before login. You can toggle it with `custom.lid.greeterInhibit.enable = false;` if desired.

2. Daily Management Commands
Run these commands from /etc/nixos to manage your system:

Apply Changes: sudo nixos-rebuild switch --flake .#$(hostname)
Test Changes: sudo nixos-rebuild test --flake .#$(hostname)
Update Dependencies: sudo nix flake update followed by a rebuild
Clean Up Old Generations: sudo nix-collect-garbage --delete-older-than 7d

VS Code tasks
- From Command Palette → Tasks: Run Task:
	- NixOS: Switch (pick host)
	- NixOS: Test (pick host)
	- NixOS: Dry-build (pick host)
	- Nix: Flake Update

3. Remote Management (SSH)
SSH is enabled on both hosts. Connect using:
ssh <user>@<hostname-or-ip>


🔧 Troubleshooting

Build Fails: Check for syntax errors with:sudo nixos-rebuild dry-build --flake .#$(hostname)


Rollback: Revert to a previous generation if a build fails:sudo nixos-rebuild switch --rollback




📝 Notes

Regularly update flake.lock to keep dependencies current.
For advanced Home Manager configurations, refer to the home/ directory for each host.
Both hosts support joseph and follett users with tailored configurations.

Unified Oh My Posh theme

- The theme is a single source of truth in the dotfiles repo at `posh-themes/jandedobbeleer.omp.json`.
- This flake references it via a flake input:
	- Add input: `dotfiles.url = "path:../dotfiles";`
	- In Home Manager, link using: `inputs.dotfiles.outPath + "/posh-themes/jandedobbeleer.omp.json"`.

🧰 Formatting & linting

This flake exposes:
- formatter.${system} = nixpkgs-fmt → run `nix fmt` to format Nix files.
- A devShell with nixpkgs-fmt and statix → run `nix develop`, then `nixpkgs-fmt .` and `statix check`.

VS Code integration
- Tasks (Command Palette → Tasks: Run Task):
	- Nix: Format (nix fmt)
	- Nix: Statix Check
	- Nix: Flake Info

🛡️ Lid and power policy

- GUI-first: We do not override lid behavior globally. Desktop environments (LXQt/Plasma) control lid actions once a user session exists.
- Greeter safety: A small systemd service runs only alongside the display manager and uses systemd-inhibit to ignore the lid at the greeter. As soon as a non-greeter session appears, the inhibitor falls away and GUI settings take over.
- Implication: If troubleshooting GUI power settings, there are no global logind HandleLidSwitch overrides to interfere.
 - Toggle: You can disable the greeter inhibitor with `custom.lid.greeterInhibit.enable = false;` if your display manager gains native handling.
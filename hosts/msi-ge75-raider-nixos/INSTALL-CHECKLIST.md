# MSI GE75 Raider – NixOS install & migration checklist

Use this as a step-by-step guide when you’re ready to set up the MSI laptop.

## 0) Prep
- [ ] BIOS: Ensure UEFI is enabled; consider disabling Secure Boot (systemd-boot + proprietary NVIDIA).
- [ ] Internet: Verify Ethernet or Wi‑Fi access during install.
- [ ] Backup: Confirm any data on the target disk is backed up.

## 1) Install NixOS (minimal ISO)
- [ ] Boot installer; partition disk (e.g., EFI 512MB FAT32 + root ext4 + optional swap).
- [ ] Mount filesystems under /mnt.
- [ ] Run `nixos-generate-config --root /mnt`.
- [ ] Edit `/mnt/etc/nixos/configuration.nix` for hostname (optional; will be overwritten later).
- [ ] `nixos-install` and reboot.

## 2) First boot – enable flakes on base system
- [ ] Log in as root on the installed system.
- [ ] Enable flakes in `/etc/nixos/configuration.nix`:
  - `nix.settings.experimental-features = [ "nix-command" "flakes" ];`
- [ ] `nixos-rebuild switch` to apply flake support.

## 3) Bring in your repo and hardware config
- [ ] Keep a backup of the current `/etc/nixos`:
  - `sudo mv /etc/nixos /etc/nixos.backup.$(date +%Y%m%d-%H%M%S)`
- [ ] Clone your config:
  - `sudo git clone https://github.com/emeraldocean123/nixos-config.git /etc/nixos`
  - `cd /etc/nixos`
- [ ] Copy the generated hardware config into the repo’s MSI path:
  - `sudo cp /etc/nixos.backup*/hardware-configuration.nix hosts/msi-ge75-raider-nixos/hardware-configuration.nix`

## 4) Ensure system users exist (critical)
The MSI host needs system users for Home Manager to target.
- [ ] Confirm `users` for joseph and follett are defined for MSI (similar to HP’s `modules/hp-*/users.nix`).
  - If missing, create `modules/msi-ge75-raider-nixos/users.nix` with users `joseph` (wheel, networkmanager) and `follett` (wheel, networkmanager) and import it in the MSI modules list in `flake.nix`.

## 5) Deploy MSI host configuration
- [ ] Switch to the MSI host:
  - `sudo nixos-rebuild switch --flake .#msi-ge75-raider-nixos`
- [ ] Reboot if prompted.

## 6) Post-deploy checks
- [ ] Login to Plasma; verify network via Plasma applet (NM is enforced).
- [ ] SSH: `systemctl status sshd` shows running; `ssh <user>@<msi-ip>` works from another machine.
- [ ] NVIDIA: `nvidia-smi` shows the driver and GPU; if black screen, see Recovery below.
- [ ] Lid behavior: At greeter, closing the lid should not suspend; after login, GUI controls lid.
- [ ] Home Manager: Prompt/theme/fastfetch present for joseph/follett; no double fastfetch.

## 7) Daily workflow
- [ ] Use `nixos-up` to pull/pin and switch (passwordless via sudoers).
- [ ] Optional: Override theme input for local testing:
  - `sudo nixos-rebuild switch --flake .#msi-ge75-raider-nixos --override-input dotfiles path:../dotfiles`

## Recovery tips
- [ ] Temporary fallback if NVIDIA issues: comment out `modules/msi-ge75-raider-nixos/nvidia.nix` in `flake.nix` for MSI and rebuild; or switch to a TTY (Ctrl+Alt+F2) and run `sudo nixos-rebuild test` with the change.
- [ ] Rollback: `sudo nixos-rebuild switch --rollback`.

## Done
- [ ] Optional: Enable auto-login only if desired (currently enabled to joseph in host config). Adjust under `hosts/msi-ge75-raider-nixos/configuration.nix`.
- [ ] Optional: Re-enable Secure Boot only if you’ve set up signing for the NVIDIA driver and bootloader.

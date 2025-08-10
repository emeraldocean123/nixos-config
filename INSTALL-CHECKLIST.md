# MSI GE75 Raider – Install Checklist

This checklist helps you deploy the MSI host safely and replace placeholder hardware values.

1) Prep media
- Create a NixOS 25.05 USB installer.
- Boot the MSI (UEFI), disable Secure Boot if necessary.

2) Partition and install (recommend GPT + systemd-boot)
- Use `lsblk` to identify disk (e.g., /dev/nvme0n1).
- Partition: EFI (512M, vfat), root (ext4 or btrfs), optional swap.
- Mount at /mnt (EFI at /mnt/boot for systemd-boot).

3) Generate hardware config
- Run:
  - nixos-generate-config --root /mnt
- Copy /mnt/etc/nixos/hardware-configuration.nix → hosts/msi-ge75-raider-nixos/hardware-configuration.nix
- Replace the placeholder UUIDs in that file.

4) First switch
- From repo root on the machine:
  - sudo nixos-rebuild switch --flake .#msi-ge75-raider-nixos
- Verify networking, SSH, display manager (SDDM), and Plasma session.

5) NVIDIA
- Confirm proprietary driver loads (nvidia-smi works).
- If issues: ensure kernel matches driver; consider switching to latest production driver.

6) Optional gaming
- Uncomment in modules/msi-ge75-raider-nixos/packages.nix:
  - programs.steam.enable = true;
  - hardware.steam-hardware.enable = true;

7) Post-install sanity
- Run `nix flake check` in this repo.
- Test lid behavior: greeter ignores lid; once logged in, GUI controls it.
- Confirm `nixos-up` and `nixos-up-clean` helpers execute with your sudo rules.

Notes
- You can override the dotfiles input during local tests:
  - nix build --override-input dotfiles path:../dotfiles
- To avoid CI costs, use manual workflows only (flake-check.yml).

# Generic NixOS Install Checklist

This checklist provides a quick reference for deploying NixOS hosts. For host-specific details, see the individual host directories (e.g., `hosts/msi-ge75-raider-nixos/INSTALL-CHECKLIST.md`).

1) Prep media
- Create a NixOS 25.05 USB installer.
- Boot the target system (UEFI), disable Secure Boot if necessary.

2) Partition and install (recommend GPT + systemd-boot)
- Use `lsblk` to identify disk (e.g., /dev/nvme0n1).
- Partition: EFI (512M, vfat), root (ext4 or btrfs), optional swap.
- Mount at /mnt (EFI at /mnt/boot for systemd-boot).

3) Generate hardware config
- Run:
  - nixos-generate-config --root /mnt
- Copy /mnt/etc/nixos/hardware-configuration.nix → hosts/[hostname]/hardware-configuration.nix
- Replace any placeholder UUIDs in that file.

4) First switch
- From repo root on the machine:
  - sudo nixos-rebuild switch --flake .#[hostname]
- Verify networking, SSH, display manager, and desktop session.

5) Hardware-specific checks
- For NVIDIA systems: Confirm driver loads (nvidia-smi works)
- For laptops: Test lid behavior, battery management
- For gaming systems: Enable Steam in packages.nix if desired

7) Post-install sanity
- Run `nix flake check` in this repo.
- Test lid behavior: greeter ignores lid; once logged in, GUI controls it.
- Confirm `nixos-up` and `nixos-up-clean` helpers execute with your sudo rules.

Notes
- You can override the dotfiles input during local tests:
  - nix build --override-input dotfiles path:../dotfiles
- To avoid CI costs, no GitHub Actions are used in this repo; run local checks with `nix fmt`, `nix run nixpkgs#statix -- check`, and `nix flake check`.

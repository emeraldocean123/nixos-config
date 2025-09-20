# First Run on WSL (Debian) - Nix Bootstrap

1) Enable systemd (one-time) inside Debian:

   sudo /mnt/c/Users/josep/Documents/dev/nixos-config/tools/wsl/bootstrap-nix-debian.sh --write-wslconf

   Then from Windows PowerShell:

   wsl --shutdown

2) User-level bootstrap inside Debian:

   /mnt/c/Users/josep/Documents/dev/nixos-config/tools/wsl/bootstrap-nix-debian.sh

This installs Nix (daemon mode), enables flakes, reuses your unified SSH key from Windows (if present), clones nixos-config into ~/projects/nixos-config, and runs `nix flake check -L`.

Tips:
- Keep clones in Linux FS (~/projects), not /mnt/c
- Launch helper: Windows script `Documents\dev\nixos-config\tools\wsl\open-debian-nixos-config.ps1` opens Debian in the repo dir

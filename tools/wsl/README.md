# Debian WSL + Nix Bootstrap

Quick start:

1) Inside Debian (WSL2), enable systemd (one-time):

   sudo ./bootstrap-nix-debian.sh --write-wslconf
   # Then, in Windows PowerShell: wsl --shutdown
   # Reopen your Debian terminal

2) User-level setup (Nix + flakes + SSH + repo):

   ./bootstrap-nix-debian.sh

Flags:
- `--repo=git@github.com:emeraldocean123/nixos-config.git` to override repo
- `--dir=~/projects/nixos-config` to change checkout directory
- `--win-user=josep` if your Windows username differs

Notes:
- Keep repos on Linux FS (e.g., `~/projects`), not `/mnt/c`.
- The script references your Windows unified SSH key if present at `/mnt/c/Users/<you>/.ssh/id_ed25519_unified`.


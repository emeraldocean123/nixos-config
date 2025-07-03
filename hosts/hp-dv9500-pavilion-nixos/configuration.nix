{ config, pkgs, ... }:

{
  # NixOS system state version (do not change after install)
  system.stateVersion = "25.05";

  # Bootloader configuration
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Enable AMD CPU microcode updates (for AMD Turion 64 X2)
  hardware.cpu.amd.updateMicrocode = true;

  # Enable Nix flakes and nix-command (the modern Nix CLI and flake support)
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}

# /hosts/msi-ge75-raider-nixos/configuration.nix
# Host-specific configuration for MSI GE75 Raider 9SF (2018, Intel Core i7-9750H, RTX 2070)
{ config, pkgs, ... }:

{
  # NixOS system state version (do not change after install)
  system.stateVersion = "25.05";

  # Host-specific configuration is handled by flake.nix module imports.
  # Service configurations like OpenSSH are managed in the corresponding modules.

  # Enable dconf system-wide for KDE Plasma and GTK apps
  services.dbus.packages = [ pkgs.dconf ];

  # Enable nix-ld for dynamic linker compatibility (required for VS Code Remote SSH server on NixOS)
  programs.nix-ld.enable = true;

  # Optional: Open port 22 for SSH in the firewall (NixOS default is open, but explicit here)
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Gaming-specific system settings
  programs.gamemode.enable = true;

  # Enable Steam and gaming support
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # MSI-specific boot optimizations
  boot.kernelParams = [
    "quiet"
    "splash"
    "nvidia-drm.modeset=1"
  ];

  # Gaming performance optimizations
  powerManagement.cpuFreqGovernor = "performance";
}
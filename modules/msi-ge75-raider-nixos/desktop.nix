# modules/msi-ge75-raider-nixos/desktop.nix
# KDE Plasma 6 desktop environment configuration for MSI GE75 Raider
{ config, pkgs, ... }:
{
  # KDE Plasma 6 desktop environment
  services.desktopManager.plasma6.enable = true;

  # Note: Screen power management for KDE Plasma should be configured
  # through Plasma's System Settings > Power Management > Energy Saving
  # SDDM + Plasma doesn't work well with NixOS-level screen blanking settings

  # Essential KDE packages
  environment.systemPackages = with pkgs; [
    # KDE applications (keep minimal for now)
    # Additional packages can be added as needed
  ];
}

# /etc/nixos/modules/msi-ge75-raider-nixos/desktop.nix
# KDE Plasma desktop and SDDM configuration for MSI GE75 Raider

{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable Wayland session support (optional)
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "plasma";
}

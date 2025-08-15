# modules/msi-ge75-raider-nixos/display.nix
# SDDM display manager configuration for MSI GE75 Raider
{ config, pkgs, ... }:
{
  # Enable X11 windowing system
  services.xserver.enable = true;
  
  # SDDM display manager configuration
  services.displayManager.sddm.enable = true;
  
  # X11 keyboard configuration
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
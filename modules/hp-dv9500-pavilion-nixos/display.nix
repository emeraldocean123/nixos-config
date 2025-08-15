# modules/hp-dv9500-pavilion-nixos/display.nix
# SDDM display manager configuration for HP dv9500 Pavilion
{ config, pkgs, ... }:
{
  # Enable X11 windowing system
  services.xserver.enable = true;
  
  # X11 keyboard configuration
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # SDDM display manager configuration
  services.displayManager.sddm.enable = true;

  # Configure autolock to use the screen-blanking workaround
  # This works well with LXQt (unlike KDE Plasma which has conflicts)
  services.xserver.xautolock = {
    enable = true;
    # This command forces the monitor into power-saving mode (DPMS off).
    locker = "${pkgs.xorg.xset}/bin/xset dpms force off";
    time = 10;
  };
}
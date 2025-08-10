# System-wide packages for HP dv9500 Pavilion
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Utilities
    htop
    fastfetch

    # Browsers
    brave
    librewolf

    # Theming and icons
    nixos-icons
    papirus-icon-theme
    arc-theme
    qgnomeplatform

    # Terminal and X helpers
    kitty
    xorg.xhost

    # Sensors CLI
    lm_sensors
  ];
}

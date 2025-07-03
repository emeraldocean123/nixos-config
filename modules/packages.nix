{ config, pkgs, ... }:

{
  # System-wide packages
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
  ];
}

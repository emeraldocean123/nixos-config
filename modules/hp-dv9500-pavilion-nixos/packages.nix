# /modules/hp-dv9500-pavilion-nixos/packages.nix
# System-wide packages for HP dv9500 Pavilion (2007, AMD Turion 64 X2, NVIDIA GeForce 7150M)
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
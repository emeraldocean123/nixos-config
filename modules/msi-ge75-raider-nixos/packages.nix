# modules/msi-ge75-raider-nixos/packages.nix
# System packages for MSI GE75 Raider (aligned with HP where possible)
{ pkgs, ... }:
{
  # Align with HP's package set (minus LXQt-specific packages not used on KDE)
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
  ];
}

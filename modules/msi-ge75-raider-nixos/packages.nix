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

  # Theming and icons (Plasma-friendly)
  nixos-icons
  papirus-icon-theme
  breeze-icons
  breeze-gtk
  xdg-desktop-portal-kde

  # Terminal and helpers
    kitty

  # KDE QoL tools
  kdePackages.kdeconnect-kde
  kdePackages.spectacle
  kdePackages.dolphin
  kdePackages.gwenview

  # GPU diagnostics
  mesa-demos  # glxinfo/glxgears
  nvtopPackages.full
  ];
}

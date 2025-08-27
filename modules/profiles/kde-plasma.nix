# modules/profiles/kde-plasma.nix
# KDE Plasma 6 desktop environment profile
{pkgs, ...}: {
  # KDE Plasma 6 desktop environment
  services.desktopManager.plasma6.enable = true;

  # KDE-specific packages and theming
  environment.systemPackages = with pkgs; [
    # KDE/Plasma theming and integration
    kdePackages.breeze-icons
    kdePackages.breeze-gtk
    kdePackages.xdg-desktop-portal-kde

    # KDE applications and tools
    kdePackages.kdeconnect-kde
    kdePackages.spectacle
    kdePackages.dolphin
    kdePackages.gwenview
  ];

  # Note: Screen power management for KDE Plasma should be configured
  # through Plasma's System Settings > Power Management > Energy Saving
  # SDDM + Plasma doesn't work well with NixOS-level screen blanking settings
}

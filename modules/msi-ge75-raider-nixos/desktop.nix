# modules/msi-ge75-raider-nixos/desktop.nix
# KDE Plasma 6 desktop with SDDM for MSI GE75 Raider
{ config, pkgs, ... }:
{
  # Enable X and Plasma 6 with SDDM (default Wayland session is fine; X11 also works)
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Note: Screen power management for KDE Plasma should be configured
  # through Plasma's System Settings > Power Management > Energy Saving
  # SDDM + Plasma doesn't work well with NixOS-level screen blanking settings

  # Start lean: no extra KDE apps yet
  environment.systemPackages = with pkgs; [
    # add editors/tools later after install
  ];
}

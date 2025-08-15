# MSI GE75 Raider display-specific configuration (base display is in shared/desktop-base.nix)
{ config, pkgs, ... }:
{
  # MSI-specific display configuration
  # Note: Screen power management for KDE Plasma should be configured
  # through Plasma's System Settings > Power Management > Energy Saving
  # SDDM + Plasma doesn't work well with NixOS-level screen blanking settings
}
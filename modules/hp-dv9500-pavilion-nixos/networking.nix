# modules/hp-dv9500-pavilion-nixos/networking.nix
# Hostname and per-host networking tweaks for HP dv9500 Pavilion
{ config, pkgs, ... }:
{
  # Hostname
  networking.hostName = "hp-dv9500-pavilion-nixos";

  # NetworkManager is enabled in common.nix
  # Show the tray applet on LXQt to manage Wi‑Fi connections interactively
  programs.nm-applet.enable = true;
  # Add per-host firewall or interface tweaks here if needed.
}

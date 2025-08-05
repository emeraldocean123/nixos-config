# /modules/hp-dv9500-pavilion-nixos/networking.nix
# Networking configuration for HP dv9500 Pavilion (2007, AMD Turion 64 X2, NVIDIA GeForce 7150M)
{ config, pkgs, ... }:

{
  # Set system hostname
  networking.hostName = "hp-dv9500-pavilion-nixos";

  # NetworkManager is enabled globally in modules/common.nix

  # Enable the NetworkManager applet in the system tray (for LXQt or other desktops)
  programs.nm-applet.enable = true;
}
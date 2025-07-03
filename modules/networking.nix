{ config, pkgs, ... }:

{
  # Set system hostname and enable NetworkManager
  networking.hostName = "hp-dv9500-pavilion-nixos";
  networking.networkmanager.enable = true;

  # Enable the Network Manager applet in the system tray
  programs.nm-applet.enable = true;
}

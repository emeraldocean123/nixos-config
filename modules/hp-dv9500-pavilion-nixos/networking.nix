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

  # Ensure firewall allows SSH (in addition to global openFirewall)
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Bind sshd to both LAN and Wi‑Fi addresses so either interface works.
  services.openssh.settings.ListenAddress = [
    "192.168.1.103" # LAN
    "192.168.1.104" # Wi‑Fi
  ];
}

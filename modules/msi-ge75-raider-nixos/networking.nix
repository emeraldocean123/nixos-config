# /modules/msi-ge75-raider-nixos/networking.nix
# Networking configuration for MSI GE75 Raider 9SF (2018, Intel Core i7-9750H, RTX 2070)
{ config, pkgs, ... }:

{
  # Set system hostname
  networking.hostName = "msi-ge75-raider-nixos";

  # NetworkManager is enabled globally in modules/common.nix

  # Enable the NetworkManager applet in the system tray
  programs.nm-applet.enable = true;

  # Gaming-specific networking optimizations (kernel sysctl settings)
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_rmem" = "4096 87380 16777216";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";
    "net.core.netdev_max_backlog" = 5000;
    "net.ipv4.tcp_congestion_control" = "bbr";  # Enable BBR for better network performance
  };

  # Firewall configuration for gaming
  networking.firewall = {
    enable = true;
    # Common gaming ports (Steam, Discord, etc.)
    allowedTCPPorts = [
      22    # SSH
      27015 # Steam
      27036 # Steam
      3478  # Discord voice
    ];
    allowedUDPPorts = [
      27015 # Steam
      27031 # Steam
      27036 # Steam
      50000 # Discord voice range start
    ];
    allowedUDPPortRanges = [
      { from = 50000; to = 65535; } # Discord voice range
    ];
  };
}
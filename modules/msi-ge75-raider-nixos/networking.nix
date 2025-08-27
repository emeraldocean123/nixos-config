# modules/msi-ge75-raider-nixos/networking.nix
# MSI GE75 Raider networking (2018, i7-9750H, RTX 2070)
{
  config,
  pkgs,
  ...
}: {
  # Set system hostname
  networking.hostName = "msi-ge75-raider-nixos";

  # NetworkManager is enabled globally (see host configuration)

  # KDE Plasma provides its own network applet; disable nm-applet
  programs.nm-applet.enable = false;

  # Gaming-specific networking optimizations are handled by gaming-hardware.nix
  # Host-specific TCP buffer sizes for MSI laptop
  boot.kernel.sysctl = {
    "net.ipv4.tcp_rmem" = "4096 87380 16777216";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";
  };

  # Firewall configuration for gaming
  networking.firewall = {
    enable = true;
    # Common gaming ports (Steam, Discord, etc.)
    allowedTCPPorts = [
      22 # SSH
      27015 # Steam
      27036 # Steam
      3478 # Discord voice
    ];
    allowedUDPPorts = [
      27015 # Steam
      27031 # Steam
      27036 # Steam
      50000 # Discord voice range start
    ];
    allowedUDPPortRanges = [
      {
        from = 50000;
        to = 65535;
      } # Discord voice range
    ];
  };
}

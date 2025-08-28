# modules/hp-dv9500-pavilion-nixos/networking.nix
# Hostname and per-host networking tweaks for HP dv9500 Pavilion
_: {
  # Hostname and firewall (consolidated networking.*)
  networking = {
    hostName = "hp-dv9500-pavilion-nixos";
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
    };
  };

  # NetworkManager is enabled in common.nix
  # Show the tray applet on LXQt to manage Wi‑Fi connections interactively
  programs.nm-applet.enable = true;
  # Add per-host firewall or interface tweaks here if needed.

  # Firewall consolidated above

  # Rely on global AddressFamily=inet (common.nix) so sshd listens on all IPv4
  # interfaces. This covers both LAN (e.g., 192.168.1.103) and Wi‑Fi (e.g., 192.168.1.104)
  # without risking failures if one interface is down. No explicit ListenAddress here.
}

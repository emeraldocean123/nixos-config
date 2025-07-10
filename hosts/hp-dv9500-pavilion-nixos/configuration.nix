# /hosts/hp-dv9500-pavilion-nixos/configuration.nix
# Host-specific configuration for HP dv9500 Pavilion (2007, AMD Turion 64 X2, NVIDIA GeForce 7150M)
{ config, pkgs, ... }:

{
  # NixOS system state version (do not change after install)
  system.stateVersion = "25.05";

  # Host-specific configuration is handled by flake.nix module imports.
  # Service configurations like OpenSSH are managed in the corresponding modules.

  # Enable dconf system-wide for xscreensaver and GTK/GNOME apps
  services.dbus.packages = [ pkgs.dconf ];

  # Ensure PAM configuration exists for xscreensaver password authentication
  security.pam.services.xscreensaver = {};

  # Enable nix-ld for dynamic linker compatibility (required for VS Code Remote SSH server on NixOS)
  programs.nix-ld.enable = true;

  # Optional: Open port 22 for SSH in the firewall (NixOS default is open, but explicit here)
  networking.firewall.allowedTCPPorts = [ 22 ];
}
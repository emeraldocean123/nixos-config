# /hosts/hp-dv9500-pavilion-nixos/configuration.nix
# Host-specific configuration for HP dv9500 Pavilion (2007, AMD Turion 64 X2, NVIDIA GeForce 7150M)
{ config, pkgs, ... }:
{
  # NixOS system state version (do not change after install)
  system.stateVersion = "25.05";
  # Host-specific configuration is handled by flake.nix module imports
  # No additional imports needed here to avoid conflicts
  # Enable dconf system-wide for GTK/GNOME apps
  services.dbus.packages = [ pkgs.dconf ];

  # All manual PAM blocks for display managers and screensavers are removed.
  # NixOS will use its defaults, which are now known to work.

  # --- Remote SSH and VS Code Support ---
  # Enable the OpenSSH server for remote access (required for VS Code Remote SSH)
  services.openssh.enable = true;
  # Enable nix-ld for dynamic linker compatibility (required for VS Code Remote SSH server on NixOS)
  programs.nix-ld.enable = true;
  # Optional: Harden SSH security (recommended for remote access)
  services.openssh.settings = {
    PermitRootLogin = "no"; # Don't allow root login via SSH
    PasswordAuthentication = true; # Allow password login (set to false if using SSH keys only)
    # AllowUsers = [ "joseph" ]; # Uncomment to restrict SSH to specific users
  };
  # Optional: Open port 22 for SSH in the firewall (NixOS default is open, but explicit here)
  networking.firewall.allowedTCPPorts = [ 22 ];
}

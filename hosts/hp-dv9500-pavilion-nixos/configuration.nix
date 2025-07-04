# /etc/nixos/hosts/hp-dv9500-pavilion-nixos/configuration.nix
# Host-specific configuration for HP dv9500 Pavilion (AMD Turion 64 X2)

{ config, pkgs, ... }:

{
  # NixOS system state version (do not change after install)
  system.stateVersion = "25.05";

  # Bootloader configuration
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Enable AMD CPU microcode updates (for AMD Turion 64 X2)
  hardware.cpu.amd.updateMicrocode = true;

  # Enable the X server (required for graphical desktop and LightDM)
  services.xserver.enable = true;

  # Use the open-source nouveau driver for NVIDIA GeForce 7150M GPU
  services.xserver.videoDrivers = [ "nouveau" ];

  # Enable OpenGL/graphics support (modern NixOS: driSupport options are obsolete)
  hardware.graphics.enable = true;

  # Enable dconf system-wide for xscreensaver and GTK/GNOME apps
  services.dbus.packages = [ pkgs.dconf ];

  # Ensure PAM configuration exists for xscreensaver password authentication
  security.pam.services.xscreensaver = {};

  # --- Remote SSH and VS Code Support ---

  # Enable the OpenSSH server for remote access (required for VS Code Remote SSH)
  services.openssh.enable = true;

  # Enable nix-ld for dynamic linker compatibility (required for VS Code Remote SSH server on NixOS)
  programs.nix-ld.enable = true;

  # Optional: Harden SSH security (recommended for remote access)
  services.openssh.settings = {
    PermitRootLogin = "no";         # Don't allow root login via SSH
    PasswordAuthentication = true;  # Allow password login (set to false if using SSH keys only)
    # AllowUsers = [ "joseph" ];    # Uncomment to restrict SSH to specific users
  };

  # Optional: Open port 22 for SSH in the firewall (NixOS default is open, but explicit here)
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Import the desktop module for LXQt, LightDM, xscreensaver, etc.
  imports = [
    ../../modules/hp-dv9500-pavilion-nixos/desktop.nix
  ];
}

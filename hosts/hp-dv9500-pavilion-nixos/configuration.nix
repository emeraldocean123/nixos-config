# hosts/hp-dv9500-pavilion-nixos/configuration.nix
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

  # Enable OpenGL support (modern NixOS: driSupport options are obsolete)
  hardware.graphics.enable = true;

  # Enable dconf system-wide for xscreensaver and GTK/GNOME apps
  services.dbus.packages = [ pkgs.dconf ];

  # Ensure PAM configuration exists for xscreensaver password authentication
  security.pam.services.xscreensaver = {};

  # Import the desktop module for LXQt, LightDM, xscreensaver, etc.
  imports = [
    ../../modules/hp-dv9500-pavilion-nixos/desktop.nix
  ];
}

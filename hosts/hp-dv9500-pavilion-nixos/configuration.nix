## hosts/hp-dv9500-pavilion-nixos/configuration.nix
# Main host configuration for HP dv9500 Pavilion
{ config, pkgs, ... }:
{
  imports = [
    # Common settings are applied via the modules imported below
    ../../modules/common.nix
    ../../modules/hp-dv9500-pavilion-nixos/hardware.nix
    ../../modules/hp-dv9500-pavilion-nixos/display.nix
    ../../modules/hp-dv9500-pavilion-nixos/desktop.nix
    ../../modules/hp-dv9500-pavilion-nixos/networking.nix
    ../../modules/hp-dv9500-pavilion-nixos/packages.nix
    ../../modules/hp-dv9500-pavilion-nixos/services.nix
    ../../modules/hp-dv9500-pavilion-nixos/users.nix
    ./hardware-configuration.nix
    ./bootloader.nix
  ];
  networking.hostName = "hp-dv9500-pavilion-nixos";
  # Disable auto-login to show SDDM login screen
  # Display manager (SDDM) configured in modules/hp-dv9500-pavilion-nixos/display.nix
  # Desktop environment (LXQt) configured in modules/hp-dv9500-pavilion-nixos/desktop.nix
  services.displayManager.autoLogin.enable = false;
  # services.displayManager.autoLogin.user = "joseph";

  # Guard: ensure the host hardware config file exists and is non-empty
  assertions = [
    {
      assertion = (builtins.pathExists ./hardware-configuration.nix) && ((builtins.stringLength (builtins.readFile ./hardware-configuration.nix)) > 0);
      message = "hosts/hp-dv9500-pavilion-nixos/hardware-configuration.nix is missing or empty.";
    }
  ];
  system.stateVersion = "25.05";
}

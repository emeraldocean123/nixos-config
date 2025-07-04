# /etc/nixos/modules/hp-dv9500-pavilion-nixos/services.nix
# Service and hardware configuration for HP dv9500 Pavilion

{ config, pkgs, ... }:

{
  # Enable printing (CUPS) and SSH server
  services.printing.enable = true;
  services.openssh.enable = true;

  # Power management for laptops
  powerManagement.enable = true;

  # Prevent suspend on lid close (useful for older laptops and when docked)
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };
}

## hosts/hp-dv9500-pavilion-nixos/configuration.nix
# Main host configuration for HP dv9500 Pavilion
{ config, pkgs, ... }:
{
  imports = [
    # Common settings are applied via shared/profile/role modules in flake.nix
    ../../modules/common.nix
    ./hardware-configuration.nix
    ./bootloader.nix
  ];
  networking.hostName = "hp-dv9500-pavilion-nixos";
  # Disable auto-login to show SDDM login screen
  # Display manager (SDDM) configured in shared/desktop-base.nix
  # Desktop environment (LXQt) configured in profiles/lxqt.nix
  services.displayManager.autoLogin.enable = false;
  # services.displayManager.autoLogin.user = "user";

  # Guard: ensure the host hardware config file exists and warn about placeholders
  assertions = [
    {
      assertion = (builtins.pathExists ./hardware-configuration.nix) && ((builtins.stringLength (builtins.readFile ./hardware-configuration.nix)) > 100);
      message = "hosts/hp-dv9500-pavilion-nixos/hardware-configuration.nix is missing or too small.";
    }
    {
      # Check for placeholder UUIDs that need to be replaced
      assertion = (
        builtins.match ".*REPLACE-WITH-ACTUAL.*" (builtins.readFile ./hardware-configuration.nix)
      ) == null;
      message = "WARNING: Placeholder UUIDs detected in hardware-configuration.nix. Run 'sudo nixos-generate-config' on the HP machine to generate actual hardware configuration!";
    }
  ];
  system.stateVersion = "25.05";
}

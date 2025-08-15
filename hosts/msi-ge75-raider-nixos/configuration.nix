## hosts/msi-ge75-raider-nixos/configuration.nix
# Main host configuration for MSI GE75 Raider
{ config, pkgs, ... }:
{
  imports = [
    # Common settings are applied via shared/profile/role modules in flake.nix
    ../../modules/common.nix
    ./hardware-configuration.nix
  ];
  nixpkgs.config.allowUnfree = true;
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  networking.hostName = "msi-ge75-raider-nixos";
  # Timezone/locale set in modules/common.nix
  # Display manager (SDDM) configured in shared/desktop-base.nix  
  # Desktop environment (Plasma) configured in profiles/kde-plasma.nix
  # Auto-login disabled for security
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "joseph";

  # CRITICAL: Hardware validation to prevent boot failures
  # These assertions MUST pass or the system will not boot
  assertions = [
    {
      # Check for placeholder UUIDs
      assertion = (
        builtins.match ".*0000-0000-0000-000000000000.*" (builtins.readFile ./hardware-configuration.nix)
      ) == null;
      message = "FATAL: Placeholder UUIDs detected in hardware-configuration.nix. Generate proper config with nixos-generate-config!";
    }
    {
      # Ensure hardware-configuration.nix exists and is not empty
      assertion = builtins.pathExists ./hardware-configuration.nix && 
                 (builtins.stringLength (builtins.readFile ./hardware-configuration.nix)) > 100;
      message = "FATAL: hardware-configuration.nix is missing or empty. Run nixos-generate-config first!";
    }
    {
      # Check that we're not using the repository's example UUIDs
      assertion = (
        builtins.match ".*(6e49b974-32d4-443b-bb4f-c9628106f47a|08DA-79B4|7da81dcb-243d-4949-9fd4-09646fb944fc).*" (builtins.readFile ./hardware-configuration.nix)
      ) == null;
      message = "FATAL: Repository's example UUIDs detected! Run 'sudo nixos-generate-config' to create YOUR machine-specific configuration!";
    }
  ];
  system.stateVersion = "25.05";
}

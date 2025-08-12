## hosts/msi-ge75-raider-nixos/configuration.nix
# Main host configuration for MSI GE75 Raider
{ config, pkgs, ... }:
{
  imports = [
    ../../modules/common.nix
    ../../modules/msi-ge75-raider-nixos/hardware.nix
    ../../modules/msi-ge75-raider-nixos/desktop.nix
    ../../modules/msi-ge75-raider-nixos/nvidia.nix
    ../../modules/msi-ge75-raider-nixos/networking.nix
    ../../modules/msi-ge75-raider-nixos/packages.nix
    ../../modules/msi-ge75-raider-nixos/services.nix
    ../../modules/msi-ge75-raider-nixos/users.nix
    ./hardware-configuration.nix
  ];
  nixpkgs.config.allowUnfree = true;
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  networking.hostName = "msi-ge75-raider-nixos";
  # Timezone/locale set in modules/common.nix; desktop stack in modules/msi-ge75-raider-nixos/desktop.nix
    # Timezone and locale are defined in modules/common.nix
    # Desktop and display manager are configured in modules/msi-ge75-raider-nixos/desktop.nix
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "joseph";

  # Guard: prevent deploying with placeholder hardware UUIDs
  assertions = [
    {
      assertion = (
        builtins.match ".*0000-0000-0000-000000000000.*" (builtins.readFile ./hardware-configuration.nix)
      ) == null;
      message = "Replace placeholder UUIDs in hosts/msi-ge75-raider-nixos/hardware-configuration.nix before deploying.";
    }
  ];
  system.stateVersion = "25.05";
}

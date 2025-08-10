## hosts/msi-ge75-raider-nixos/configuration.nix
# Main host configuration for MSI GE75 Raider
{ config, pkgs, ... }:
{
  imports = [
    ../../modules/msi-ge75-raider-nixos/hardware.nix
    ../../modules/msi-ge75-raider-nixos/desktop.nix
    ../../modules/msi-ge75-raider-nixos/nvidia.nix
    ../../modules/msi-ge75-raider-nixos/networking.nix
    ../../modules/msi-ge75-raider-nixos/packages.nix
    ../../modules/msi-ge75-raider-nixos/services.nix
    ./hardware-configuration.nix
  ];
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
  system.stateVersion = "25.05";
}

# modules/msi-ge75-raider-nixos/nvidia.nix
# NVIDIA driver configuration for MSI GE75 Raider (RTX 2070)
{ config, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
}

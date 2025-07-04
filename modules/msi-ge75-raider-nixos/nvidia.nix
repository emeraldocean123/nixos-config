# /etc/nixos/modules/msi-ge75-raider-nixos/nvidia.nix
# Proprietary NVIDIA driver configuration for MSI GE75 Raider 9SF (2018, Intel Core i7-9750H, RTX 2070)

{ config, pkgs, ... }:

{
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # Optional NVIDIA features (uncomment if needed)
  # hardware.nvidia.modesetting.enable = true;
  # hardware.nvidia.powerManagement.enable = true;
}

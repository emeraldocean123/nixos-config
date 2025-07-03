# modules/msi-ge75-raider-nixos/nvidia.nix
# Proprietary NVIDIA driver configuration for MSI GE75 Raider

{ config, pkgs, ... }:

{
  hardware.opengl.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # Optional NVIDIA features (uncomment if needed)
  # hardware.nvidia.modesetting.enable = true;
  # hardware.nvidia.powerManagement.enable = true;
}

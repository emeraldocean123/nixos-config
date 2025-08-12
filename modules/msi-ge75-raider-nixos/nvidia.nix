## modules/msi-ge75-raider-nixos/nvidia.nix
  # NVIDIA configuration for MSI GE75 Raider
  { config, pkgs, ... }:
  {
    # Enable proprietary NVIDIA drivers
    hardware.graphics.enable = true;
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;

      # Use open source kernel modules for RTX series
      # Set to false for older GPUs (pre-Turing)
      open = true;  # MSI GE75 Raider typically has RTX 2060/2070

      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  }

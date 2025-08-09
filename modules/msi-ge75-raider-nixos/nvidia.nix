# /modules/msi-ge75-raider-nixos/nvidia.nix
# NVIDIA GPU configuration for MSI GE75 Raider 9SF (RTX 2070)
{ config, pkgs, ... }:

{
  # Enable NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Use stable driver package
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Enable DRM kernel mode setting
    modesetting.enable = true;

    # Enable power management (important for gaming laptops)
    powerManagement.enable = true;
    powerManagement.finegrained = false;

    # Enable the open source kernel module (not compatible with RTX 2070)
    open = false;

    # Enable nvidia-settings
    nvidiaSettings = true;

    # Optimus/PRIME configuration (for hybrid graphics)
    prime = {
      # For MSI GE75 Raider - check with `lspci | grep VGA`
      # Uncomment and adjust BusID values if using hybrid graphics
      # intelBusId = "PCI:0:2:0";
      # nvidiaBusId = "PCI:1:0:0";

      # Use sync mode for better gaming performance
      # sync.enable = true;

      # Alternative: offload mode for better battery life
      # offload = {
      #   enable = true;
      #   enableOffloadCmd = true;
      # };
    };
  };

  # Gaming-specific NVIDIA settings
  environment.variables = {
    # Enable NVIDIA GPU for all applications
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __VK_LAYER_NV_optimus = "NVIDIA_only";

    # Gaming optimizations
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_PATH = "/tmp/nvidia-shader-cache";
    __GL_THREADED_OPTIMIZATIONS = "1";
    __GL_SYNC_TO_VBLANK = "0";
  };

  # Create shader cache directory
  systemd.tmpfiles.rules = [
    "d /tmp/nvidia-shader-cache 0755 root root 1d"
  ];

  # Boot configuration for NVIDIA
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];
}

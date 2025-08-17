# Optimized NVIDIA configuration for MSI GE75 Raider with RTX 2070
{ config, lib, pkgs, ... }:

{
  # Enable graphics
  hardware.graphics = {
    enable = true;
    # Enable 32-bit support for gaming
    enable32Bit = true;
    
    # Extra packages for Vulkan support
    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-loader
      vulkan-validation-layers
    ];
  };
  
  # Modern NVIDIA setup
  hardware.nvidia = {
    # Enable kernel modesetting
    modesetting.enable = true;
    
    # Power management for laptops
    powerManagement = {
      enable = true;
      # Fine-grained power management (supported on RTX 2070)
      finegrained = true;
    };
    
    # Use proprietary driver for RTX 2070 (better compatibility)
    open = false; # RTX 2070 works better with proprietary
    
    # Enable nvidia-settings GUI
    nvidiaSettings = true;
    
    # Use production driver for stability
    package = config.boot.kernelPackages.nvidiaPackages.production;
    
    # Force full composition pipeline to prevent tearing
    forceFullCompositionPipeline = true;
  };
  
  # PRIME configuration for hybrid graphics
  hardware.nvidia.prime = {
    # Offload rendering for better battery life
    offload = {
      enable = true;
      enableOffloadCmd = true; # Adds nvidia-offload command
    };
    
    # Bus IDs for Intel and NVIDIA GPUs
    # Find these with: lspci | grep -E 'VGA|3D'
    # These are typical values for MSI GE75 Raider
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  
  # Kernel parameters for NVIDIA optimization
  boot.kernelParams = [ 
    "nvidia-drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
    # Enable Dynamic Boost if supported
    "nvidia.NVreg_DynamicPowerManagement=0x02"
  ];
  
  # Blacklist nouveau driver
  boot.blacklistedKernelModules = [ "nouveau" ];
  
  # Load NVIDIA modules early
  boot.initrd.kernelModules = [ 
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];
  
  # X11 configuration
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    
    # Screen tearing fixes
    screenSection = ''
      Option "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option "AllowIndirectGLXProtocol" "off"
      Option "TripleBuffer" "on"
    '';
    
    # Device section optimizations
    deviceSection = ''
      Option "TearFree" "true"
      Option "DRI" "3"
    '';
  };
  
  # Environment variables for better NVIDIA performance
  environment.sessionVariables = {
    # Use NVIDIA GPU for rendering when needed
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1"; # For Wayland compositors
    LIBVA_DRIVER_NAME = "nvidia"; # Video acceleration
    GBM_BACKEND = "nvidia-drm";
    __NV_PRIME_RENDER_OFFLOAD = "1";
    
    # Vulkan ICD
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
  };
  
  # NVIDIA container toolkit for Docker/Podman (optional)
  virtualisation.docker.enableNvidia = lib.mkDefault false;
  
  # CUDA support (optional - uncomment if needed)
  # hardware.nvidia-container-toolkit.enable = true;
  # cudaSupport = true;
  
  # Additional packages for NVIDIA management
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia # GPU monitoring
    nvidia-vaapi-driver # Video acceleration
    nvitop # Better GPU monitoring
    glxinfo
    vulkan-tools
    pciutils
  ];
}
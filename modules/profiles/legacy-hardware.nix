# modules/profiles/legacy-hardware.nix
# Profile for legacy hardware optimizations (2007-era laptops)
{ config, lib, pkgs, ... }:
{
  # Legacy hardware optimizations
  boot.kernel.sysctl = {
    # Optimize for older hardware with limited RAM (typically 2-4GB)
    "vm.swappiness" = 60; # Higher swap usage for limited RAM
    "vm.dirty_background_ratio" = 10; # More conservative for old hardware
    "vm.dirty_ratio" = 15; # Reduce dirty page ratio for stability
    "vm.min_free_kbytes" = 65536; # Reserve more memory for system stability
    "vm.vfs_cache_pressure" = 150; # Reclaim cache more aggressively
  };

  # Reduce memory footprint and improve stability
  boot.kernelParams = [
    "mitigations=auto"  # Keep basic mitigations on legacy hardware
    "processor.max_cstate=1"  # Prevent deep sleep states that can cause issues
    "intel_idle.max_cstate=1"  # Similar for Intel idle states
    "pci=nomsi"  # Disable MSI for compatibility with older hardware
  ];

  # Filesystem mount options for stability on older drives
  fileSystems."/" = {
    options = [ "relatime" "errors=remount-ro" "barrier=1" ];  # Added barrier for data integrity
  };

  # Conservative power settings for battery preservation
  hardware.bluetooth.powerOnBoot = false; # Save battery on old laptop
  
  # Disable power-hungry features on legacy hardware
  services.tlp = {
    enable = true;
    settings = {
      # Conservative CPU scaling for battery life
      CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
      CPU_SCALING_GOVERNOR_ON_BAT = "conservative";
      
      # Reduce CPU boost on battery
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      
      # Aggressive disk power management
      DISK_APM_LEVEL_ON_AC = "254";
      DISK_APM_LEVEL_ON_BAT = "128";
      
      # Conservative USB autosuspend
      USB_AUTOSUSPEND = 1;
      USB_BLACKLIST_WWAN = 1;
    };
  };

  # Traditional scrolling for older users
  services.libinput.touchpad.naturalScrolling = lib.mkDefault false;

  # Support for both AMD and legacy NVIDIA graphics
  services.xserver.videoDrivers = lib.mkDefault [ "ati" "radeon" "nouveau" "vesa" ];
  
  # Legacy hardware compatibility
  hardware = {
    # Enable older firmware
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
    
    # Legacy graphics support
    graphics = {
      enable = true;
      enable32Bit = true;  # Support for older 32-bit applications
      extraPackages = with pkgs; [
        mesa.drivers
        xorg.xf86videoati    # ATI/AMD legacy support
        xorg.xf86videofbdev  # Fallback framebuffer driver
        xorg.xf86videovesa   # VESA fallback
      ];
    };
  };
  
  # Reduce system load for better performance on old hardware
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=30s
    DefaultTimeoutStartSec=30s
  '';
  
  # Disable heavy desktop effects that can slow down legacy hardware
  environment.variables = {
    # Disable compositing by default for better performance
    QT_XCB_GL_INTEGRATION = "none";
    # Reduce Qt visual effects
    QT_QUICK_CONTROLS_STYLE = "basic";
  };
}
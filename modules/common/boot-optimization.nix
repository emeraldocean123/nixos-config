# Boot time optimization module
{ config, lib, pkgs, ... }:

{
  boot = {
    # Parallel startup and quiet boot
    kernelParams = [ 
      "quiet"
      "splash"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
      "udev.log_level=3"
    ];
    
    # Reduce initrd size - only include necessary modules
    initrd = {
      verbose = false;
      
      # Common modules for most systems
      availableKernelModules = lib.mkDefault [ 
        "xhci_pci" 
        "ahci" 
        "nvme" 
        "usb_storage" 
        "sd_mod"
        "sdhci_pci"
      ];
      
      # Compress initrd for faster loading
      compressor = "zstd";
      compressorArgs = [ "-19" ];
    };
    
    # Plymouth for better boot experience (optional)
    plymouth = {
      enable = lib.mkDefault true;
      theme = lib.mkDefault "breeze";
    };
    
    # Faster filesystem checks
    tmp.cleanOnBoot = true;
    
    # Use systemd-boot for faster boot on UEFI systems
    loader = {
      timeout = lib.mkDefault 3;
      
      systemd-boot = {
        enable = lib.mkDefault true;
        editor = false; # Security: don't allow editing boot parameters
        consoleMode = "max";
      };
      
      efi.canTouchEfiVariables = true;
    };
  };
  
  # Systemd optimizations
  systemd = {
    # Faster boot by not waiting for network
    services.NetworkManager-wait-online.enable = lib.mkDefault false;
    
    # Disable unnecessary services at boot
    services.systemd-udev-settle.enable = false;
    
    # Default timeout reduction
    extraConfig = ''
      DefaultTimeoutStopSec=10s
      DefaultTimeoutStartSec=10s
    '';
    
    # Watchdog for system stability
    watchdog = {
      device = "/dev/watchdog";
      runtimeTime = "30s";
      rebootTime = "10min";
    };
  };
  
  # Don't wait for DHCP on boot
  networking.dhcpcd.wait = "background";
}
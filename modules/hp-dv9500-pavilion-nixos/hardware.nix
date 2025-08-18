# HP dv9500 Pavilion hardware-specific configuration
# (Legacy optimizations are in profiles/legacy-hardware.nix)
# (Laptop optimizations are in profiles/laptop-base.nix)
{ config, lib, pkgs, ... }:

{
  # Enable AMD CPU microcode updates (for AMD Turion 64 X2)
  hardware.cpu.amd.updateMicrocode = true;
  
  # Force PulseAudio for LXQt compatibility (override multimedia role's PipeWire)
  services.pulseaudio.enable = lib.mkForce true;
  services.pipewire.enable = lib.mkForce false;
  
  # Nvidia GeForce 7150M graphics support (legacy GPU from 2007)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # For legacy 32-bit applications
    extraPackages = with pkgs; [
      # Nvidia legacy drivers for GeForce 7150M
      # Note: GeForce 7150M requires legacy nvidia-304xx drivers
      mesa.drivers
      # VDPAU support for video acceleration
      libvdpau-va-gl
      vaapiVdpau
    ];
  };
  
  # Nvidia GeForce 7150M specific configuration
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # Use legacy driver for GeForce 7150M (requires nvidia-304xx)
    package = config.boot.kernelPackages.nvidiaPackages.legacy_304;
    # Disable modesetting for legacy cards
    modesetting.enable = false;
    # Power management not supported on legacy cards
    powerManagement.enable = false;
  };
  
  # Legacy hardware-specific kernel modules
  boot.kernelModules = [
    "nvidia"           # Nvidia proprietary driver
    "nvidia_legacy"    # Legacy Nvidia support
    "nvidia_drm"       # DRM support
  ];
  
  # Firmware for AMD graphics cards
  hardware.enableRedistributableFirmware = true;
  
  # Power management for legacy laptop
  powerManagement = {
    enable = true;
    # More conservative CPU frequency scaling for older hardware
    cpuFreqGovernor = "conservative";
  };
  
  # Audio support (likely AC97 or HDA)
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;  # For legacy applications
  };
  
  # Legacy input device support
  services.xserver.libinput = {
    enable = true;
    # More lenient settings for older touchpads
    touchpad = {
      accelProfile = "flat";
      accelSpeed = "0.5";
      naturalScrolling = false;  # Traditional scrolling for older users
    };
  };
}

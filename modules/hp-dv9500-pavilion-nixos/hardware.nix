# HP dv9500 Pavilion hardware-specific configuration
# (Legacy optimizations are in profiles/legacy-hardware.nix)
# (Laptop optimizations are in profiles/laptop-base.nix)
{ config, lib, pkgs, ... }:

{
  # Enable AMD CPU microcode updates (for AMD Turion 64 X2)
  hardware.cpu.amd.updateMicrocode = true;
  
  # Force PulseAudio for LXQt compatibility (override multimedia role's PipeWire)
  services.pulseaudio = {
    enable = lib.mkForce true;
    support32Bit = true;  # For legacy applications
  };
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
  # Use nouveau driver since legacy_304 is not available in NixOS 25.05
  services.xserver.videoDrivers = [ "nouveau" ];
  
  # Ensure nouveau module is loaded (safer than proprietary legacy drivers)
  boot.kernelModules = [ "nouveau" ];
  
  # Firmware for AMD graphics cards
  hardware.enableRedistributableFirmware = true;
  
  # Power management for legacy laptop
  powerManagement = {
    enable = true;
    # More conservative CPU frequency scaling for older hardware
    cpuFreqGovernor = "conservative";
  };
  
  # Audio support handled by services.pulseaudio configuration above
  # sound.enable deprecated in NixOS 25.05
  
  # Legacy input device support (updated for NixOS 25.05)
  services.libinput = {
    enable = true;
    # More lenient settings for older touchpads
    touchpad = {
      accelProfile = "flat";
      accelSpeed = "0.5";
      naturalScrolling = false;  # Traditional scrolling for older users
    };
  };
}

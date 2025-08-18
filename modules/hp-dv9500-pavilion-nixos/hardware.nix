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
  # Note: nvidia-304 drivers no longer available in NixOS 25.05
  # Using open-source nouveau driver for better kernel compatibility
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # For legacy 32-bit applications
    extraPackages = with pkgs; [
      # Mesa drivers for nouveau (open-source NVIDIA)
      mesa  # mesa.drivers is deprecated, use mesa directly
      # Basic video acceleration support
      libvdpau-va-gl
      vaapiVdpau
    ];
  };
  
  # Use nouveau (open-source) driver for GeForce 7150M
  # This provides better compatibility with modern kernels than legacy proprietary drivers
  services.xserver.videoDrivers = [ "nouveau" ];
  
  # Ensure nouveau module is loaded
  boot.kernelModules = [ "nouveau" ];
  
  # Firmware for legacy hardware (allow unfree for full compatibility)
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;  # Required for some legacy firmware
  
  # Power management for legacy laptop
  powerManagement = {
    enable = true;
    # More conservative CPU frequency scaling for older hardware
    cpuFreqGovernor = "conservative";
  };
  
  # Audio support (likely AC97 or HDA) - PulseAudio configured above with lib.mkForce
  # services.pulseaudio settings are already configured at the top of this file
  
  # Legacy input device support - updated for NixOS 25.05
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

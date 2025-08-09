# /modules/hp-dv9500-pavilion-nixos/hardware.nix
# Hardware-specific configuration for HP dv9500 Pavilion (2007, AMD Turion 64 X2, NVIDIA GeForce 7150M)
{ config, pkgs, ... }:

{
  # Enable AMD CPU microcode updates (for AMD Turion 64 X2)
  hardware.cpu.amd.updateMicrocode = true;

  # Enable redistributable firmware (recommended for WiFi, etc.)
  hardware.enableRedistributableFirmware = true;

  # Use the open-source nouveau driver for legacy NVIDIA GeForce 7150M GPU
  services.xserver.videoDrivers = [ "nouveau" ];

  # Enable OpenGL/graphics support for legacy hardware
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable touchpad and input devices
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = false; # Traditional scrolling for older users
      disableWhileTyping = true;
    };
  };

  # Enable Bluetooth (if present on this model)
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false; # Save battery on old laptop
  };

  # Legacy hardware optimizations
  boot.kernel.sysctl = {
    # Optimize for older hardware
    "vm.swappiness" = 60; # Higher swap usage for limited RAM
    "vm.dirty_background_ratio" = 15;
    "vm.dirty_ratio" = 20;
  };

  # Hardware monitoring
  hardware.sensor = {
    hddtemp = {
      enable = true;
      drives = [ "/dev/sda" ]; # Monitor the main drive temperature
    };
  };

  # Power management optimizations for 2007 hardware
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
}

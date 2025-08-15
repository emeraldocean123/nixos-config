# /modules/hp-dv9500-pavilion-nixos/hardware.nix
# Hardware-specific configuration for HP dv9500 Pavilion (2007, AMD Turion 64 X2, NVIDIA GeForce 7150M)
{ config, pkgs, ... }:

{
  # Enable AMD CPU microcode updates (for AMD Turion 64 X2)
  hardware.cpu.amd.updateMicrocode = true;

  # (redistributable firmware enabled in shared/hardware-base.nix)

  # Use the open-source nouveau driver for legacy NVIDIA GeForce 7150M GPU
  services.xserver.videoDrivers = [ "nouveau" ];

  # (graphics/touchpad/bluetooth base config in shared/hardware-base.nix)
  
  # HP-specific touchpad settings (override shared defaults)
  services.libinput.touchpad = {
    naturalScrolling = false; # Traditional scrolling for older users
  };

  # HP-specific Bluetooth settings (override shared defaults)
  hardware.bluetooth.powerOnBoot = false; # Save battery on old laptop

  # Legacy hardware optimizations
  boot.kernel.sysctl = {
    # Optimize for older hardware
    "vm.swappiness" = 60; # Higher swap usage for limited RAM
    "vm.dirty_background_ratio" = 10; # More conservative for old hardware
    "vm.dirty_ratio" = 15; # Reduce dirty page ratio for stability
    # Filesystem stability improvements
    "fs.file-max" = 65536;
  };

  # Filesystem mount options for stability
  fileSystems."/" = {
    options = [ "relatime" "errors=remount-ro" ];
  };

  # Hardware monitoring (hddtemp removed; not available on 25.05)

  # Power management optimizations for 2007 hardware
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
}

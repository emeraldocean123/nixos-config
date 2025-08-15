# modules/profiles/legacy-hardware.nix
# Profile for legacy hardware optimizations (2007-era laptops)
{ config, pkgs, ... }:
{
  # Legacy hardware optimizations
  boot.kernel.sysctl = {
    # Optimize for older hardware with limited RAM
    "vm.swappiness" = 60; # Higher swap usage for limited RAM
    "vm.dirty_background_ratio" = 10; # More conservative for old hardware
    "vm.dirty_ratio" = 15; # Reduce dirty page ratio for stability
  };

  # Filesystem mount options for stability on older drives
  fileSystems."/" = {
    options = [ "relatime" "errors=remount-ro" ];
  };

  # Conservative power settings for battery preservation
  hardware.bluetooth.powerOnBoot = false; # Save battery on old laptop

  # Traditional scrolling for older users
  services.libinput.touchpad.naturalScrolling = false;

  # Legacy GPU driver support
  services.xserver.videoDrivers = [ "nouveau" ]; # For older NVIDIA cards
}
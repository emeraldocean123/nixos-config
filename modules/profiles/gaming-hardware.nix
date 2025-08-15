# modules/profiles/gaming-hardware.nix
# Profile for gaming hardware optimizations
{ config, pkgs, ... }:
{
  # Gaming hardware optimizations
  boot.kernel.sysctl = {
    # Reduce input lag for gaming
    "kernel.sched_migration_cost_ns" = 5000000;
    # Improve gaming performance
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_ratio" = 10;
  };

  # Hardware monitoring packages
  environment.systemPackages = with pkgs; [
    # GPU diagnostics and monitoring
    mesa-demos  # glxinfo/glxgears
    nvtopPackages.full
  ];

  # Enhanced Bluetooth for gaming peripherals
  hardware.bluetooth = {
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  # Modern touchpad settings
  services.libinput.touchpad.naturalScrolling = true;
}
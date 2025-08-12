# modules/msi-ge75-raider-nixos/hardware.nix
# MSI GE75 Raider hardware (2018, i7-9750H, RTX 2070)
{ config, pkgs, ... }:

{
  # Hardware acceleration and graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable firmware and microcode updates
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  # Enable touchpad and input devices
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      disableWhileTyping = true;
    };
  };

  # Gaming hardware optimizations
  boot.kernel.sysctl = {
    # Reduce input lag
    "kernel.sched_migration_cost_ns" = 5000000;
    # Improve gaming performance
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_ratio" = 10;
  };

  # Performance monitoring: add sensors/SMART in host config if needed

  # Enable USB devices (gaming peripherals)
    # services.udev.extraRules = ''
    #   # Gaming mouse/keyboard permissions
    #   SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", MODE="0666"  # Logitech
    #   SUBSYSTEM=="usb", ATTRS{idVendor}=="1532", MODE="0666"  # Razer
    #   SUBSYSTEM=="usb", ATTRS{idVendor}=="0b05", MODE="0666"  # ASUS
    # '';
}

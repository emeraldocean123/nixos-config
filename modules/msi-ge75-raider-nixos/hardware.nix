# modules/msi-ge75-raider-nixos/hardware.nix
# MSI GE75 Raider hardware (2018, i7-9750H, RTX 2070)
{ config, pkgs, ... }:

{
  # (graphics/touchpad/bluetooth base config in shared/hardware-base.nix)
  
  # Enable Intel CPU microcode updates (for i7-9750H)
  hardware.cpu.intel.updateMicrocode = true;

  # MSI-specific Bluetooth settings (enhanced features)
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };

  # MSI-specific touchpad settings (modern scrolling)
  services.libinput.touchpad = {
    naturalScrolling = true;
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

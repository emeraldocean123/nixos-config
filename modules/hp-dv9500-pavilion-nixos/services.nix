# /etc/nixos/modules/hp-dv9500-pavilion-nixos/services.nix
# Services configuration for HP dv9500 Pavilion (2007, AMD Turion 64 X2, NVIDIA GeForce 7150M)

{ config, pkgs, ... }:

{
  # Audio system (PipeWire for better compatibility)
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;  # Disable Jack for simplicity on legacy hardware
  };
  security.rtkit.enable = true;

  # Enable D-Bus for desktop applications
  services.dbus.enable = true;

  # Enable printing (CUPS)
  services.printing.enable = true;

  # Enable SSH server for remote access
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  # Power management for legacy laptop
  services.tlp = {
    enable = true;
    settings = {
      # Conservative power settings for 2007 hardware
      CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      # Aggressive power saving for old battery
      USB_AUTOSUSPEND = 1;
      WIFI_PWR_ON_AC = "on";
      WIFI_PWR_ON_BAT = "on";
      
      # Conservative PCI Express settings
      PCIE_ASPM_ON_AC = "powersave";
      PCIE_ASPM_ON_BAT = "powersave";
    };
  };

  # Location services
  services.geoclue2.enable = true;

  # Legacy hardware considerations
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # Lid switch behavior (useful for older laptops)
  services.logind = {
    lidSwitch = "ignore";  # Don't suspend on lid close
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
    powerKey = "poweroff";  # Power button shuts down
  };

  # Enable firmware updates (if supported)
  services.fwupd.enable = true;

  # Thermald for thermal management
  services.thermald.enable = true;

  # USB automounting
  services.udisks2.enable = true;

  # Enable NTFS support for external drives
  boot.supportedFilesystems = [ "ntfs" ];
}

# /modules/msi-ge75-raider-nixos/services.nix
{ config, pkgs, ... }:

{
  # Gaming and performance-optimized services

  # Enable D-Bus for desktop applications
  services.dbus.enable = true;

  # Enable CUPS for printing
  services.printing.enable = true;

  # Enable sound with PipeWire (better for gaming)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Gaming-specific services
  services.ratbagd.enable = true; # Gaming mouse configuration
  hardware.openrazer.enable = true; # Razer peripherals support

  # Performance and monitoring services
  services.thermald.enable = true; # Thermal management
  services.auto-cpufreq.enable = true; # Automatic CPU frequency scaling
  powerManagement.cpuFreqGovernor = "ondemand"; # Balanced performance

  # Enable location services (for automatic time zone, etc.)
  services.geoclue2.enable = true;

  # Enable the OpenSSH daemon for remote access
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  # Enable nix-ld for dynamic linker compatibility (required for VS Code Remote SSH)
  programs.nix-ld.enable = true;

  # Enable Flatpak for additional gaming applications
  services.flatpak.enable = true;

  # Enable GNOME services that KDE Plasma can use
  services.gnome.gnome-keyring.enable = true;

  # Enable firmware updates
  services.fwupd.enable = true;

  # Gaming performance optimizations
  services.gamemode.enable = true;

  # Enable udev rules for gaming controllers
  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];

  # Enable USB automounting
  services.udisks2.enable = true;

  # Enable NTFS support for Windows game drives
  boot.supportedFilesystems = [ "ntfs" ];

  # Power management for gaming laptop
  services.tlp = {
    enable = true;
    settings = {
      # Gaming optimizations
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Disable USB autosuspend for gaming peripherals
      USB_AUTOSUSPEND = 0;

      # Keep WiFi power management disabled for stable gaming
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # PCI Express power management
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersave";
    };
  };

  # Enable container support for development
  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;
}
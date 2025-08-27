# modules/roles/gaming-performance.nix
# Gaming performance optimizations - TLP settings, thermal management, etc.
{pkgs, ...}: {
  # Power management optimized for gaming
  services.power-profiles-daemon.enable = false; # conflicts with TLP
  services.auto-cpufreq.enable = false; # disable; TLP is our choice

  services.tlp = {
    enable = true;
    settings = {
      # Gaming optimizations
      # Note: CPU governors and PCIE settings are configured in gaming-hardware.nix
      CPU_SCALING_GOVERNOR_ON_AC = "performance";

      # Disable USB autosuspend for gaming peripherals
      USB_AUTOSUSPEND = 0;

      # Keep WiFi power management disabled for stable gaming
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # PCI Express power management
      PCIE_ASPM_ON_BAT = "powersave";
    };
  };

  # Gaming peripheral support
  services.ratbagd.enable = true; # Gaming mouse configuration
  hardware.openrazer.enable = true; # Razer peripherals support

  # Gaming controller support
  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];

  # Performance and thermal management
  services.thermald.enable = true;

  # NTFS support for Windows game drives
  boot.supportedFilesystems = ["ntfs"];

  # Enable Flatpak for additional gaming applications
  services.flatpak.enable = true;
}

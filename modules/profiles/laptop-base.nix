# modules/profiles/laptop-base.nix
# Common laptop optimizations and power management
_: {
  # Power management optimizations
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # Common laptop services
  services = {
    # Enable SMART monitoring for laptop drives
    smartd.enable = true;

    # Auto-mount USB devices
    udisks2.enable = true;

    # Network time sync
    timesyncd.enable = true;
  };

  # Laptop-specific sysctl optimizations
  boot.kernel.sysctl = {
    # Filesystem optimizations for laptop storage
    "fs.file-max" = 65536;
  };

  # Enable laptop-specific hardware features
  services.acpid.enable = true;
}

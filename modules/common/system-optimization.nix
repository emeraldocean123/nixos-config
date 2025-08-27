# System optimization module with garbage collection and performance tuning
{
  lib,
  pkgs,
  ...
}: {
  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
    persistent = true; # Run even if machine was off
  };

  # Automatic store optimization
  nix.optimise = {
    automatic = true;
    dates = ["weekly"];
  };

  # System performance tuning
  powerManagement = {
    # CPU frequency scaling
    cpuFreqGovernor = lib.mkDefault "ondemand";

    # Enable power management
    enable = true;
  };

  # Zram swap for better memory management
  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = "zstd";
    memoryPercent = lib.mkDefault 50; # Gaming profiles may override to 25%
  };

  # SSD optimizations (if applicable)
  services.fstrim = {
    enable = lib.mkDefault true;
    interval = "weekly";
  };

  # Better I/O scheduling and performance tuning
  # NOTE: CPU vulnerability mitigations are kept enabled for security
  # Use selective optimizations instead of blanket "mitigations=off"
  boot.kernelParams = [
    # I/O and performance optimizations that don't compromise security
    "elevator=mq-deadline" # Better I/O scheduler for SSDs
    "transparent_hugepage=madvise" # More efficient memory management
  ];

  # Systemd service optimizations
  systemd.services = {
    # Nix daemon with higher priority (override NixOS default IOSchedulingPriority = 4)
    nix-daemon.serviceConfig = {
      Nice = -5;
      IOSchedulingClass = "best-effort";
      IOSchedulingPriority = lib.mkForce 0;
    };
  };

  # Earlyoom - kill processes before OOM
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
    enableNotifications = true;
  };

  # Force systembus-notify for earlyoom notifications (conflicts with smartd default)
  services.systembus-notify.enable = lib.mkForce true;

  # System monitoring tools
  environment.systemPackages = with pkgs; [
    htop
    iotop
    iftop
    ncdu
    duf
    btop
  ];

  # Disable unnecessary documentation
  documentation = {
    enable = lib.mkDefault true;
    doc.enable = lib.mkDefault false;
    info.enable = lib.mkDefault false;
    man.enable = lib.mkDefault true; # Keep man pages
    nixos.enable = lib.mkDefault false;
  };

  # Font cache optimization
  fonts.fontDir.enable = true;

  # Tmpfs for /tmp (faster, uses RAM)
  boot.tmp.useTmpfs = lib.mkDefault true;
  boot.tmp.tmpfsSize = lib.mkDefault "50%";
}

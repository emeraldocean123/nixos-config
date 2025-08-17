# System optimization module with garbage collection and performance tuning
{ config, lib, pkgs, ... }:

{
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
    dates = [ "weekly" ];
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
    memoryPercent = 50;
  };
  
  # SSD optimizations (if applicable)
  services.fstrim = {
    enable = lib.mkDefault true;
    interval = "weekly";
  };
  
  # Better I/O scheduling
  boot.kernelParams = [
    "mitigations=off" # Disable CPU vulnerability mitigations for performance (optional)
  ];
  
  # Systemd service optimizations
  systemd.services = {
    # Nix daemon with higher priority
    nix-daemon.serviceConfig = {
      Nice = -5;
      IOSchedulingClass = "best-effort";
      IOSchedulingPriority = 0;
    };
  };
  
  # Earlyoom - kill processes before OOM
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
    enableNotifications = true;
  };
  
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
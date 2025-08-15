# modules/roles/gaming.nix
# Gaming role - Steam, performance optimizations, and gaming tools
{ config, pkgs, lib, ... }:
{
  # Enable Steam and gaming features
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Gaming hardware support
  hardware.steam-hardware.enable = true;

  # Gaming-specific packages
  environment.systemPackages = with pkgs; [
    # Game launchers and tools
    lutris
    bottles
    heroic
    
    # Gaming utilities
    gamemode
    mangohud
    gamescope
    
    # Performance monitoring
    corectrl
  ];

  # Enable GameMode for performance optimization
  programs.gamemode.enable = true;

  # Gaming peripheral permissions
  services.udev.extraRules = ''
    # Gaming mouse/keyboard permissions
    # Logitech devices
    SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", MODE="0666"
    # Razer devices
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1532", MODE="0666"
    # ASUS devices
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0b05", MODE="0666"
    # SteelSeries devices
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1038", MODE="0666"
    # Corsair devices
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1b1c", MODE="0666"
  '';

  # Gaming-related firewall ports
  networking.firewall = {
    allowedTCPPorts = [
      27036 # Steam in-home streaming
      27037 # Steam in-home streaming
    ];
    allowedUDPPorts = [
      27031 # Steam in-home streaming
      27036 # Steam in-home streaming
    ];
  };
}
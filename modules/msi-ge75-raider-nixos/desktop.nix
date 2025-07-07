# /etc/nixos/modules/msi-ge75-raider-nixos/desktop.nix
# KDE Plasma desktop environment for MSI GE75 Raider 9SF (2018, Intel Core i7-9750H, RTX 2070)

{ config, pkgs, ... }:

{
  # Enable X11 and Wayland
  services.xserver = {
    enable = true;
    
    # Gaming-optimized X11 configuration
    deviceSection = ''
      Option "TripleBuffer" "on"
      Option "AccelMethod" "glamor"
      Option "DRI" "3"
    '';
    
    # Keyboard layout
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Display Manager (SDDM)
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
    };
    defaultSession = "plasma";
    
    # Auto-login for convenience (comment out for security)
    # autoLogin = {
    #   enable = true;
    #   user = "joseph";
    # };
  };

  # KDE Plasma 6 Desktop Environment
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };

  # Gaming-specific desktop packages
  environment.systemPackages = with pkgs; [
    # KDE applications
    kate
    konsole
    dolphin
    spectacle
    gwenview
    okular
    
    # Gaming-specific desktop tools
    gamemode
    gamescope
    mangohud
    goverlay
    
    # System monitoring for gaming
    htop
    nvtop
    lm_sensors
    
    # Screenshot and recording
    flameshot
    obs-studio
    
    # Archive managers
    ark
    p7zip
    unrar
  ];

  # Portal configuration for Plasma
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # Gaming-specific desktop settings
  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = true;
  
  # Enable thumbnails for media files
  services.tumbler.enable = true;
}

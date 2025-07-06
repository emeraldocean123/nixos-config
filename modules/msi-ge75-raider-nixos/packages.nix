# /etc/nixos/modules/msi-ge75-raider-nixos/packages.nix
# Package configuration for MSI GE75 Raider 9SF (2018, Intel Core i7-9750H, RTX 2070)

{ config, pkgs, ... }:

{
  # Gaming and performance-focused package selection
  environment.systemPackages = with pkgs; [
    # Essential system tools
    git
    wget
    curl
    vim
    nano
    unzip
    htop
    tree
    lshw
    pciutils
    usbutils

    # Gaming essentials
    steam
    lutris
    heroic
    bottles
    wine
    winetricks
    protontricks
    gamemode
    gamescope

    # Performance monitoring
    nvtop
    nvidia-system-monitor-qt
    lm_sensors
    stress
    s-tui
    cpupower-gui

    # Development tools
    gcc
    clang
    python3
    nodejs
    yarn
    cmake
    gnumake

    # Media and streaming
    obs-studio
    vlc
    firefox
    discord
    spotify

    # Graphics tools
    gimp
    blender
    krita

    # System utilities
    gparted
    baobab
    filelight
    spectacle
    flameshot

    # Gaming peripherals support
    openrgb
    piper
    ratbagd

    # Network tools
    nmap
    wireshark
    iperf3
    speedtest-cli

    # Archive tools
    p7zip
    unrar
    zip

    # Fonts for gaming and development
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Hack" ]; })
    liberation_ttf
    dejavu_fonts
  ];

  # Enable Steam and gaming-related services
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Enable GameMode for performance optimization
  programs.gamemode.enable = true;

  # Enable Java for Minecraft and other games
  programs.java.enable = true;

  # Gaming-specific fonts
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Hack" ]; })
      liberation_ttf
      dejavu_fonts
      source-code-pro
      roboto
      ubuntu_font_family
    ];
    
    fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
      hinting.style = "slight";
      subpixel.rgba = "rgb";
    };
  };
}

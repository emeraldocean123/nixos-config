# /etc/nixos/modules/msi-ge75-raider-nixos/users.nix
# User configuration for MSI GE75 Raider 9SF (2018, Intel Core i7-9750H, RTX 2070)

{ config, pkgs, ... }:

{
  # User account configuration
  users.users.joseph = {
    isNormalUser = true;
    description = "Joseph";
    extraGroups = [ 
      "wheel"          # Enable sudo
      "networkmanager" # Network management
      "audio"          # Audio access
      "video"          # Video devices
      "input"          # Input devices (important for gaming)
      "docker"         # Docker access
      "podman"         # Podman access
      "gamemode"       # GameMode access
      "plugdev"        # Gaming peripherals
      "disk"           # Disk management
      "storage"        # Storage management
    ];
    shell = pkgs.bash;
    
    # Home directory permissions for gaming
    createHome = true;
    home = "/home/joseph";
    
    # Allow Joseph to manage gaming-related services
    packages = with pkgs; [
      # User-specific gaming tools
      steam-run
      protonup-qt
      
      # Development tools for user
      git
      vim
      code-cursor
      
      # Gaming utilities
      mangohud
      goverlay
    ];
  };

  # Gaming-specific user configurations
  users.extraGroups = {
    gamemode = {};
    plugdev = {};
  };

  # Security settings for gaming
  security.sudo.extraRules = [
    {
      users = [ "joseph" ];
      commands = [
        {
          command = "${pkgs.systemd}/bin/systemctl";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.cpupower}/bin/cpupower";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Gaming-specific PAM configuration
  security.pam.loginLimits = [
    {
      domain = "@gamemode";
      item = "nice";
      type = "soft";
      value = "-10";
    }
    {
      domain = "@gamemode";
      item = "rtprio";
      type = "soft";
      value = "20";
    }
  ];

  # Enable automatic login for convenience (optional, comment out for security)
  # services.xserver.displayManager.autoLogin = {
  #   enable = true;
  #   user = "joseph";
  # };

  # User shell configuration
  programs.bash.shellInit = ''
    # Gaming-specific environment variables
    export GAMING_MODE=1
    export __GL_SHADER_DISK_CACHE=1
    export __GL_SHADER_DISK_CACHE_PATH="$HOME/.cache/nv"
    
    # Gaming performance tweaks
    export __GL_THREADED_OPTIMIZATIONS=1
    export __GL_SYNC_TO_VBLANK=0
    
    # Steam specific
    export STEAM_RUNTIME_PREFER_HOST_LIBRARIES=0
    export STEAM_RUNTIME=1
  '';

  # User directories for gaming
  systemd.user.tmpfiles.rules = [
    "d /home/joseph/Games 0755 joseph users -"
    "d /home/joseph/.steam 0755 joseph users -"
    "d /home/joseph/.local/share/Steam 0755 joseph users -"
    "d /home/joseph/.cache/nv 0755 joseph users -"
  ];
}

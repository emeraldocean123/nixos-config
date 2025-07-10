# /home/hp-dv9500-pavilion-nixos/joseph.nix
{ config, pkgs, ... }:

{
  # Import shared dotfiles configuration
  imports = [
    ../../modules/shared/dotfiles.nix
  ];
  # Set the username and home directory for this Home Manager profile
  home.username = "joseph";
  home.homeDirectory = "/home/joseph";
  home.stateVersion = "25.05";

  # Essential packages including Oh My Posh and development tools
  home.packages = with pkgs; [
    # System packages
    dconf

    # Development tools
    git
    curl
    wget
    unzip
    nano

    # Shell enhancement
    oh-my-posh
    fzf

    # Additional HP-specific packages
    htop
    fastfetch
  ];

  # Host-specific bash configuration (extends shared dotfiles)
  programs.bash = {
    enable = true;
    # Host-specific aliases. Common aliases are inherited from modules/shared/dotfiles.nix
    shellAliases = {
      battery = "cat /sys/class/power_supply/BAT*/capacity";
      temp = "sensors | grep 'Core\\|temp'";
      brightness = "xrandr --verbose | grep -i brightness";
    };

    bashrcExtra = ''
      # HP-specific bash configuration

      # Oh My Posh prompt (using custom theme)
      if command -v oh-my-posh &> /dev/null; then
        if [ -f ~/.config/oh-my-posh/jandedobbeleer.omp.json ]; then
          eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/jandedobbeleer.omp.json)"
        else
          eval "$(oh-my-posh init bash --config $(oh-my-posh config list | grep jandedobbeleer | head -1))"
        fi
      fi

      # Legacy hardware specific functions
      legacy_mode() {
        echo "Setting legacy compatibility mode for 2007 hardware..."
        # Add any legacy-specific configurations here
      }

      # HP system monitoring
      show_hp_status() {
        echo "=== HP dv9500 Pavilion Status ==="
        echo "Battery: $(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null || echo 'N/A')%"
        echo "Temperature: $(sensors 2>/dev/null | grep 'Core\|temp' | head -1 || echo 'N/A')"
        echo "Memory Usage: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
        echo "Load Average: $(cat /proc/loadavg | awk '{print $1, $2, $3}')"
      }

      alias hpstatus="show_hp_status"
    '';
  };

  # Enable other CLI programs
  programs.htop.enable = true;
  programs.fastfetch.enable = true;

  # Enable fzf for fuzzy finding
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  # GTK theming for user applications (matches system theming)
  gtk = {
    enable = true;
    theme.name = "Arc-Dark";
    iconTheme.name = "Papirus";
  };

  # HP-specific home files and configurations
  home.file = {
    # Oh My Posh theme configuration
    ".config/oh-my-posh/jandedobbeleer.omp.json".source = ../../modules/shared/jandedobbeleer.omp.json;

    # Create HP-specific dotfiles or overrides if needed
    ".hp-laptop-config".text = ''
      # HP dv9500 Pavilion specific configuration
      # 2007 laptop with AMD Turion 64 X2, NVIDIA GeForce 7150M

      # Hardware info
      export HP_MODEL="dv9500"
      export HP_YEAR="2007"
      export HP_CPU="AMD_Turion_64_X2"
      export HP_GPU="NVIDIA_GeForce_7150M"

      # Power management helpers
      function show_battery() {
        if [ -f /sys/class/power_supply/BAT*/capacity ]; then
          cat /sys/class/power_supply/BAT*/capacity
        else
          echo "No battery found"
        fi
      }

      function show_temps() {
        if command -v sensors &> /dev/null; then
          sensors | grep -E '(Core|temp|Package)'
        else
          echo "lm-sensors not installed"
        fi
      }

      function legacy_compat() {
        echo "HP dv9500 Legacy Compatibility Mode"
        echo "This is a 2007 laptop - some modern features may not work"
      }
    '';
  };
}
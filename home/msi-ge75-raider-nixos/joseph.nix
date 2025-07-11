# /home/msi-ge75-raider-nixos/joseph.nix
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

    # Gaming and performance tools (MSI-specific)
    htop
    fastfetch
    neofetch
    glxinfo
    nvidia-settings
    steam-run
    protonup-qt
    mangohud
    goverlay
  ];

  # MSI-specific bash configuration (extends shared dotfiles)
  programs.bash = {
    enable = true;
    # Host-specific aliases. Common aliases are inherited from modules/shared/dotfiles.nix
    shellAliases = {
      # Gaming and performance aliases
      gpu-temp = "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits";
      gpu-usage = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits";
      gpu-info = "nvidia-smi";
      cpu-temp = "sensors | grep 'Package id 0' | awk '{print $4}'";
      performance = "sudo cpupower frequency-set -g performance";
      powersave = "sudo cpupower frequency-set -g powersave";

      # Gaming shortcuts
      steam-native = "steam";
      steam-proton = "steam-run steam";

      # Development shortcuts for gaming
      "build-fast" = "make -j$(nproc)";
      "compile-fast" = "gcc -O3 -march=native";
      sysperf = "show_system_performance";
    };

    bashrcExtra = ''
      # MSI Gaming Laptop specific configuration

      # Oh My Posh prompt (using custom theme)
      if command -v oh-my-posh &> /dev/null; then
        if [ -f ~/.config/oh-my-posh/jandedobbeleer.omp.json ]; then
          eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/jandedobbeleer.omp.json)"
        else
          eval "$(oh-my-posh init bash --config $(oh-my-posh config list | grep jandedobbeleer | head -1))"
        fi
      fi

      # Source MSI-specific config
      [ -f ~/.msi-gaming-config ] && source ~/.msi-gaming-config
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

  # KDE Plasma theming for user applications (MSI gaming setup)
  gtk = {
    enable = true;
    theme.name = "Breeze-Dark";
    iconTheme.name = "Breeze";
  };

  # MSI-specific home files and configurations
  home.file = {
    # Oh My Posh theme configuration
    ".config/oh-my-posh/jandedobbeleer.omp.json".source = ../../modules/shared/jandedobbeleer.omp.json;

    # MSI gaming laptop configuration
    ".msi-gaming-config".text = ''
      # MSI GE75 Raider 9SF specific configuration
      # 2018 gaming laptop with Intel Core i7-9750H, RTX 2070

      # Hardware info
      export MSI_MODEL="GE75-Raider-9SF"
      export MSI_YEAR="2018"
      export MSI_CPU="Intel_Core_i7-9750H"
      export MSI_GPU="NVIDIA_RTX_2070"
      export MSI_RAM="32GB_DDR4"

      # Gaming optimizations
      function gaming_mode() {
        echo "Activating MSI Gaming Mode..."
        sudo cpupower frequency-set -g performance 2>/dev/null || echo "cpupower not available"
        echo "Gaming mode activated!"
      }

      function power_save() {
        echo "Activating Power Save Mode..."
        sudo cpupower frequency-set -g powersave 2>/dev/null || echo "cpupower not available"
        echo "Power save mode activated!"
      }

      function show_gpu_stats() {
        if command -v nvidia-smi &> /dev/null; then
          nvidia-smi --query-gpu=name,temperature.gpu,utilization.gpu,memory.used,memory.total --format=csv,noheader
        else
          echo "nvidia-smi not available"
        fi
      }

      # System monitoring for gaming
      show_system_performance() {
        echo "=== MSI GE75 Raider Performance Monitor ==="
        echo "CPU Temperature: $(sensors 2>/dev/null | grep 'Package id 0' | awk '{print $4}' || echo 'N/A')"
        echo "GPU Temperature: $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null)°C"
        echo "GPU Usage: $(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null)%"
        echo "Memory Usage: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
        echo "Load Average: $(cat /proc/loadavg | awk '{print $1, $2, $3}')"
      }
    '';

    # Gaming shortcuts desktop file
    ".local/share/applications/gaming-tools.desktop".text = ''
      [Desktop Entry]
      Name=MSI Gaming Tools
      Comment=Gaming performance tools for MSI laptop
      Exec=konsole -e 'bash -c "echo MSI Gaming Tools; sysperf; read"'
      Icon=applications-games
      Type=Application
      Categories=Game;System;
    '';
  };
}
{ pkgs, ... }:
{
  imports = [
    ../../modules/shared/prompt.nix
    ../../modules/shared/dotfiles.nix
    ../../modules/shared/path-localbin.nix
  ];
  home.username = "joseph";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    dconf
    git
    curl
    wget
    unzip
    nano
    oh-my-posh
    fzf
    htop
    fastfetch
  ];
  programs.bash = {
    enable = true;
    shellAliases = {
      hpstatus = "show_hp_status";
      battery = "cat /sys/class/power_supply/BAT*/capacity";
      brightness = "xrandr --verbose | grep -i brightness";
      temp = "sensors | grep 'Core\\|temp'";
    };
    bashrcExtra = ''
      [ -f ~/.bash_aliases ] && . ~/.bash_aliases
      [ -f ~/.msi-gaming-config ] && . ~/.msi-gaming-config
    '';
  };
  programs.htop.enable = true;
  programs.fastfetch.enable = true;
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
  home.file = {
    ".msi-gaming-config".text = ''
      export MSI_MODEL="GE75-Raider-9SF"
      export MSI_YEAR="2018"
      export MSI_CPU="Intel_Core_i7-9750H"
      export MSI_GPU="NVIDIA_RTX_2070"
      gaming_mode() {
        echo "Activating MSI Gaming Mode..."
        sudo cpupower frequency-set -g performance 2>/dev/null || echo "cpupower not available"
        echo "Gaming mode activated!"
      }
      power_save() {
        echo "Activating Power Save Mode..."
        sudo cpupower frequency-set -g powersave 2>/dev/null || echo "cpupower not available"
        echo "Power save mode activated!"
      }
      show_gpu_stats() {
        if command -v nvidia-smi &> /dev/null; then
          nvidia-smi --query-gpu=name,temperature.gpu,utilization.gpu,memory.used,memory.total --format=csv,noheader
        else
          echo "nvidia-smi not available"
        fi
      }
      show_system_performance() {
        echo "=== MSI GE75 Raider Performance Monitor ==="
        echo "CPU Temperature: $(sensors 2>/dev/null | grep 'Package id 0' | awk '{print $4}' || echo 'N/A')"
        echo "GPU Temperature: $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null)°C"
        echo "GPU Usage: $(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null)%"
        echo "Memory Usage: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
        echo "Load Average: $(cat /proc/loadavg | awk '{print $1, $2, $3}')"
      }
    '';
  };
}

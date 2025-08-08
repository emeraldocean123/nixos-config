# /home/hp-dv9500-pavilion-nixos/joseph.nix
{ config, pkgs, ... }:

{
  imports = [
    ../../modules/shared/prompt.nix
    ../../modules/shared/path-localbin.nix
    ../../modules/shared/dotfiles.nix
  ];

  home.username = "joseph";
  home.homeDirectory = "/home/joseph";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    dconf
    git curl wget unzip nano
    oh-my-posh fzf
    htop fastfetch
  ];

  programs.bash = {
    enable = true;

    # Make login shells read ~/.bashrc (so OMP + fastfetch run there too)
    profileExtra = ''
      [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
    '';

    shellAliases = {
      battery    = "cat /sys/class/power_supply/BAT*/capacity";
      temp       = "sensors | grep 'Core\\|temp'";
      brightness = "xrandr --verbose | grep -i brightness";
      hpstatus   = "show_hp_status";
    };

    # Minimal — prompt/fastfetch handled centrally in prompt.nix
    bashrcExtra = ''
      [ -f ~/.hp-laptop-config ] && . ~/.hp-laptop-config
    '';
  };

  programs.htop.enable = true;
  programs.fastfetch.enable = true;

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  gtk = {
    enable = true;
    theme.name = "Arc-Dark";
    iconTheme.name = "Papirus";
  };

  home.file = {
    ".config/oh-my-posh/jandedobbeleer.omp.json".source = ../../modules/shared/jandedobbeleer.omp.json;

    ".config/kitty/kitty.conf".text = ''
      font_family MesloLGS Nerd Font
      font_size 12
      background_opacity 0.95
      scrollback_lines 10000
    '';

    ".hp-laptop-config".text = ''
      export HP_MODEL="dv9500"
      export HP_YEAR="2007"
      export HP_CPU="AMD_Turion_64_X2"
      export HP_GPU="NVIDIA_GeForce_7150M"

      show_battery() { if [ -f /sys/class/power_supply/BAT*/capacity ]; then cat /sys/class/power_supply/BAT*/capacity; else echo "No battery found"; fi; }
      show_temps()   { if command -v sensors &>/dev/null; then sensors | grep -E '(Core|temp|Package)'; else echo "lm-sensors not installed"; fi; }

      legacy_compat() { echo "HP dv9500 Legacy Compatibility Mode"; echo "This is a 2007 laptop - some modern features may not work"; }
      legacy_mode()   { echo "Setting legacy compatibility mode for 2007 hardware..."; }

      show_hp_status() {
        echo "=== HP dv9500 Pavilion Status ==="
        echo "Battery: $(show_battery)%"
        echo "Temperature: $(show_temps | head -1 || echo 'N/A')"
        echo "Memory Usage: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
        echo "Load Average: $(awk '{print $1, $2, $3}' /proc/loadavg)"
      }
    '';
  };
}

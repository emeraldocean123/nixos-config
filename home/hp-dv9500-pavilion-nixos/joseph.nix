{ pkgs, ... }:
{
  imports = [
    ../../modules/shared/prompt.nix
    ../../modules/shared/path-localbin.nix
    ../../modules/shared/dotfiles.nix
  ];

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    dconf
    git # git is in system packages, but also good to have in user profile
    curl
    wget
    unzip
    nano
    fzf
    htop
    fastfetch
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      battery = "cat /sys/class/power_supply/BAT*/capacity";
      temp = "sensors | grep 'Core\\|temp'";
      brightness = "xrandr --verbose | grep -i brightness";
      hpstatus = "show_hp_status";
    };
    bashrcExtra = ''
      # Source aliases and custom scripts
      [ -f ~/.bash_aliases ] && . ~/.bash_aliases
      [ -f ~/.hp-laptop-config ] && . ~/.hp-laptop-config
    '';
  };

  programs.fzf.enable = true;

  gtk = {
    enable = true;
    theme.name = "Arc-Dark";
    iconTheme.name = "Papirus";
  };

  home.file = {
    ".config/kitty/kitty.conf".text = ''
      font_family MesloLGS Nerd Font
      font_size 12
    '';
    ".hp-laptop-config".text = ''
      export HP_MODEL="dv9500"
      export HP_YEAR="2007"
      show_hp_status() {
        echo "=== HP dv9500 Pavilion Status ==="
        echo "Battery: $(cat /sys/class/power_supply/BAT*/capacity || echo 'N/A')%"
        echo "Temperature: $(sensors | grep 'Core' | awk '{print $3}' | head -n1 || echo 'N/A')"
        echo "Memory Usage: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
        echo "Load Average: $(awk '{print $1, $2, $3}' /proc/loadavg)"
      }
    '';
  };
}

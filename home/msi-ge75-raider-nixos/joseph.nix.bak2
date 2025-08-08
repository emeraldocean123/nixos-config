# /home/msi-ge75-raider-nixos/joseph.nix
{ config, pkgs, ... }:
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
    git curl wget unzip nano
    oh-my-posh fzf
    htop fastfetch
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
      [ -f ~/.msi-gaming-config ] && . ~/.msi-gaming-config
    '';
  };
  programs.htop.enable = true;
  programs.fastfetch.enable = true;
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
  home.file.".config/oh-my-posh/jandedobbeleer.omp.json".source =
    ../../modules/shared/jandedobbeleer.omp.json;
}

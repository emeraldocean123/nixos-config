## home/hp-dv9500-pavilion-nixos/joseph.nix
# Home Manager configuration for user joseph on HP dv9500 Pavilion
{ pkgs, ... }:
{
  imports = [
    ../../modules/shared/prompt.nix
    ../../modules/shared/path-localbin.nix
    ../../modules/shared/dotfiles.nix
  ];

  home.username = "joseph";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    dconf git curl wget unzip nano
    oh-my-posh fzf htop fastfetch
  ];

  programs.bash = {
    enable = true;
    # Aliases and PATH handled via shared modules
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.htop.enable = true;
  programs.fastfetch.enable = true;
}

## home/hp-dv9500-pavilion-nixos/follett.nix
# Home Manager configuration for user follett on HP dv9500 Pavilion
{ pkgs, ... }:
{
  imports = [
    ../../modules/shared/prompt.nix
    ../../modules/shared/dotfiles.nix
  ../../modules/shared/path-localbin.nix
  ../../modules/shared/cleanup.nix
  ];
  home.username = "follett";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    dconf git curl wget unzip nano
    oh-my-posh fzf htop fastfetch
  ];
  programs.bash = {
    enable = true;
  };
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.htop.enable = true;
  programs.fastfetch.enable = true;
  # LXQt power management enabled; GUI controls lid when logged in.
  # No host-specific GTK settings here to keep users identical; set per-host system-wide if needed
}

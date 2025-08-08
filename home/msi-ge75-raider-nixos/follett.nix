# /home/msi-ge75-raider-nixos/follett.nix
{ config, pkgs, ... }:
{
  imports = [ ../../modules/shared/prompt.nix
    ../../modules/shared/dotfiles.nix
  ];
  home.username = "follett";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    dconf
    htop
    fastfetch
  ];
  programs.bash = {
    enable = true;
    shellAliases = {
      notes = "cd ~/Documents/Notes";
    };
    bashrcExtra = ''
      echo "Welcome, Follett!"
    '';
  };
  programs.fastfetch.enable = true;
  gtk = {
    enable = true;
    theme.name = "Breeze-Dark";
    iconTheme.name = "Breeze";
  };
}

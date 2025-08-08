# /home/msi-ge75-raider-nixos/follett.nix
# Home Manager configuration for user 'follett' on MSI GE75 Raider 9SF
{ config, pkgs, ... }:
{
  # Import shared dotfiles configuration
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

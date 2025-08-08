# /home/hp-dv9500-pavilion-nixos/follett.nix
# Home Manager configuration for user 'follett' on HP dv9500 Pavilion
{ config, pkgs, ... }:

{
  # Import shared dotfiles configuration
  imports = [ ../../modules/shared/prompt.nix 
    ../../modules/shared/dotfiles.nix
  ];

  # Set the username and home directory for this Home Manager profile
  home.username = "follett";
  home.homeDirectory = "/home/follett";
  home.stateVersion = "25.05";

  # Ensure dconf and tools
  home.packages = with pkgs; [
    dconf
    htop
    fastfetch
  ];

  # Bash config
  programs.bash = {
    enable = true;

    shellAliases = {
      notes = "cd ~/Documents/Notes";
    };

    bashrcExtra = ''
      # Show fastfetch automatically on SSH login (interactive shells only)
      if [[ -n "$SSH_CONNECTION" && $- == *i* ]]; then
          fastfetch
      fi

      # Follett user specific bash configuration
      echo "Welcome, Follett!"
    '';
  };

  # Enable fastfetch via HM module too (keeps it installed)
  programs.fastfetch.enable = true;

  # GTK theming (matches system theming)
  gtk = {
    enable = true;
    theme.name = "Arc-Dark";
    iconTheme.name = "Papirus";
  };
}

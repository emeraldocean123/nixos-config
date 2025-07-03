{ config, pkgs, ... }:

{
  # Home Manager user settings for Joseph
  home.username = "joseph";
  home.homeDirectory = "/home/joseph";
  home.stateVersion = "25.05";

  # Enable and configure common programs
  programs.bash.enable = true;
  programs.git.enable = true;
  programs.htop.enable = true;
  programs.fastfetch.enable = true;

  # GTK theming for user apps
  gtk = {
    enable = true;
    theme.name = "Arc-Dark";
    iconTheme.name = "Papirus";
  };

  # Add more user-level programs and dotfiles here as needed
}

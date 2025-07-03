# home/hp-dv9500-pavilion-nixos/joseph.nix
# Home Manager configuration for user joseph on HP dv9500 Pavilion

{ config, pkgs, ... }:

{
  # Set the username and home directory for this Home Manager profile
  home.username = "joseph";
  home.homeDirectory = "/home/joseph";
  home.stateVersion = "25.05";

  # Enable and configure common CLI programs
  programs.bash.enable = true;
  programs.git.enable = true;
  programs.htop.enable = true;
  programs.fastfetch.enable = true;

  # GTK theming for user applications (matches system theming)
  gtk = {
    enable = true;
    theme.name = "Arc-Dark";
    iconTheme.name = "Papirus";
  };

  # Add more user-level programs and dotfiles here as needed
}

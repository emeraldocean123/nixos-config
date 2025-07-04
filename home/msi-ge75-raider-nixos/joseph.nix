# /etc/nixos/home/msi-ge75-raider-nixos/joseph.nix
# Home Manager configuration for user 'joseph' on MSI GE75 Raider

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

  # KDE Plasma theming for user applications (adjust as desired)
  # You can replace these with your preferred Plasma/GTK themes
  gtk = {
    enable = true;
    theme.name = "Breeze-Dark";
    iconTheme.name = "Breeze";
  };

  # Add more user-level programs and dotfiles here as needed
}

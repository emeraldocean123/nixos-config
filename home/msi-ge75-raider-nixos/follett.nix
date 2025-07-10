# /home/msi-ge75-raider-nixos/follett.nix
# Home Manager configuration for user 'follett' on MSI GE75 Raider 9SF (2018, Intel Core i7-9750H, RTX 2070)
{ config, pkgs, ... }:

{
  # Import shared dotfiles configuration
  imports = [
    ../../modules/shared/dotfiles.nix
  ];

  # Set the username and home directory for this Home Manager profile
  home.username = "follett";
  home.homeDirectory = "/home/follett";
  home.stateVersion = "25.05";

  # Ensure dconf is available for GTK/dconf settings (prevents activation errors)
  home.packages = with pkgs; [
    dconf
    htop
    fastfetch
  ];

  # KDE Plasma theming for user applications (matches system theming)
  gtk = {
    enable = true;
    theme.name = "Breeze-Dark";
    iconTheme.name = "Breeze";
  };

  # Follett-specific configurations
  programs.bash.bashrcExtra = ''
    # Follett user specific bash configuration
    echo "Welcome, Follett!"

    # User-specific aliases
    alias notes="cd ~/Documents/Notes"
  '';
}
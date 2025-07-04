# /etc/nixos/home/hp-dv9500-pavilion-nixos/follett.nix
# Home Manager configuration for user 'follett' on HP dv9500 Pavilion (2007, AMD Turion 64 X2, NVIDIA GeForce 7150M)

{ config, pkgs, ... }:

{
  # Set the username and home directory for this Home Manager profile
  home.username = "follett";
  home.homeDirectory = "/home/follett";
  home.stateVersion = "25.05";

  # Ensure dconf is available for GTK/dconf settings (prevents activation errors)
  home.packages = with pkgs; [
    dconf
  ];

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

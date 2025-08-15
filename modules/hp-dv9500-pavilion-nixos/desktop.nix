# modules/hp-dv9500-pavilion-nixos/desktop.nix
# LXQt desktop environment configuration for HP dv9500 Pavilion
{ config, pkgs, ... }:
{
  # LXQt Desktop Environment
  services.xserver.desktopManager.lxqt.enable = true;
  
  # Disable minimal window managers
  services.xserver.windowManager.icewm.enable = false;

  # Explicitly forbid LXQt from installing the problematic xscreensaver package.
  environment.lxqt.excludePackages = with pkgs; [
    xscreensaver
  ];

  # Essential fonts for the terminal
  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
  ];

  # Set Kitty as the default terminal
  environment.variables.TERMINAL = "kitty";
}

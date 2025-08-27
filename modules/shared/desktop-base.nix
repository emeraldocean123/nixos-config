# modules/shared/desktop-base.nix
# Shared desktop base configuration for all hosts
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Enable X11 windowing system
  services.xserver.enable = true;

  # SDDM display manager configuration
  services.displayManager.sddm.enable = true;

  # X11 keyboard configuration
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Essential fonts for terminals and desktop
  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
  ];

  # Set Kitty as the default terminal
  environment.variables.TERMINAL = "kitty";
}

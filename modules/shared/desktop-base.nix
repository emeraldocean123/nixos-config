# modules/shared/desktop-base.nix
# Shared desktop base configuration for all hosts
{pkgs, ...}: {
  # Consolidate services.* to avoid repeated keys
  services = {
    # Enable X11 windowing system
    xserver = {
      enable = true;
      # X11 keyboard configuration
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # SDDM display manager configuration
    displayManager.sddm.enable = true;
  };

  # Essential fonts for terminals and desktop
  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
  ];

  # Set Kitty as the default terminal
  environment.variables.TERMINAL = "kitty";
}

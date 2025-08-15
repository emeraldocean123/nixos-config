# modules/hp-dv9500-pavilion-nixos/desktop.nix
# LXQt desktop and SDDM configuration for HP dv9500 Pavilion
{ config, pkgs, ... }:
{
  # Final working configuration: SDDM display manager with LXQt desktop.
  services.xserver.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Use SDDM display manager to match MSI laptop configuration
  services.displayManager.sddm.enable = true;

  # Restore the LXQt Desktop Environment
  services.xserver.desktopManager.lxqt.enable = true;
  # And ensure the minimal IceWM is disabled.
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

  # Configure autolock to use the screen-blanking workaround
  services.xserver.xautolock = {
    enable = true;
    # This command forces the monitor into power-saving mode (DPMS off).
    locker = "${pkgs.xorg.xset}/bin/xset dpms force off";
    time = 10;
  };
  # Alternative: if you prefer the screensaver instead of full blanking, try:
  # services.xserver.xautolock.locker = "${pkgs.xorg.xset}/bin/xset s activate";
}

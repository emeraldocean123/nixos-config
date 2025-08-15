# HP dv9500 Pavilion desktop configuration (fonts/terminal are in shared/desktop-base.nix)
{ config, pkgs, ... }:
{
  # LXQt Desktop Environment
  services.xserver.desktopManager.lxqt.enable = true;
  
  # Disable minimal window managers
  services.xserver.windowManager.icewm.enable = false;

  # Explicitly forbid LXQt from installing the problematic xscreensaver package
  environment.lxqt.excludePackages = with pkgs; [
    xscreensaver
  ];
}

# HP dv9500 Pavilion display-specific configuration (base display is in shared/desktop-base.nix)
{ config, pkgs, ... }:
{
  # HP-specific: Configure autolock to use screen-blanking workaround
  # This works well with LXQt (unlike KDE Plasma which has conflicts)
  services.xserver.xautolock = {
    enable = true;
    # This command forces the monitor into power-saving mode (DPMS off).
    locker = "${pkgs.xorg.xset}/bin/xset dpms force off";
    time = 10;
  };
}
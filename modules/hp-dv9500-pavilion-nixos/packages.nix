# HP dv9500 Pavilion specific packages (base packages are in shared/packages-base.nix)
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # LXQt-specific theming packages
    arc-theme
    qgnomeplatform

    # X helpers for LXQt
    xorg.xhost
  ];
}

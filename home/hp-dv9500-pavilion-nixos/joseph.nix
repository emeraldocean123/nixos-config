## home/hp-dv9500-pavilion-nixos/joseph.nix
# Home Manager configuration for user joseph on HP dv9500 Pavilion
{ pkgs, ... }:
{
  imports = [
    ../shared/user-base.nix
  ];

  home.username = "joseph";

  # Add any host-specific or user-specific packages/settings here
  # LXQt power management enabled; GUI controls lid when logged in.
}

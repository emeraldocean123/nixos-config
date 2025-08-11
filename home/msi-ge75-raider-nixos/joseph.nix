## home/msi-ge75-raider-nixos/joseph.nix
# Home Manager configuration for user joseph on MSI GE75 Raider
{ pkgs, ... }:
{
  imports = [
    ../shared/user-base.nix
  ];

  home.username = "joseph";

  # Add any MSI-specific or user-specific packages/settings here
}

# /etc/nixos/hosts/msi-ge75-raider-nixos/configuration.nix
# Host-specific configuration for MSI GE75 Raider 9SF (2018, Intel Core i7-9750H, RTX 2070)

{ config, pkgs, ... }:

{
  system.stateVersion = "25.05";
  imports = [
    ../../modules/msi-ge75-raider-nixos/hardware.nix
    ../../modules/msi-ge75-raider-nixos/desktop.nix
  ];
}

# /modules/hp-dv9500-pavilion-nixos/users.nix
# User account definitions for HP dv9500 Pavilion (2007, AMD Turion 64 X2, NVIDIA GeForce 7150M)
{ config, pkgs, ... }:

{
  # The 'joseph' user is defined in modules/common.nix
  # Only 'follett' needs to be defined here.

  # User account for Follett
  users.users.follett = {
    isNormalUser = true;
    description = "Follett";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
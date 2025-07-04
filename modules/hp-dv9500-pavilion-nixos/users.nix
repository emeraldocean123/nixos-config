# /etc/nixos/modules/hp-dv9500-pavilion-nixos/users.nix
# User account definitions for HP dv9500 Pavilion (2007, AMD Turion 64 X2, NVIDIA GeForce 7150M)

{ config, pkgs, ... }:

{
  # User account for Joseph
  users.users.joseph = {
    isNormalUser = true;
    description = "Joseph";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # User account for Follett
  users.users.follett = {
    isNormalUser = true;
    description = "Follett";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}

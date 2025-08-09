# /etc/nixos/modules/hp-dv9500-pavilion-nixos/users.nix
# Defines host-specific users for the HP Pavilion.
{ config, pkgs, ... }:
{
  # The 'joseph' user is defined in modules/common.nix.
  # This file is for users specific to this machine.
  users.users.follett = {
    isNormalUser = true;
    description = "Follett";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}

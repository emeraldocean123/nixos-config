# /modules/hp-dv9500-pavilion-nixos/users.nix
{ config, pkgs, ... }:
{
  users.users.follett = {
    isNormalUser = true;
    description = "Follett";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.bashInteractive;
  };
}

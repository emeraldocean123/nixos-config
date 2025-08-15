# modules/shared/users.nix
# Shared user definitions for all hosts
{ config, pkgs, ... }:
{
  # Primary user: joseph
  users.groups.joseph = {};
  users.users.joseph = {
    isNormalUser = true;
    description = "Joseph";
    group = "joseph";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.bashInteractive;
  };

  # Secondary user: follett
  users.users.follett = {
    isNormalUser = true;
    description = "Follett";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.bashInteractive;
  };
}
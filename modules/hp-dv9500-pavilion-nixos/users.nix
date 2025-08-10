## modules/hp-dv9500-pavilion-nixos/users.nix
# Host-specific users for the HP Pavilion dv9500
{ config, pkgs, ... }:
{
  # Ensure primary user exists at the system level; Home Manager config layers on top.
  users.groups.joseph = {};
  users.users.joseph = {
    isNormalUser = true;
    description = "Joseph";
    group = "joseph";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.bashInteractive;
  };
  # Define additional host-specific users; 'joseph' is defined via Home Manager
  users.users.follett = {
    isNormalUser = true;
    description = "Follett";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.bashInteractive;
  };
}

## modules/hp-dv9500-pavilion-nixos/users.nix
# Host-specific users for the HP Pavilion dv9500
{ config, pkgs, ... }:
{
  # Define additional host-specific users; 'joseph' is defined via Home Manager
  users.users.follett = {
    isNormalUser = true;
    description = "Follett";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.bashInteractive;
  };
}

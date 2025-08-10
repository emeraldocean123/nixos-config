## modules/msi-ge75-raider-nixos/users.nix
# Host-specific users for the MSI GE75 Raider
{ config, pkgs, ... }:
{
  # Ensure primary users exist at the system level; Home Manager layers user configs.
  users.groups.joseph = {};
  users.users.joseph = {
    isNormalUser = true;
    description = "Joseph";
    group = "joseph";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.bashInteractive;
  };

  users.users.follett = {
    isNormalUser = true;
    description = "Follett";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.bashInteractive;
  };
}

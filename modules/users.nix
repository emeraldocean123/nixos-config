{ config, pkgs, ... }:

{
  # User accounts
  users.users.joseph = {
    isNormalUser = true;
    description = "Joseph";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  users.users.follett = {
    isNormalUser = true;
    description = "Follett";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}

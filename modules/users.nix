{ config, pkgs, ... }:
{
  users.mutableUsers = true;
  users.groups.joseph = {};
  users.users.joseph = {
    isNormalUser = true;
    home = "/home/joseph";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" ];
    group = "joseph";
    shell = pkgs.bash;
    uid = 1000;
  };
  users.groups.follett = {};
  users.users.follett = {
    isNormalUser = true;
    home = "/home/follett";
    extraGroups = [ "wheel" "networkmanager" ];
    group = "follett";
    shell = pkgs.bash;
    uid = 1001;
  };
  security.sudo.wheelNeedsPassword = false;
}

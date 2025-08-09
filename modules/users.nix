{ config, pkgs, ... }:
{
  users.mutableUsers = true;  # Allows manual user changes if needed
  users.groups.joseph = {};
  users.users.joseph = {
    isNormalUser = true;
    home = "/home/joseph";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" ];  # Adjust as needed
    group = "joseph";
    shell = pkgs.bash;
    uid = 1000;
  };
  users.users.follett = {
    isNormalUser = true;
    home = "/home/follett";
    extraGroups = [ "wheel" "networkmanager" ];  # Adjust
    shell = pkgs.bash;
    uid = 1001;
  };
  security.sudo.wheelNeedsPassword = false;  # Optional: sudo without password for wheel group
}

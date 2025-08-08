{ config, pkgs, ... }:
{
  users.users.joseph = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "storage" "input" ];
  };
  users.users.follett = {
    isNormalUser = true;
    description = "Follett";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  # Sudo: standard wheel access (password required)
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;
  # No extraRules for cpupower (keeping it lean)
}

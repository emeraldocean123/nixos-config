{ config, lib, pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  networking.networkmanager.enable = true;
  environment.systemPackages = with pkgs; [
    nixpkgs-fmt
    statix
  ];
}

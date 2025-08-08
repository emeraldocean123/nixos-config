# /modules/common.nix
# Shared configuration for all hosts in the NixOS flake setup
{ config, pkgs, ... }:

{
  # Allow unfree packages (required for proprietary drivers like NVIDIA)
  nixpkgs.config.allowUnfree = true;

  # Enable modern Nix CLI and flakes support for all hosts
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Common system packages available to all users
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];

  # Set timezone and locale for all systems
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # Common user configuration (add or remove users as needed)
  users.users.joseph = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.bashInteractive; # Use Bash as the default shell for joseph
  };

  # Enable NetworkManager service globally (can be overridden per host)
  networking.networkmanager.enable = true;
}{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nixpkgs-fmt
    statix
  ] ++ config.environment.systemPackages;
}

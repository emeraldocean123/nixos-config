# /etc/nixos/modules/common.nix
# Shared configuration for all hosts in the NixOS flake setup
{ config, pkgs, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable modern Nix CLI and flakes support.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set common timezone and locale settings.
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # Define the 'joseph' user, common to both systems.
  users.users.joseph = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.bashInteractive;
  };

  # Enable NetworkManager service globally.
  networking.networkmanager.enable = true;

  # Enable OpenSSH server on all hosts by default.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  # Common system packages available on all hosts.
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];
}

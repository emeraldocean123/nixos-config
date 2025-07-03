# modules/common.nix
# Shared configuration for all hosts in the NixOS flake setup

{ config, pkgs, ... }:

{
  # Enable modern Nix CLI and flakes support for all hosts
  nix.settings.extra-experimental-features = [ "nix-command" "flakes" ];

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

  # No system-wide Zsh support; default shell is Bash
  # programs.zsh.enable = true; # <-- Zsh support removed

  # Common user configuration (add or remove users as needed)
  users.users.joseph = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.bashInteractive; # Use Bash as the default shell for joseph
  };

  # Example: Add more users here or in host-specific modules
  # users.users.follett = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" "networkmanager" ];
  #   shell = pkgs.bashInteractive; # Use Bash as the default shell for follett
  # };

  # Enable NetworkManager service globally (can be overridden per host)
  networking.networkmanager.enable = true;
}

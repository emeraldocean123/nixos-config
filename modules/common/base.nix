# Common base module with core optimizations
{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./nix-settings.nix
    ./boot-optimization.nix
    ./security.nix
    ./system-optimization.nix
  ];

  # Common settings for all hosts
  # Note: time.timeZone is set in common.nix

  # Common packages all systems need
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    htop
    tree
    ripgrep
    fd
    bat
    eza
  ];

  # Enable flakes on all systems
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Better defaults
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    RuntimeMaxUse=100M
  '';

  # Faster DNS
  networking.nameservers = lib.mkDefault ["1.1.1.1" "1.0.0.1"];
}

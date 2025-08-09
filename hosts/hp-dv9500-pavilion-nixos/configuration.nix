# /etc/nixos/hosts/hp-dv9500-pavilion-nixos/configuration.nix
# This file is the entry point for host-specific options that don't belong
# in a more specific module. All module imports are now handled by flake.nix.
{ config, pkgs, ... }:
{
  # This ensures that NixOS knows which version of the configuration you're running.
  system.stateVersion = "25.05";
}

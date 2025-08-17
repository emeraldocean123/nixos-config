# Nix daemon and store optimization settings
{ config, lib, pkgs, ... }:

{
  nix = {
    # Enable flakes and new commands
    settings = {
      experimental-features = [ "nix-command" "flakes" "ca-derivations" ];
      
      # Build optimization
      max-jobs = lib.mkDefault "auto";
      cores = lib.mkDefault 0; # Use all cores
      
      # Binary cache settings
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      
      # Trust settings
      trusted-users = [ "root" "@wheel" ];
      
      # Store optimization
      auto-optimise-store = true;
      
      # Keep build dependencies for debugging
      keep-outputs = true;
      keep-derivations = true;
      
      # Warn about dirty git trees
      warn-dirty = true;
    };
    
    # Extra config
    extraOptions = ''
      # Free up to 5GiB when less than 1GiB left
      min-free = ${toString (1024 * 1024 * 1024)}
      max-free = ${toString (5 * 1024 * 1024 * 1024)}
      
      # Fallback quickly if substituters are slow
      connect-timeout = 5
      
      # Avoid copying unnecessary paths
      builders-use-substitutes = true
    '';
  };
}
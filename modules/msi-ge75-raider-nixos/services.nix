# MSI GE75 Raider host-specific services
# (Most services moved to shared/services-base.nix and roles/)
{ config, pkgs, ... }:

{
  # MSI-specific service overrides (minimal)
  # Most gaming, multimedia, and development services are now in role modules
  
  # Host-specific services only
  # (All common services are in shared/services-base.nix)
  # (All gaming services are in roles/gaming.nix and roles/gaming-performance.nix)  
  # (All multimedia services are in roles/multimedia.nix)
  # (All development services are in roles/development.nix)
}

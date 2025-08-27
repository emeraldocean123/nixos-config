# HP dv9500 Pavilion host-specific services
# (Most services moved to shared/services-base.nix and profiles/laptop-base.nix)
{
  config,
  pkgs,
  ...
}: {
  # HP-specific service overrides (minimal)
  # (SMART monitoring is now in profiles/laptop-base.nix)
  # (All common services are in shared/services-base.nix)
  # (All multimedia services are in roles/multimedia.nix)
}

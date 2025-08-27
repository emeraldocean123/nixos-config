## home/hp-dv9500-pavilion-nixos/follett.nix
# Home Manager configuration for user follett on HP dv9500 Pavilion
{pkgs, ...}: {
  imports = [
    ../shared/user-base.nix
  ];

  home.username = "follett";

  # Add any host-specific or user-specific packages/settings here
  # LXQt power management enabled; GUI controls lid when logged in.
  # No host-specific GTK settings here to keep users identical; set per-host system-wide if needed
}

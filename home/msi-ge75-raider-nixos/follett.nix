## home/msi-ge75-raider-nixos/follett.nix
# Home Manager configuration for user follett on MSI GE75 Raider
{pkgs, ...}: {
  imports = [
    ../shared/user-base.nix
  ];

  home.username = "follett";

  # Add any MSI-specific or user-specific packages/settings here
  # No host-specific GTK settings here to keep users identical; set per-host system-wide if needed
}

# modules/shared/services-base.nix
# Essential services shared across all hosts
_: {
  # Essential system services
  services = {
    # D-Bus for desktop applications
    dbus.enable = true;

    # Printing support
    printing.enable = true;

    # Location services (for automatic time zone, etc.)
    geoclue2.enable = true;

    # USB automounting
    udisks2.enable = true;

    # Firmware updates
    fwupd.enable = true;

    # GNOME services that other DEs can use
    gnome.gnome-keyring.enable = true;
  };

  # Enable nix-ld for dynamic linker compatibility (required for VS Code Remote SSH)
  programs.nix-ld.enable = true;
}

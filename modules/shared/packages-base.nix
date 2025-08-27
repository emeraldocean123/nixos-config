# modules/shared/packages-base.nix
# Core packages shared across all hosts
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Core utilities
    htop
    fastfetch
    lm_sensors

    # Browsers
    brave
    librewolf

    # Terminal
    kitty

    # Basic theming and icons
    nixos-icons
    papirus-icon-theme
  ];
}

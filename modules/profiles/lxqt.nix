# modules/profiles/lxqt.nix
# LXQt desktop environment profile
{
  config,
  pkgs,
  ...
}: {
  # LXQt Desktop Environment
  services.xserver.desktopManager.lxqt.enable = true;

  # Disable conflicting window managers
  services.xserver.windowManager.icewm.enable = false;

  # LXQt-specific packages and theming
  environment.systemPackages = with pkgs; [
    # LXQt-specific theming
    arc-theme
    qgnomeplatform

    # X helpers for LXQt compatibility
    xorg.xhost
  ];

  # Exclude problematic packages
  environment.lxqt.excludePackages = with pkgs; [
    xscreensaver
  ];

  # LXQt works well with xautolock for screen blanking
  services.xserver.xautolock = {
    enable = true;
    locker = "${pkgs.xorg.xset}/bin/xset dpms force off";
    time = 10;
  };

  # Enable network manager applet for LXQt
  programs.nm-applet.enable = true;
}

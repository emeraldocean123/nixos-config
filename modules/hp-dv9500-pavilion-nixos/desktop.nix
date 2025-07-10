# /modules/hp-dv9500-pavilion-nixos/desktop.nix
# LXQt desktop, LightDM greeter, and xscreensaver for HP dv9500 Pavilion (2007, AMD Turion 64 X2, NVIDIA GeForce 7150M)
{ config, pkgs, ... }:

{
  # Enable the X server (required for graphical desktop and LightDM)
  services.xserver.enable = true;

  # Keyboard layout (US)
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # LightDM display manager and greeter settings
  services.xserver.displayManager.lightdm = {
    enable = true;
    background = "/etc/lightdm/background.png";
    greeters.gtk = {
      enable = true;
      theme.name = "Arc-Dark";
      iconTheme.name = "Papirus";
    };
  };

  # Enable the LXQt desktop environment for lightweight performance
  services.xserver.desktopManager.lxqt.enable = true;

  # Declaratively link the NixOS wallpaper for LightDM (robust against upgrades)
  environment.etc."lightdm/background.png".source =
    "${pkgs.nixos-artwork.wallpapers.simple-blue}/share/backgrounds/nixos/nix-wallpaper-simple-blue.png";

  # Enable xscreensaver for LXQt session (locks after 10 minutes)
  services.xserver.xautolock = {
    enable = true;
    locker = "${pkgs.xscreensaver}/bin/xscreensaver-command --lock";
    time = 10; # minutes of inactivity before screensaver activates
  };

  # Ensure xscreensaver is installed for use as a locker
  environment.systemPackages = with pkgs; [
    xscreensaver
  ];
}
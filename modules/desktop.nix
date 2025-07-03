{ config, pkgs, ... }:

{
  # X server and video driver for NVIDIA GeForce 7150M
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nouveau" ];

  # Keyboard layout (US)
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # LightDM display manager and greeter settings
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.background = "/etc/lightdm/background.png";
  services.xserver.displayManager.lightdm.greeters.gtk.enable = true;
  services.xserver.displayManager.lightdm.greeters.gtk.theme.name = "Arc-Dark";
  services.xserver.displayManager.lightdm.greeters.gtk.iconTheme.name = "Papirus";

  # LXQt desktop environment for lightweight performance
  services.xserver.desktopManager.lxqt.enable = true;

  # Declaratively link the NixOS wallpaper for LightDM (robust against upgrades)
  environment.etc."lightdm/background.png".source =
    "${pkgs.nixos-artwork.wallpapers.simple-blue}/share/backgrounds/nixos/nix-wallpaper-simple-blue.png";
}

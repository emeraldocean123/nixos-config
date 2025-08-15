# modules/msi-ge75-raider-nixos/desktop.nix
# KDE Plasma 6 desktop with SDDM for MSI GE75 Raider
{ config, pkgs, ... }:
{
  # Enable X and Plasma 6 with SDDM (default Wayland session is fine; X11 also works)
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure autolock to use the screen-blanking workaround (same as HP laptop)
  services.xserver.xautolock = {
    enable = true;
    # This command forces the monitor into power-saving mode (DPMS off).
    locker = "${pkgs.xorg.xset}/bin/xset dpms force off";
    time = 10;  # 10 minutes, same as HP laptop
  };

  # Start lean: no extra KDE apps yet
  environment.systemPackages = with pkgs; [
    # add editors/tools later after install
  ];
}

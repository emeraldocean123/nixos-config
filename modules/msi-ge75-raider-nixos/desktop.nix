# modules/msi-ge75-raider-nixos/desktop.nix
# KDE Plasma 6 desktop with SDDM for MSI GE75 Raider
{ config, pkgs, ... }:
{
  # Enable X and Plasma 6 with SDDM (default Wayland session is fine; X11 also works)
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Note: xautolock conflicts with KDE Plasma's PowerDevil
  # Plasma has its own power management that overrides xautolock
  # Configure power management through Plasma's System Settings instead
  
  # For SDDM login screen (before user login), set DPMS timeouts
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xset}/bin/xset dpms 600 600 600  # 10 minutes for login screen
  '';
  
  # Configure Plasma's PowerDevil to handle screen timeout when logged in
  # This can be set in System Settings > Power Management > Energy Saving
  # Or via command: kwriteconfig5 --group PowerDevil --group AC --key TurnOffDisplayIdleTimeoutSec 600

  # Start lean: no extra KDE apps yet
  environment.systemPackages = with pkgs; [
    # add editors/tools later after install
  ];
}

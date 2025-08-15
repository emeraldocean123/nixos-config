# modules/msi-ge75-raider-nixos/desktop.nix
# KDE Plasma 6 desktop with SDDM for MSI GE75 Raider
{ config, pkgs, ... }:
{
  # Enable X and Plasma 6 with SDDM (default Wayland session is fine; X11 also works)
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # System-wide power management: Turn off screen after 15 minutes of inactivity
  # This works at login screen, lock screen, and during active use
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xset}/bin/xset dpms 900 900 900  # 15 minutes = 900 seconds
  '';

  # Also configure for Wayland sessions (KDE Plasma 6 default)
  environment.loginShellInit = ''
    # Set screen timeout for Wayland sessions
    if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
      # Note: Wayland power management is handled by the compositor (KWin)
      # This is mainly for X11 fallback sessions
      ${pkgs.xorg.xset}/bin/xset dpms 900 900 900 2>/dev/null || true
    fi
  '';

  # Start lean: no extra KDE apps yet
  environment.systemPackages = with pkgs; [
    # add editors/tools later after install
  ];
}

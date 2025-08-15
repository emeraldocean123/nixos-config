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
  
  # Create a systemd service to manage DPMS at the login screen
  systemd.services.sddm-dpms = {
    description = "Set DPMS timeouts for SDDM";
    after = [ "display-manager.service" ];
    wantedBy = [ "graphical.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c 'sleep 5 && DISPLAY=:0 XAUTHORITY=/var/run/sddm/xauth ${pkgs.xorg.xset}/bin/xset dpms 600 600 600'";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
  
  # Also set DPMS in SDDM's setup commands as a fallback
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xset}/bin/xset dpms 600 600 600  # 10 minutes for login screen
    ${pkgs.xorg.xset}/bin/xset s 600 600  # Also set screensaver timeout
  '';
  
  # Configure Plasma's PowerDevil to handle screen timeout when logged in
  # This can be set in System Settings > Power Management > Energy Saving
  # Or via command: kwriteconfig5 --group PowerDevil --group AC --key TurnOffDisplayIdleTimeoutSec 600

  # Start lean: no extra KDE apps yet
  environment.systemPackages = with pkgs; [
    # add editors/tools later after install
  ];
}

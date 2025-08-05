# /etc/nixos/modules/hp-dv9500-pavilion-nixos/desktop.nix
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

  # Enable LXQt desktop manager (required for session configuration)
  services.xserver.desktopManager.lxqt.enable = true;

  # Fonts configuration for better terminal rendering (e.g., Nerd Fonts for Oh My Posh)
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.meslo-lg # MesloLGS Nerd Font for glyphs and icons
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Meslo LG S Nerd Font" ];
      };
    };
  };

  # Exclude unwanted terminals
  environment.lxqt.excludePackages = with pkgs.lxqt; [
    qterminal # Exclude QTerminal (LXQt's default)
  ];

  services.xserver.excludePackages = [
    pkgs.xterm # Exclude XTerm (system fallback)
  ];

  # Set Kitty as default terminal system-wide
  environment.variables.TERMINAL = "kitty";

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

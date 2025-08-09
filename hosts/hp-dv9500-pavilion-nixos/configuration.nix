{ config, pkgs, ... }:
{
  imports = [
    ../../modules/common.nix
    ../../modules/hp-dv9500-pavilion-nixos/hardware.nix
    ../../modules/hp-dv9500-pavilion-nixos/desktop.nix
    ../../modules/hp-dv9500-pavilion-nixos/networking.nix
    ../../modules/hp-dv9500-pavilion-nixos/packages.nix
    ../../modules/hp-dv9500-pavilion-nixos/services.nix
    # ../../modules/hp-dv9500-pavilion-nixos/users.nix  # Removed - use shared users.nix
    ../../modules/users.nix
    ./hardware-configuration.nix
  ];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  networking.hostName = "hp-dv9500-pavilion-nixos";
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "joseph";
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  system.stateVersion = "25.05";
}

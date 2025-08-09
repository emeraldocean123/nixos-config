{ config, pkgs, ... }:
{
  imports = [
    ../../modules/common.nix
    ../../modules/msi-ge75-raider-nixos/hardware.nix
    ../../modules/msi-ge75-raider-nixos/desktop.nix
    ../../modules/msi-ge75-raider-nixos/nvidia.nix
    ../../modules/msi-ge75-raider-nixos/networking.nix
    ../../modules/msi-ge75-raider-nixos/packages.nix
    ../../modules/msi-ge75-raider-nixos/services.nix
    ../../modules/msi-ge75-raider-nixos/users.nix
    ../../modules/users.nix  # New users module
    ./hardware-configuration.nix
  ];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  networking.hostName = "msi-ge75-raider-nixos";
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

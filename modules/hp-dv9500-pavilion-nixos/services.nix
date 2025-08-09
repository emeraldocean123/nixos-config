# /modules/hp-dv9500-pavilion-nixos/services.nix
# Services configuration for HP dv9500 Pavilion
{ config, pkgs, ... }:
{
  # Audio system (PipeWire for better compatibility)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
  };

  # Enable D-Bus for desktop applications
  services.dbus.enable = true;
  services.printing.enable = true;

  # Note: OpenSSH is now handled in modules/common.nix

  # Power management for legacy laptop
  services.tlp.enable = true;

  # Location services
  services.geoclue2.enable = true;

  # Lid switch behavior
  services.logind.lidSwitch = "ignore";

  # Enable firmware updates
  services.fwupd.enable = true;
}

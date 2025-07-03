# modules/hp-dv9500-pavilion-nixos/services.nix
# Service and hardware configuration for HP dv9500 Pavilion

{ config, pkgs, ... }:

{
  # Enable printing (CUPS) and SSH server
  services.printing.enable = true;
  services.openssh.enable = true;

  # Power management for laptops
  powerManagement.enable = true;

  # Prevent suspend on lid close (useful for older laptops and when docked)
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };

  # PipeWire for modern audio (replaces PulseAudio)
  security.rtkit.enable = true;
  services.pulseaudio.enable = false; # Use PipeWire's PulseAudio replacement
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}

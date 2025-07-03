{ config, pkgs, ... }:

{
  # Printing and SSH services
  services.printing.enable = true;
  services.openssh.enable = true;

  # Power management for laptops
  powerManagement.enable = true;

  # Prevent suspend on lid close (useful for older laptops)
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };

  # PipeWire for modern audio, with real-time permissions
  security.rtkit.enable = true;
  services.pulseaudio.enable = false; # Use PipeWire's PulseAudio replacement
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}

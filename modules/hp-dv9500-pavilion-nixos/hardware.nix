# /etc/nixos/modules/hp-dv9500-pavilion-nixos/hardware.nix
# Hardware-specific configuration for HP dv9500 Pavilion (AMD Turion 64 X2)

{ config, pkgs, ... }:

{
  # Bootloader configuration
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Enable AMD CPU microcode updates (for AMD Turion 64 X2)
  hardware.cpu.amd.updateMicrocode = true;

  # Enable redistributable firmware (recommended for WiFi, etc.)
  hardware.enableRedistributableFirmware = true;

  # Use the open-source nouveau driver for NVIDIA GeForce 7150M GPU
  services.xserver.videoDrivers = [ "nouveau" ];

  # Enable OpenGL/graphics support
  hardware.graphics.enable = true;

  # Enable sound (ALSA/PipeWire)
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # Enable touchpad (libinput, if present)
  services.xserver.libinput.enable = true;

  # Enable TLP for power management (recommended for laptops)
  services.tlp.enable = true;

  # Enable Bluetooth (if present)
  hardware.bluetooth.enable = true;
}

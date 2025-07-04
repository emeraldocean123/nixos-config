# /etc/nixos/modules/msi-ge75-raider-nixos/hardware.nix
# Hardware-specific configuration for MSI GE75 Raider 9SF (2018, Intel Core i7-9750H, RTX 2070)

{ config, pkgs, ... }:

{
  # Enable proprietary NVIDIA driver for RTX 2070
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement.enable = true;
    prime = {
      # Uncomment and set BusID if using Optimus/hybrid graphics
      # intelBusId = "PCI:0:2:0";
      # nvidiaBusId = "PCI:1:0:0";
      # sync.enable = true;
    };
  };
  hardware.opengl.enable = true;

  # Enable firmware and microcode updates
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  # Enable sound (Intel HDA, Realtek, etc.)
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # Power management (TLP recommended for laptops)
  services.tlp.enable = true;

  # Enable Bluetooth (if present)
  hardware.bluetooth.enable = true;

  # Enable touchpad (if present)
  services.xserver.libinput.enable = true;
}

# modules/shared/hardware-base.nix
# Shared hardware configuration for all hosts
{lib, ...}: {
  # Enable redistributable firmware (needed for WiFi, etc.)
  hardware.enableRedistributableFirmware = true;

  # Graphics support (common for all hosts)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable touchpad and input devices (common touchpad settings)
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      disableWhileTyping = true;
      # naturalScrolling and other options can be overridden per-host
    };
  };

  # Enable Bluetooth (power settings can be overridden per-host)
  hardware.bluetooth = {
    enable = true;
    # powerOnBoot default to true, hosts can override
    powerOnBoot = lib.mkDefault true;
  };
}

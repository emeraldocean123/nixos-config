# modules/shared/hardware-base.nix
# Shared hardware configuration for all hosts
{lib, ...}: {
  # Consolidate hardware.* to avoid repeated keys
  hardware = {
    # Enable redistributable firmware (needed for WiFi, etc.)
    enableRedistributableFirmware = true;

    # Graphics support (common for all hosts)
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Enable Bluetooth (power settings can be overridden per-host)
    bluetooth = {
      enable = true;
      # powerOnBoot default to true, hosts can override
      powerOnBoot = lib.mkDefault true;
    };
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

  # Bluetooth consolidated under hardware above
}

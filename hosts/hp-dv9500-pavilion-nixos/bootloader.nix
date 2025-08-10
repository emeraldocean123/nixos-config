{ config, ... }:
{
  # Legacy BIOS default; adjust to EFI on this host if applicable.
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "/dev/sda" ];
}

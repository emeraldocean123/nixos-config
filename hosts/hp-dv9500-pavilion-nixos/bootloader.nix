## hosts/hp-dv9500-pavilion-nixos/bootloader.nix
# BIOS GRUB bootloader for HP dv9500 (legacy BIOS).
{ config, lib, pkgs, ... }:
{
  # Enable GRUB for legacy BIOS systems. Adjust device if the root disk is different.
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "/dev/sda" ];
}
{ config, ... }:
{
  # Legacy BIOS default; adjust to EFI on this host if applicable.
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "/dev/sda" ];
}

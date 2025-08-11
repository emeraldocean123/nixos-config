## hosts/hp-dv9500-pavilion-nixos/bootloader.nix
# BIOS GRUB bootloader for HP dv9500 (legacy BIOS) - emergency clean configuration
{ config, lib, pkgs, ... }:
{
  # Enable GRUB for legacy BIOS systems - basic configuration only
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "/dev/sda" ];
  
  # Standard timeout
  boot.loader.timeout = 5;
}

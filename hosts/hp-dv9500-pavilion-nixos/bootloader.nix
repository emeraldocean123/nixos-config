## hosts/hp-dv9500-pavilion-nixos/bootloader.nix
# BIOS GRUB bootloader for HP dv9500 (legacy BIOS) with dual boot support.
{ config, lib, pkgs, ... }:
{
  # Enable GRUB for legacy BIOS systems
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "/dev/sda" ];
  
  # Temporarily disable OS detection to fix NixOS boot issue
  # boot.loader.grub.useOSProber = true;
  
  # Temporarily disable custom entries to fix NixOS boot
  # boot.loader.grub.extraEntries = ''
# menuentry "CachyOS Linux" {
#   insmod part_msdos
#   set root='(hd1)'
#   chainloader +1
# }
#   '';
  
  # Increase timeout for boot menu selection
  boot.loader.timeout = 10;
}

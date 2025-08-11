## hosts/hp-dv9500-pavilion-nixos/bootloader.nix
# BIOS GRUB bootloader for HP dv9500 (legacy BIOS) with CachyOS dual boot
{ config, lib, pkgs, ... }:
{
  # Enable GRUB for legacy BIOS systems
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "/dev/sda" ];
  
  # Extended timeout for dual boot selection
  boot.loader.timeout = 10;
  
  # Alternative approach - force GRUB to detect other systems
  boot.loader.grub.useOSProber = true;
  
  # Manual CachyOS entry as fallback
  boot.loader.grub.extraEntries = ''
menuentry "CachyOS (Manual)" {
  set root=(hd1)
  chainloader +1
}
  '';
}

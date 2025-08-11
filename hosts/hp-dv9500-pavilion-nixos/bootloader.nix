## hosts/hp-dv9500-pavilion-nixos/bootloader.nix
# BIOS GRUB bootloader for HP dv9500 (legacy BIOS) with dual boot support.
{ config, lib, pkgs, ... }:
{
  # Enable GRUB for legacy BIOS systems
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "/dev/sda" ];
  
  # Enable OS detection for dual boot
  boot.loader.grub.useOSProber = true;
  
  # Custom GRUB menu entries for CachyOS (Limine chainload)
  boot.loader.grub.extraEntries = ''
    # CachyOS via Limine chainloader
    menuentry "CachyOS Linux" {
      insmod part_msdos
      insmod ext2
      set root='(hd1,msdos1)'
      chainloader +1
    }
  '';
  
  # Increase timeout for boot menu selection
  boot.loader.timeout = 10;
}

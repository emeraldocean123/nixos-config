## hosts/hp-dv9500-pavilion-nixos/hardware-configuration.nix
# Hardware configuration for HP dv9500 Pavilion (AMD Turion 64 X2 + Nvidia GeForce 7150M)
# IMPORTANT: This is a template. Run `sudo nixos-generate-config` on the actual machine
# to generate machine-specific UUIDs and device paths, then commit the result.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Kernel modules for HP dv9500 Pavilion hardware
  boot.initrd.availableKernelModules = [
    "ahci"           # SATA controller
    "pata_atiixp"    # AMD PATA controller  
    "usb_storage"    # USB storage devices
    "sd_mod"         # SCSI disk support
    "sr_mod"         # SCSI CD-ROM support
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];  # AMD virtualization
  boot.extraModulePackages = [ ];

  # WARNING: These are PLACEHOLDER UUIDs and device paths!
  # They MUST be replaced with actual values from `nixos-generate-config`
  # Generated UUIDs and device paths will look different on each machine
  
  fileSystems."/" = {
    # PLACEHOLDER - replace with actual UUID from nixos-generate-config
    device = "/dev/disk/by-uuid/REPLACE-WITH-ACTUAL-ROOT-UUID";
    fsType = "ext4";
    options = [ "relatime" "errors=remount-ro" ];  # Stability for older hardware
  };

  fileSystems."/boot" = {
    # PLACEHOLDER - replace with actual UUID from nixos-generate-config
    device = "/dev/disk/by-uuid/REPLACE-WITH-ACTUAL-BOOT-UUID";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [
    # PLACEHOLDER - replace with actual swap UUID if using swap partition
    # { device = "/dev/disk/by-uuid/REPLACE-WITH-ACTUAL-SWAP-UUID"; }
  ];

  # Enable DHCP on ethernet and wireless interfaces
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  
  # Enable AMD CPU microcode updates
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

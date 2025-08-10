{ config, pkgs, ... }:
{
  # Enable SMART monitoring for disks
  services.smartd.enable = true;
}

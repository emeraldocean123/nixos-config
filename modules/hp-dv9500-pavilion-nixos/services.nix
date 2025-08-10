{ config, pkgs, ... }:
{
  # Enable SMART monitoring for disks
  services.smartd.enable = true;

  # Optional: Improve battery life with TLP (conservative defaults)
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #     DISK_APM_LEVEL_ON_BAT = "128";
  #     # If present, target spinning disks only (adjust to your device)
  #     DISK_DEVICES = "sda";
  #   };
  # };
}

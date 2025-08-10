{ config, pkgs, ... }:
{
  # Enable SMART monitoring for disks
  services.smartd.enable = true;

  # Ensure closing the lid never suspends/sleeps on this laptop
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };
}

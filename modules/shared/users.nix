# modules/shared/users.nix
# Shared user definitions for all hosts
{
  config,
  pkgs,
  ...
}: {
  # Primary user: joseph
  users.groups.joseph = {};
  users.users.joseph = {
    isNormalUser = true;
    description = "Joseph";
    group = "joseph";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker" # For development containers
      "audio" # For audio devices
      "video" # For video devices and GPU access
      "input" # For input device access
    ];
    shell = pkgs.bashInteractive;
  };

  # Secondary user: follett
  users.users.follett = {
    isNormalUser = true;
    description = "Follett";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio" # For audio devices
      "video" # For video devices
    ];
    shell = pkgs.bashInteractive;
  };
}

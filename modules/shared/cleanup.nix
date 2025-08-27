## modules/shared/cleanup.nix
# User-level systemd timer to run cleanup-dotfiles.sh daily (dry-run)
{
  pkgs,
  dotfiles,
  ...
}: let
  inherit (pkgs) bash;
  # Path to the cleanup script from the dotfiles flake input
  cleanupScript = dotfiles.outPath + "/cleanup-dotfiles.sh";
  # Build the command: scan common targets, dry-run by default
  cmd = "${bash}/bin/bash -lc '${cleanupScript} --targets /etc/nixos \"$HOME/dotfiles\" \"$HOME/Documents/dev/dotfiles\"'";
in {
  # Start/stop user services using systemd's sd-switch method during activation
  systemd.user.startServices = "sd-switch";

  # Ensure systemd user is enabled by HM
  systemd.user.services."dotfiles-cleanup" = {
    Unit = {
      Description = "Dotfiles cleanup dry-run";
      Documentation = ["https://github.com/emeraldocean123/dotfiles"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = cmd;
      # Be quiet on failures; script is defensive and returns 0 on dry-run
      SuccessExitStatus = ["0"];
    };
  };

  systemd.user.timers."dotfiles-cleanup" = {
    Unit = {Description = "Daily dotfiles cleanup dry-run";};
    Timer = {
      OnCalendar = "daily"; # runs at 00:00 local; randomize to spread load
      RandomizedDelaySec = "30m";
      Persistent = true; # run missed timers after downtime
    };
    Install = {WantedBy = ["timers.target"];};
  };
}

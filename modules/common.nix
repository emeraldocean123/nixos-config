## modules/common.nix
# Common, host-agnostic settings shared by all machines
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkForce elem mkAfter types mkOption mkIf;
  cfg = config.custom.lid.greeterInhibit;
  # Detect if any common display manager is enabled. Use `or false` to avoid referencing missing attrs.
  dmEnabled =
    # SDDM moved to services.displayManager.sddm in 25.05
    (config.services.displayManager.sddm.enable or false)
    # LightDM/GDM are still under services.xserver.displayManager.* on 25.05
    || (config.services.xserver.displayManager.lightdm.enable or false)
    || (config.services.xserver.displayManager.gdm.enable or false)
    # Future-proof: also consider new locations if present
    || (config.services.displayManager.gdm.enable or false)
    || (config.services.displayManager.lightdm.enable or false);
in {
  # Module options
  options.custom.lid.greeterInhibit.enable = mkOption {
    type = types.bool;
    default = true;
    description = ''
      When true (default), run a small systemd service alongside the display manager
      to ignore the lid switch only at the greeter. Once a non-greeter session exists,
      the inhibitor is released so the desktop environment fully controls lid behavior.
      Set to false if your display manager handles this natively in the future.
    '';
  };

  # All configuration goes under the `config` attribute when defining module options.
  config = {
    # Locale and timezone
    time.timeZone = "America/Los_Angeles";
    i18n.defaultLocale = "en_US.UTF-8";

    # Networking consolidated to avoid repeated keys
    networking = {
      # Hard-require NetworkManager. If any other module tries to disable it, we force it on.
      networkmanager.enable = mkForce true;
      # Forbid legacy wireless while using NetworkManager.
      wireless.enable = mkForce false;
      # Basic firewall; we don't force the whole list to avoid clobbering host-specific ports.
      # Instead, assert that SSH is reachable when enabled.
      firewall.enable = true;
    };
    # Disable systemd-networkd when using NetworkManager
    systemd.network.enable = mkForce false;

    # Ensure SSH is available for remote management and force it on.
    # SSH security settings are handled by security.nix module to avoid conflicts
    services.openssh = {
      enable = mkForce true;
      openFirewall = true;
      # Listen on all addresses by default (no specific binding needed)
      # SSH will automatically listen on both IPv4 and IPv6
    };

    # Enable modern Nix features system-wide so remote flake commands work without extra flags
    nix.settings.experimental-features = ["nix-command" "flakes"];

    # Make sure nmcli is available on the CLI and provide a tiny update helper
    environment.systemPackages = with pkgs; [
      fastfetch
      htop
      git
      curl
      wget
      gnused
      gnugrep
      networkmanager # provides nmcli
      (writeShellScriptBin "nixos-up" ''
        set -euo pipefail
        # Pull the system config and switch to it
        sudo /run/current-system/sw/bin/git -C /etc/nixos pull --ff-only
        sudo /run/current-system/sw/bin/nixos-rebuild switch
      '')
      (writeShellScriptBin "nixos-up-clean" ''
        set -euo pipefail
        # Reset any local changes, clean untracked, then pull and switch
        sudo /run/current-system/sw/bin/git -C /etc/nixos reset --hard HEAD
        sudo /run/current-system/sw/bin/git -C /etc/nixos clean -fd
        sudo /run/current-system/sw/bin/git -C /etc/nixos pull --ff-only
        sudo /run/current-system/sw/bin/nixos-rebuild switch
      '')
      # Helper to check lid-related state at a glance
      (writeShellScriptBin "lid-status" ''
        echo "== Sessions (loginctl) =="
        loginctl --no-legend list-sessions || true
        echo ""
        echo "== Inhibitors (systemd-inhibit --list) =="
        systemd-inhibit --list || true
        echo ""
        echo "== Greeter inhibitor service status =="
        systemctl status lid-inhibit-at-greeter.service --no-pager -l || true
        echo ""
        echo "== logind.conf (lid-related keys) =="
        test -f /etc/systemd/logind.conf && grep -E "HandleLid|LidSwitch" /etc/systemd/logind.conf || echo "(no lid settings found)"
      '')
    ];

    # Consolidate systemd services configuration to avoid repeated keys
    systemd.services = {
      # Wait for networking to be online when requested and make sshd start after network-online
      "NetworkManager-wait-online".enable = true;
      sshd.wants = ["network-online.target"];
      sshd.after = ["network-online.target"];

      # Proactively unblock any soft-rfkill at boot (Wi‑Fi toggles, etc.)
      rfkill-unblock = {
        description = "Unblock all rfkill switches at boot";
        wantedBy = ["multi-user.target"];
        before = ["NetworkManager.service"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.bash}/bin/bash -lc 'command -v rfkill >/dev/null 2>&1 && rfkill unblock all || true'";
        };
      };

      # Inhibit lid handling only at the greeter (LightDM/SDDM). When a real user session exists,
      # release the inhibitor so the GUI (LXQt/Plasma) can control lid behavior.
      "lid-inhibit-at-greeter" = mkIf cfg.enable (let
        mainScript = pkgs.writeShellScript "lid-inhibit-at-greeter" ''
          # Ensure required tools are on PATH even in minimal systemd environments
          export PATH="${pkgs.coreutils}/bin:${pkgs.gawk}/bin:${pkgs.systemd}/bin:/run/current-system/sw/bin:$PATH"
          pidfile=/run/lid-greeter-inhibit/pid
          	last_count=-1
          	last_log_ts=0
          cleanup() {
            if [ -f "$pidfile" ]; then
              if kill -0 "$(cat "$pidfile")" 2>/dev/null; then
                kill "$(cat "$pidfile")" 2>/dev/null || true
              fi
              rm -f "$pidfile"
            fi
          }
          trap cleanup EXIT
          while true; do
            sessions="$(${pkgs.systemd}/bin/loginctl --no-legend list-sessions 2>/dev/null || true)"
            if [ -z "$sessions" ]; then
              count=0
            else
              count=$(echo "$sessions" | ${pkgs.gawk}/bin/awk 'BEGIN{c=0} { if ($3 !~ /^(sddm|lightdm|gdm|greeter)$/) c++ } END{ print c }')
            fi
          	  now=$(${pkgs.coreutils}/bin/date +%s)
          	  if [ "$count" -ne "$last_count" ] || [ $((now - last_log_ts)) -ge 300 ]; then
          	    echo "[lid-inhibit] non-greeter sessions: $count" >&2
          	    last_count=$count
          	    last_log_ts=$now
          	  fi
            if [ "$count" -eq 0 ]; then
              if [ ! -f "$pidfile" ] || ! kill -0 "$(cat "$pidfile")" 2>/dev/null; then
                ${pkgs.systemd}/bin/systemd-inhibit --what=handle-lid-switch --mode=block --why='Ignore lid at greeter' ${pkgs.coreutils}/bin/tail -f /dev/null &
                echo $! > "$pidfile"
              fi
              ${pkgs.coreutils}/bin/sleep 5
            else
              if [ -f "$pidfile" ]; then
                if kill -0 "$(cat "$pidfile")" 2>/dev/null; then
                  kill "$(cat "$pidfile")" 2>/dev/null || true
                fi
                rm -f "$pidfile"
              fi
              ${pkgs.coreutils}/bin/sleep 10
            fi
          done
        '';
        cleanupScript = pkgs.writeShellScript "lid-inhibit-at-greeter-cleanup" ''
          set -euo pipefail
          pidfile=/run/lid-greeter-inhibit/pid
          if [ -f "$pidfile" ]; then
            if kill -0 "$(cat "$pidfile")" 2>/dev/null; then
              kill "$(cat "$pidfile")" 2>/dev/null || true
            fi
            rm -f "$pidfile"
          fi
        '';
      in {
        description = "Ignore lid switch at display manager greeter";
        partOf = ["display-manager.service"];
        wants = ["display-manager.service"];
        after = ["display-manager.service"];
        unitConfig = {
          ConditionPathExistsGlob = "/proc/acpi/button/lid/*/state";
        };
        serviceConfig = {
          Type = "simple";
          RuntimeDirectory = "lid-greeter-inhibit";
          ExecStart = mainScript;
          ExecStopPost = cleanupScript;
          Restart = "always";
          RestartSec = "5s";
        };
        wantedBy = ["display-manager.service"];
      });
    };

    # Sudo quality-of-life: allow joseph/follett to update /etc/nixos and rebuild without a password,
    # and keep sudo tokens warm a bit longer to reduce re-prompts. Scope is tightly limited.
    security.sudo = {
      # Extend how long the sudo timestamp stays valid (minutes)
      extraConfig = ''
        Defaults:joseph timestamp_timeout=30
        Defaults:follett timestamp_timeout=30
      '';
      # Restrict NOPASSWD to exact commands only
      extraRules = [
        {
          users = ["joseph" "follett"];
          commands = [
            # Only allow git pulling the system repo at /etc/nixos as root, no other git actions
            {
              command = "/run/current-system/sw/bin/git -C /etc/nixos pull";
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/git -C /etc/nixos pull --ff-only";
              options = ["NOPASSWD"];
            }
            # Allow safe tree cleanup operations in /etc/nixos
            {
              command = "/run/current-system/sw/bin/git -C /etc/nixos reset --hard HEAD";
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/git -C /etc/nixos clean -fd";
              options = ["NOPASSWD"];
            }
            # Common nixos-rebuild invocations
            {
              command = "/run/current-system/sw/bin/nixos-rebuild switch";
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/nixos-rebuild test";
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/nixos-rebuild build";
              options = ["NOPASSWD"];
            }
          ];
        }
      ];
    };

    # Ensure user lingering so user systemd timers continue when logged out
    system.activationScripts.enableLinger = {
      text = ''
        /run/current-system/sw/bin/loginctl enable-linger joseph || true
        /run/current-system/sw/bin/loginctl enable-linger follett || true
      '';
    };

    # nixos-up helper included above in environment.systemPackages

    # Sanity checks to prevent foot-guns during rebuilds.
    assertions = [
      {
        assertion = config.networking.networkmanager.enable;
        message = "NetworkManager must be enabled (guarding against accidental Wi‑Fi loss on rebuild).";
      }
      {
        assertion = !(config.networking.wireless.enable or false);
        message = "Do not enable networking.wireless.* alongside NetworkManager; it conflicts and can break Wi‑Fi.";
      }
      {
        assertion = !(config.systemd.network.enable or false);
        message = "Do not enable systemd-networkd with NetworkManager; choose one network stack (we use NetworkManager).";
      }
      {
        # Only require a display manager when the greeter lid inhibitor is enabled
        assertion = (!cfg.enable) || dmEnabled;
        message = "custom.lid.greeterInhibit requires a display manager (e.g., SDDM/GDM/LightDM).";
      }
      # No explicit TCP 22 assertion needed; services.openssh.openFirewall handles it.
    ];
  };
}

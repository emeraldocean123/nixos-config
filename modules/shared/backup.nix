# modules/shared/backup.nix
# Backup and recovery configurations for NixOS system
{
  config,
  pkgs,
  ...
}: {
  # Backup essential system configurations and recovery scripts
  environment.systemPackages = with pkgs; [
    rsync
    gzip
    bzip2
    gnutar
    git

    # Recovery script helpers
    (writeShellScriptBin "nixos-config-restore" ''
      set -euo pipefail

      BACKUP_DIR="/var/backups/nixos"

      if [ $# -eq 0 ]; then
        echo "Usage: nixos-config-restore [backup-file|latest]"
        echo "Available backups:"
        ls -la "$BACKUP_DIR/config/"
        exit 1
      fi

      if [ "$1" = "latest" ]; then
        BACKUP_FILE=$(ls -t "$BACKUP_DIR/config/nixos-config-"*.tar.gz | head -n1)
      else
        BACKUP_FILE="$1"
      fi

      if [ ! -f "$BACKUP_FILE" ]; then
        echo "Error: Backup file not found: $BACKUP_FILE"
        exit 1
      fi

      echo "WARNING: This will overwrite current /etc/nixos configuration!"
      echo "Backup file: $BACKUP_FILE"
      read -p "Continue? (y/N): " -n 1 -r
      echo

      if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Create a backup of current config before restoring
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        if [ -d "/etc/nixos" ]; then
          tar -czf "/var/backups/nixos/config/nixos-pre-restore-$TIMESTAMP.tar.gz" -C /etc/nixos .
          echo "Current configuration backed up to nixos-pre-restore-$TIMESTAMP.tar.gz"
        fi

        # Restore configuration
        cd /etc/nixos
        tar -xzf "$BACKUP_FILE"
        echo "Configuration restored from $BACKUP_FILE"
        echo "Run 'sudo nixos-rebuild switch' to apply the restored configuration"
      else
        echo "Restore cancelled"
      fi
    '')

    (writeShellScriptBin "nixos-backup-status" ''
      set -euo pipefail

      BACKUP_DIR="/var/backups/nixos"

      echo "=== NixOS Backup Status ==="
      echo

      echo "Last 5 configuration backups:"
      ls -lat "$BACKUP_DIR/config/" | head -6
      echo

      echo "Last 3 generation snapshots:"
      ls -lat "$BACKUP_DIR/generations/" | head -4
      echo

      echo "Hardware configurations:"
      ls -la "$BACKUP_DIR/hardware/" 2>/dev/null || echo "No hardware backups found"
      echo

      echo "Disk usage:"
      du -sh "$BACKUP_DIR"
      echo

      echo "Next scheduled backup:"
      systemctl list-timers backup-nixos-config.timer
    '')
  ];

  # Create backup directory structure
  system.activationScripts.createBackupDirs = {
    text = ''
      mkdir -p /var/backups/nixos
      mkdir -p /var/backups/nixos/config
      mkdir -p /var/backups/nixos/generations
      mkdir -p /var/backups/nixos/hardware
      chown root:root /var/backups/nixos
      chmod 755 /var/backups/nixos
    '';
  };

  # Consolidate systemd services/timers to avoid repeated keys
  systemd = {
    services = {
      # Systemd service for automated configuration backup
      backup-nixos-config = {
        description = "Backup NixOS configuration";
        path = with pkgs; [git rsync gzip gnutar coreutils nixos-rebuild];

        serviceConfig = {
          Type = "oneshot";
          User = "root";
          WorkingDirectory = "/etc/nixos";
        };

        script = ''
          set -euo pipefail

          BACKUP_DIR="/var/backups/nixos"
          TIMESTAMP=$(date +%Y%m%d_%H%M%S)
          CONFIG_BACKUP="$BACKUP_DIR/config/nixos-config-$TIMESTAMP.tar.gz"

          echo "Starting NixOS configuration backup at $TIMESTAMP"

          # Backup current configuration
          if [ -d "/etc/nixos" ]; then
            cd /etc/nixos

            # Create git bundle if we're in a git repository
            if [ -d ".git" ]; then
              git bundle create "$BACKUP_DIR/config/nixos-git-$TIMESTAMP.bundle" --all
              echo "Git repository backed up to $BACKUP_DIR/config/nixos-git-$TIMESTAMP.bundle"
            fi

            # Create compressed archive of all configuration files
            tar -czf "$CONFIG_BACKUP" \
              --exclude='.git' \
              --exclude='*.log' \
              --exclude='*.tmp' \
              --exclude='result*' \
              .

            echo "Configuration archived to $CONFIG_BACKUP"

            # Also backup hardware configuration separately for easy access
            if ls hosts/*/hardware-configuration.nix >/dev/null 2>&1; then
              cp hosts/*/hardware-configuration.nix "$BACKUP_DIR/hardware/" || true
            fi
          fi

          # Backup current system generation info
          nixos-rebuild list-generations > "$BACKUP_DIR/generations/generations-$TIMESTAMP.txt" || true

          # Keep only last 10 backups to prevent disk usage growth
          cd "$BACKUP_DIR/config"
          ls -t nixos-config-*.tar.gz 2>/dev/null | tail -n +11 | xargs -r rm -f
          ls -t nixos-git-*.bundle 2>/dev/null | tail -n +11 | xargs -r rm -f

          cd "$BACKUP_DIR/generations"
          ls -t generations-*.txt 2>/dev/null | tail -n +11 | xargs -r rm -f

          echo "Backup completed successfully"
        '';

        wantedBy = ["multi-user.target"];
      };
    };

    timers = {
      # Timer for regular automated backups
      backup-nixos-config = {
        description = "Regular NixOS configuration backup";
        wantedBy = ["timers.target"];

        timerConfig = {
          # Run daily at 3 AM
          OnCalendar = "daily";
          RandomizedDelaySec = "30m";
          Persistent = true;
        };
      };
    };
  };

  # Git configuration for system-level operations
  programs.git = {
    enable = true;
    config = {
      # Safe directory configuration for system backups
      safe.directory = ["/etc/nixos"];
    };
  };

  # backup-nixos-config wantedBy moved into consolidated systemd.services above
}

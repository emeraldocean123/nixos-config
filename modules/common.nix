## modules/common.nix
# Common, host-agnostic settings shared by all machines
{ config, lib, pkgs, ... }:
let
	inherit (lib) mkForce elem mkAfter;
in
{
	# Locale and timezone
	time.timeZone = "America/Chicago";
	i18n.defaultLocale = "en_US.UTF-8";

	# Hard-require NetworkManager. If any other module tries to disable it, we force it on.
	networking.networkmanager.enable = mkForce true;
		# Forbid legacy wireless and systemd-networkd while using NetworkManager.
		networking.wireless.enable = mkForce false;
		systemd.network.enable = mkForce false;

	# Basic firewall; we don't force the whole list to avoid clobbering host-specific ports.
	# Instead, assert that SSH is reachable when enabled.
	networking.firewall.enable = true;

	# Ensure SSH is available for remote management and force it on.
	services.openssh = {
		enable = mkForce true;
		openFirewall = true;
		settings = {
			PermitRootLogin = "no";
			PasswordAuthentication = true;
		};
	};

		# Make sure nmcli is available on the CLI
	environment.systemPackages = with pkgs; [
		fastfetch
		htop
		git
		curl
		wget
		networkmanager # provides nmcli
	];

	# Wait for networking to be online when requested and make sshd start after network-online
	systemd.services."NetworkManager-wait-online".enable = true;
	systemd.services.sshd.wants = [ "network-online.target" ];
	systemd.services.sshd.after = [ "network-online.target" ];

	# Proactively unblock any soft-rfkill at boot (Wi‑Fi toggles, etc.)
	systemd.services.rfkill-unblock = {
		description = "Unblock all rfkill switches at boot";
		wantedBy = [ "multi-user.target" ];
		before = [ "NetworkManager.service" ];
		serviceConfig = {
			Type = "oneshot";
		ExecStart = "${pkgs.bash}/bin/bash -lc 'command -v rfkill >/dev/null 2>&1 && rfkill unblock all || true'";
		};
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
				users = [ "joseph" "follett" ];
				commands = [
					# Only allow git pulling the system repo at /etc/nixos as root, no other git actions
					{ command = "/run/current-system/sw/bin/git -C /etc/nixos pull"; options = [ "NOPASSWD" ]; }
					# Common nixos-rebuild invocations
					{ command = "/run/current-system/sw/bin/nixos-rebuild switch"; options = [ "NOPASSWD" ]; }
					{ command = "/run/current-system/sw/bin/nixos-rebuild test"; options = [ "NOPASSWD" ]; }
					{ command = "/run/current-system/sw/bin/nixos-rebuild build"; options = [ "NOPASSWD" ]; }
				];
			}
		];
	};

	# Small helper to update and switch in one go; uses the above sudo rules.
	environment.systemPackages = mkAfter [
		(pkgs.writeShellScriptBin "nixos-up" ''
			set -euo pipefail
			# Pull the system config and switch to it
			sudo /run/current-system/sw/bin/git -C /etc/nixos pull --ff-only
			sudo /run/current-system/sw/bin/nixos-rebuild switch
		'')
	];

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
			# No explicit TCP 22 assertion needed; services.openssh.openFirewall handles it.
	];
}


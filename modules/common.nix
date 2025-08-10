## modules/common.nix
# Common, host-agnostic settings shared by all machines
{ config, lib, pkgs, ... }:
let
	inherit (lib) mkForce elem;
in
{
	# Locale and timezone
	time.timeZone = "America/Chicago";
	i18n.defaultLocale = "en_US.UTF-8";

	# Hard-require NetworkManager. If any other module tries to disable it, we force it on.
	networking.networkmanager.enable = mkForce true;

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

	# Make sure nmcli and rfkill are available on the CLI
	environment.systemPackages = with pkgs; [
		fastfetch
		htop
		git
		curl
		wget
		networkmanager # provides nmcli
		rfkill
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
			ExecStart = "${pkgs.rfkill}/bin/rfkill unblock all";
		};
	};

	# Sanity checks to prevent foot-guns during rebuilds.
	assertions = [
		{
			assertion = config.networking.networkmanager.enable;
			message = "NetworkManager must be enabled (guarding against accidental Wi‑Fi loss on rebuild).";
		}
		{
			assertion = !(config.networking ? wireless && config.networking.wireless.enable or false);
			message = "Do not enable networking.wireless.* alongside NetworkManager; it conflicts and can break Wi‑Fi.";
		}
		{
			assertion = !(config.systemd ? network and config.systemd.network.enable or false);
			message = "Do not enable systemd-networkd with NetworkManager; choose one network stack (we use NetworkManager).";
		}
		# No explicit TCP 22 assertion needed; services.openssh.openFirewall handles it.
	];
}


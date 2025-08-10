## modules/common.nix
# Common, host-agnostic settings shared by all machines
{ config, lib, pkgs, ... }:
{
	# Locale and timezone
	time.timeZone = "America/Chicago";
	i18n.defaultLocale = "en_US.UTF-8";

	# Networking: enable NetworkManager globally
	networking.networkmanager.enable = true;

	# Basic firewall with SSH allowed
	networking.firewall = {
		enable = true;
		allowedTCPPorts = [ 22 ];
	};

	# Ensure SSH is available for remote management
	services.openssh = {
		enable = true;
		settings = {
			PermitRootLogin = "no";
			PasswordAuthentication = true;
		};
	};

	# Convenience packages common to all systems
	environment.systemPackages = with pkgs; [
		fastfetch
		htop
		git
		curl
		wget
	];
}


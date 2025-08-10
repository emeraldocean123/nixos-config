## hosts/hp-dv9500-pavilion-nixos/hardware-configuration.nix
# Placeholder. On the HP host, generate via `nixos-generate-config` and commit.
{ config, lib, pkgs, modulesPath, ... }:
{
	# Placeholder root filesystem to satisfy evaluation until real hardware-configuration is generated on the host.
	fileSystems."/" = {
		device = "/dev/sda1";
		fsType = "ext4";
	};
}

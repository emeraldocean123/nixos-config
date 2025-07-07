# /etc/nixos/flake.nix
# NixOS and Home Manager configuration for multiple hosts and users using Nix flakes

{
  description = "NixOS and Home Manager configuration for multiple hosts and users";

  inputs = {
    # NixOS stable channel
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Home Manager for user-level configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add other inputs here as needed
    # e.g., nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        # HP dv9500 Pavilion host
        hp-dv9500-pavilion-nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # Shared configuration
            ./modules/common.nix

            # Host-specific modules
            ./modules/hp-dv9500-pavilion-nixos/hardware.nix
            ./modules/hp-dv9500-pavilion-nixos/desktop.nix
            ./modules/hp-dv9500-pavilion-nixos/networking.nix
            ./modules/hp-dv9500-pavilion-nixos/packages.nix
            ./modules/hp-dv9500-pavilion-nixos/services.nix
            ./modules/hp-dv9500-pavilion-nixos/users.nix

            # Standard NixOS host files
            ./hosts/hp-dv9500-pavilion-nixos/configuration.nix
            ./hosts/hp-dv9500-pavilion-nixos/hardware-configuration.nix

            # Home Manager integration for users
            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.users.joseph = import ./home/hp-dv9500-pavilion-nixos/joseph.nix;
              home-manager.users.follett = import ./home/hp-dv9500-pavilion-nixos/follett.nix;
            }
          ];
        };

        # MSI GE75 Raider host
        msi-ge75-raider-nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # Shared configuration
            ./modules/common.nix

            # Host-specific modules
            ./modules/msi-ge75-raider-nixos/desktop.nix
            ./modules/msi-ge75-raider-nixos/nvidia.nix
            ./modules/msi-ge75-raider-nixos/hardware.nix
            ./modules/msi-ge75-raider-nixos/networking.nix
            ./modules/msi-ge75-raider-nixos/packages.nix
            ./modules/msi-ge75-raider-nixos/services.nix
            ./modules/msi-ge75-raider-nixos/users.nix

            # Standard NixOS host files
            ./hosts/msi-ge75-raider-nixos/configuration.nix
            ./hosts/msi-ge75-raider-nixos/hardware-configuration.nix

            # Home Manager integration for users
            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.users.joseph = import ./home/msi-ge75-raider-nixos/joseph.nix;
              # Add more users for MSI here as needed
            }
          ];
        };
      };
    };
}

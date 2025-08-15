## flake.nix (nixos-config)
# NixOS and Home Manager configurations for multiple hosts and users
{
  description = "NixOS and Home Manager configuration for multiple hosts and users";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Bring in dotfiles repo to source the single theme JSON
    # Use GitHub by default so /etc/nixos can evaluate purely; override locally with:
    #   nix build --override-input dotfiles path:../dotfiles
    dotfiles = {
      url = "github:emeraldocean123/dotfiles";
      # Ensure dotfiles uses the same nixpkgs version for consistency
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, dotfiles, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
  # Allow `nix fmt` to format Nix files using nixpkgs-fmt
  formatter.${system} = pkgs.nixpkgs-fmt;

      # Add a developer shell for formatting and checking your code.
      # Run `nix develop` in this directory to use it.
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixpkgs-fmt
          statix
          nil
        ];
      };

      nixosConfigurations = {
        # HP dv9500 Pavilion host
  hp-dv9500-pavilion-nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          # Make flake inputs available to modules
          specialArgs = { inherit dotfiles; };
          modules = [
            ./modules/hp-dv9500-pavilion-nixos/hardware.nix
            ./modules/hp-dv9500-pavilion-nixos/display.nix
            ./modules/hp-dv9500-pavilion-nixos/desktop.nix
            ./modules/hp-dv9500-pavilion-nixos/networking.nix
            ./modules/hp-dv9500-pavilion-nixos/packages.nix
            ./modules/hp-dv9500-pavilion-nixos/services.nix
            ./modules/hp-dv9500-pavilion-nixos/users.nix
            ./hosts/hp-dv9500-pavilion-nixos/configuration.nix
            ./hosts/hp-dv9500-pavilion-nixos/hardware-configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              # Also expose flake inputs to Home Manager modules
              home-manager.extraSpecialArgs = { inherit dotfiles; };
              home-manager.users.joseph = import ./home/hp-dv9500-pavilion-nixos/joseph.nix;
              home-manager.users.follett = import ./home/hp-dv9500-pavilion-nixos/follett.nix;
            }
          ];
        };

        # MSI GE75 Raider host
  msi-ge75-raider-nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit dotfiles; };
          modules = [
            ./modules/msi-ge75-raider-nixos/hardware.nix
            ./modules/msi-ge75-raider-nixos/display.nix
            ./modules/msi-ge75-raider-nixos/desktop.nix
            ./modules/msi-ge75-raider-nixos/nvidia.nix
            ./modules/msi-ge75-raider-nixos/networking.nix
            ./modules/msi-ge75-raider-nixos/packages.nix
            ./modules/msi-ge75-raider-nixos/services.nix
            ./modules/msi-ge75-raider-nixos/users.nix
            ./hosts/msi-ge75-raider-nixos/configuration.nix
            ./hosts/msi-ge75-raider-nixos/hardware-configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = { inherit dotfiles; };
              home-manager.users.joseph = import ./home/msi-ge75-raider-nixos/joseph.nix;
              home-manager.users.follett = import ./home/msi-ge75-raider-nixos/follett.nix;
            }
          ];
        };
      };
    };
}

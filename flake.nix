{
  description = "NixOS Flake for hp-dv9500-pavilion-nixos with modular config and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations."hp-dv9500-pavilion-nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/hp-dv9500-pavilion-nixos/hardware-configuration.nix
        ./hosts/hp-dv9500-pavilion-nixos/configuration.nix
        ./modules/desktop.nix
        ./modules/networking.nix
        ./modules/packages.nix
        ./modules/services.nix
        ./modules/users.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.joseph = import ./home/joseph.nix;
        }
      ];
    };
  };
}

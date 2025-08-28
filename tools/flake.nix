{
  description = "Local dev shell for Nix formatting/linting (WSL-friendly)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            nixfmt-rfc-style
            statix
            deadnix
            treefmt
            nil
            git
            just
            python3  # for pre-commit if you want it
          ];
          shellHook = ''
            echo "Dev shell ready: alejandra, nixfmt, statix, deadnix, treefmt, nil, just"
            echo "Use: just fmt | just lint | just fix"
          '';
        };
      }
    );
}


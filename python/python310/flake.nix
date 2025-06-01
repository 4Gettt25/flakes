# flakes/python/flake.nix
{
  description = "Python development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.python310
            pkgs.poetry
            pkgs.git
            # add more Python-related packages here
          ];
          shellHook = ''
            export NIX_CONFIG="experimental-features = nix-command flakes"
            echo "Entering Python flake devShell"
          '';
        };
      });
}

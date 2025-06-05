{
  description = "Laravel + Filament PHP project environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        packages.default = pkgs.buildEnv {
          name = "logbook-php-env";
          paths = [
            pkgs.php83
            pkgs.php83Packages.composer
            pkgs.nodejs_20
            # install Laravel/Filament with Composer
          ];
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.php83
            pkgs.php83Packages.composer
            pkgs.nodejs_20
            # install Laravel/Filament with Composer
          ];
          shellHook = ''
            export NIX_CONFIG="experimental-features = nix-command flakes"
            echo "Entering Laravel + Filament development shell"
          '';
        };
      });
}

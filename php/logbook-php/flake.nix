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
            # Framework tooling
            pkgs.php83Packages.laravel
            pkgs.php83Packages.filament
          ];
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.php83
            pkgs.php83Packages.composer
            pkgs.nodejs_20
            pkgs.php83Packages.laravel
            pkgs.php83Packages.filament
          ];
          shellHook = ''
            export NIX_CONFIG="experimental-features = nix-command flakes"
            echo "Entering Laravel + Filament development shell"
          '';
        };
      });
}

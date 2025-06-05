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
            pkgs.postgresql
            # Laravel/Filament installed via Composer in shellHook
          ];
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.php83
            pkgs.php83Packages.composer
            pkgs.nodejs_20
            pkgs.postgresql
          ];
          shellHook = ''
            export NIX_CONFIG="experimental-features = nix-command flakes"
            echo "Entering Laravel + Filament development shell"

            # Ensure local postgres data directory
            if [ -z "$PGDATA" ]; then
              export PGDATA="$PWD/.pgdata"
            fi
            if [ ! -d "$PGDATA" ]; then
              echo "Initializing local PostgreSQL in $PGDATA"
              initdb "$PGDATA" >/dev/null
            fi
            pg_ctl -D "$PGDATA" -o "-k $PGDATA" -l "$PGDATA/postgres.log" start

            # Install Laravel and Filament if missing
            if [ ! -f composer.json ] && [ -d logbook-php ]; then
              cd logbook-php
            fi

            if [ ! -f artisan ]; then
              composer create-project laravel/laravel .
            fi

            if ! grep -q 'filament/filament' composer.json 2>/dev/null; then
              composer require filament/filament --no-interaction
            fi
          '';
        };
      });
}

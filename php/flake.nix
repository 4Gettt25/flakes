# php/flake.nix
{
  description = "PHP development environment (e.g., PHP 8.0)";

  inputs = {
    nixpkgs.url    = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            # Pick your desired PHP version—e.g., php80 or php81
            pkgs.php80
            pkgs.composer    # PHP dependency manager
            # add other PHP-related tools (e.g. phpExtensions.xdebug) here
          ];
          shellHook = ''
            export NIX_CONFIG="experimental-features = nix-command flakes"
            echo "Entering PHP development shell (PHP 8.0)"
          '';
        };
      });
}

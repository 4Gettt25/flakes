{
  description = "Root flake combining several language envs as subflakes";

  inputs = {
    # Base flakes you’ll likely need
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";


    # Python subflakes
    python310.url = "github:4Gettt25/flakes?dir=python/python310";
    python313.url = "github:4Gettt25/flakes?dir=python/python313";

    # PHP subflakes
    php.url       = "github:4Gettt25/flakes?dir=php";
  };

  outputs = { 
    self,
    nixpkgs,
    flake-utils,
    python310,
    php,
    python313,
    ...
    }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Expose a devShell for the “root” (if desired)
        devShells.default = pkgs.mkShell {
          name = "root-shell-${system}";
          buildInputs = with pkgs; [ ];
          shellHook = ''
            echo "Use nix develop .#python310 or .#php to enter those shells"
          '';
        };

        # Forward each subflake’s devShell
        # Python 3.13 and 3.10
        devShells.python313 = python313.devShells.${system}.default;
        devShells.python310 = python310.devShells.${system}.default;

        # PHP
        devShells.php       = php.devShells.${system}.default;
      }
    );
}

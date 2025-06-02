{
  description = "Root flake combining several language envs as subflakes";

  inputs = {
    # Base flakes you’ll likely need
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Each language folder becomes its own flake under the same GitHub repo
    python310.url = "github:4Gettt25/flakes?dir=python/python310";
    php.url       = "github:4Gettt25/flakes?dir=php";
    # (Add more: e.g. php8.url = "github:4Gettt25/flakes?dir=php8"; etc.)
  };

  outputs = { self, nixpkgs, flake-utils, python310, php, ... }:
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
        devShells.python310 = python310.devShells.${system}.default;
        devShells.php       = php.devShells.${system}.default;
      }
    );
}

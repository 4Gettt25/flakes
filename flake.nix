# flake.nix (at repository root)
{
  description = "Top-level flake that delegates to subflakes (Python & PHP)";
  inputs = {
    nixpkgs.url     = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Import the Python subflake
        python310Flake = import ./python/python310/flake.nix;
        python310Outputs = python310Flake.outputs { inherit self nixpkgs flake-utils; };

        # Import the new PHP subflake
        phpFlake = import ./php/flake.nix;
        phpOutputs = phpFlake.outputs { inherit self nixpkgs flake-utils; };
      in
      {
        # Re-export Python 3.10 as before
        devShells.python310 = python310Outputs.devShells.${system}.default;

        # New: Re-export PHP devShell (default output) under `php`
        devShells.php = phpOutputs.devShells.${system}.default;
      }
    );
}

# flake.nix (at repository root)
{
  description = "Top-level flake that delegates to all subflakes";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # 1) Import the subflake from the python/python310 directory
        python310Flake = import ./python/python310/flake.nix;

        # 2) Call its outputs function with the same inputs
        python310Outputs = python310Flake.outputs { inherit self nixpkgs flake-utils; };
      in
      {
        # 3) Expose the subflake’s default devShell as devShells.python310
        devShells.python310 = python310Outputs.devShells.${system}.default;
      }
    );
}

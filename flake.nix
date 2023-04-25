{
  description = "A flake containing utilities for quantum error correction";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-22.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkg_overlays = import ./overlays;
          pkg_overlays_ordered = with pkg_overlays; [
            gap
            python
          ];
          pkgs = nixpkgs.legacyPackages.${system}.extend pkg_overlays.python;
          # pkgs = import nixpkgs { inherit system; overlays = pkg_overlays_ordered; };
        in rec {
          # Basic python interpreter with some python packages
          packages.py = pkgs.python3.withPackages (ps: [
            ps.stim
            ps.ldpc
            ps.pymatching
            ps.galois
            
            ps.pytest
            ps.pdoc3
            
            ps.numpy
            ps.pandas
            ps.scipy
            ps.matplotlib
          ]);

          packages.gap = pkgs.gap;
          
          overlays = pkg_overlays;
        }
      );
}

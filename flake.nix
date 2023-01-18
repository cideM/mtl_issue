{
  description = "Simple Haskell Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };

        project = pkgs.haskellPackages.callPackage ./project.nix {};

        workaround140774 = haskellPackage:
          with pkgs.haskell.lib;
            overrideCabal haskellPackage (drv: {
              enableSeparateBinOutput = false;
            });
      in rec {
        packages = flake-utils.lib.flattenTree {
          app = project;
        };
        defaultPackage = packages.app;
        apps.app = flake-utils.lib.mkApp {drv = packages.app;};
        defaultApp = apps.app;

        devShell = pkgs.mkShell {
          inputsFrom = [project.env];
          buildInputs = with pkgs;
          with haskellPackages; [
            coreutils
            moreutils
            jq

            (workaround140774 haskellPackages.ormolu)
            (workaround140774 haskellPackages.ghcid)
            (haskell.packages.ghc924.ghcWithPackages (hpkgs:
              with hpkgs; [
                cabal-install
                cabal-fmt
                hlint
                cabal2nix
                fast-tags
                hoogle
              ]))
          ];
        };
      }
    );
}

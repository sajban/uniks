{ system, lib, src, meikPkgs, hob }:
let
  inherit (builtins) readFile elem;
  emacs-overlay = src;
  pkgs = meikPkgs { overlays = [ emacs-overlay.overlay ]; };
  inherit (pkgs) writeText emacsPackagesFor emacsPgtkGcc;

  current = emacsPgtkGcc;
  currentPackages = emacsPackagesFor current;

  parseLib = import (emacs-overlay + /parse.nix)
    { inherit pkgs lib; };

  inherit (parseLib) parsePackagesFromUsePackage;

  mkUsePackages = { Elisp, elispPackages ? currentPackages }:
    let
      mkUsePackagesNames = Elisp:
        lib.unique
          (parsePackagesFromUsePackage {
            configText = Elisp;
            alwaysEnsure = true;
          });

      mkPackageError = name:
        builtins.trace
          "Emacs package ${name}, declared wanted with use-package, not found."
          null;

      emacsDistroPackages = [ "json" "auth-source-pass" ];

      mkPossibleError = name:
        if (elem name emacsDistroPackages)
        then null else (mkPackageError name);

      findPackage = name: elispPackages.${name}  or (mkPossibleError name);

    in
    map findPackage (mkUsePackagesNames Elisp);

  mkElispDerivation =
    inputs@
    { name
    , version
    , src
    , elispBuild
    , elispDependencies ? [ ]
    , elnDependencies ? [ ]
    , emacsPackage ? current
    }:
    let
      emacsPackages = emacsPackagesFor emacsPackage;
      inherit (emacsPackages) trivialBuild;

      elispSetup = writeText "setup.el"
        (readFile ./setup.el);

      mkStructuredDerivation = drv: {
        inherit (drv) propagatedBuildInputs;
        result = drv.outPath;
      };

      species =
        let src = hob.species-el.mein; in
        trivialBuild {
          pname = "species";
          inherit src;
          version = src.shortRev;
          commit = src.rev;
        };


    in
    derivation {
      inherit name version src system
        elispDependencies elispBuild elnDependencies;

      elispMkDerivation = writeText "mkDerivation.el"
        (readFile ./mkDerivation.el);

      setupElnDependencies = with emacsPackages;
        [ species dash jeison ];

      structuredDerivations = map mkStructuredDerivation
        (with emacsPackages; [ dash jeison ]);

      builder = emacsPackage + /bin/emacs;

      args = [
        "--no-site-file"
        "--batch"
        "--load"
        elispSetup
      ];

      __structuredAttrs = true;
    };

in
{
  inherit current currentPackages pkgs
    parseLib mkElispDerivation mkUsePackages;
}

{ system, lib, src, meikPkgs }:
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
    , elnDeps ? [ ]
    , emacsPackage ? current
    , emacsExecutable ? (emacsPackage + /bin/emacs)
    , elispSetup ? (writeText "mkElispDerivationSetup.el"
        (readFile ./mkElispDerivationSetup.el))
    }:
    derivation {
      inherit name version src system
        elispDependencies elispBuild;
      elnDependencies = elnDeps
        ++ (with currentPackages;
        [ dash s f jeison ]);
      builder = emacsExecutable;
      args = [ "--batch" "--load" elispSetup ];
      coreutilsPath = lib.makeBinPath [ pkgs.coreutils ];
      __structuredAttrs = true;
    };

in
{
  inherit current currentPackages pkgs
    parseLib mkElispDerivation mkUsePackages;
}

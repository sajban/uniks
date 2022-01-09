{ kor, lib, src, emacs, hob }:
let
  inherit (builtins) readFile concatStringsSep mapAttrs elemAt length;
  inherit (kor) mesydj nameValuePair mapAttrs';
  inherit (emacs) mkUsePackages mkElispDerivation;
  inherit (emacs.pkgs) stdenv writeText;
  inherit (emacs.parseLib) parsePackagesFromUsePackage;

  emacsPackages = emacs.currentPackages;
  inherit (emacsPackages) elpaBuild withPackages melpaBuild
    trivialBuild;

  customPackages = {
    base16-theme =
      let
        src = hob.base16-theme.mein;
      in
      trivialBuild {
        pname = "base16-theme";
        version = src.shortRev;
        inherit src;
      };

    ement =
      let
        src = hob.ement-el.mein;
      in
      trivialBuild {
        pname = "ement";
        version = src.shortRev;
        inherit src;
        packageRequires = with emacsPackages; [
          plz
          cl-lib
          ts
        ];
      };

    shen-mode =
      let src = hob.shen-mode.mein; in
      melpaBuild {
        pname = "shen-mode";
        inherit src;
        commit = src.rev;
        version = "0.1";
        recipe = writeText "recipe" ''
          (shen-mode
           :repo "NHALX/shen-mode"
           :fetcher github)
        '';
      };

    species =
      let src = hob.species-el.mein; in
      trivialBuild {
        pname = "species";
        inherit src;
        version = src.shortRev;
        commit = src.rev;
      };

    xah-fly-keys =
      let src = hob.xah-fly-keys.mein; in
      trivialBuild {
        pname = "xah-fly-keys";
        inherit src;
        version = src.shortRev;
        commit = src.rev;
      };
  };

  mkModuleFromFile = FileName: FileType:
    assert mesydj (FileType == "regular")
      "mkModuleFromFile: unexpected FileType";
    let
      nameAndFileExtension = lib.splitString "." FileName;
      possibleModuleName = elemAt nameAndFileExtension 0;
      possibleFileExtension = elemAt nameAndFileExtension 1;
      name = assert mesydj
        ((length nameAndFileExtension) == 2 &&
          (possibleFileExtension == "el"))
        "ImaksModuleName: Incorrect FileName";
        possibleModuleName;

      Elisp = (readFile (./modules + "/${FileName}"));

      imaksModule = mkImaksModule { inherit name Elisp; };

    in
    nameValuePair name imaksModule;

  mapFilesToModules = Directory:
    mapAttrs' mkModuleFromFile Directory;

  imaksModules = mapFilesToModules (builtins.readDir ./modules);

  overiddenEmacsPackages = emacsPackages // customPackages // imaksModules;

  mkImaksModule = { name, Elisp }:
    let
      mkImaksModuleEl = writeText "mkImaksmodule.el"
        (readFile ./mkImaksModule.el);

      packagesUsed = (mkUsePackages {
        inherit Elisp;
        elispPackages = overiddenEmacsPackages;
      })
      ++ [ overiddenEmacsPackages.use-package ];

      src = writeText "${name}.el" Elisp;

    in
    mkElispDerivation {
      inherit name src;
      version = kor.mkStringHash Elisp;
      elispDependencies = packagesUsed;
      elispBuild = mkImaksModuleEl;
    };

in
{ kriozon, krimyn, profile }:
let
  inherit (krimyn.spinyrz) izUniksDev saizAtList iuzColemak;

  launcher = "selectrum"; # TODO profile

  imaksTheme =
    if profile.dark then "'modus-vivendi"
    else "'modus-operandi";

  initEl = (readFile ./init.el) +
    ''
      (load-theme ${imaksTheme} t)
    '';

  launcherModule = with imaksModules;
    if (launcher == "selectrum")
    then imaksSelectrum else imaksVertico;

  saizModule = with saizAtList; with imaksModules;
    if max then imaksMax
    else if med then imaksMed
    else if min then imaksMin
    else imaksCore;

  imaksModulesUsed = [ saizModule launcherModule ];

  imaks = withPackages imaksModulesUsed;

in
imaks

hob:

let
  pkdjz = {
    bildNvimPlogin = {
      lamdy = import ./bildNvimPlogin;
      modz = [ "pkgs" "pkdjz" ];
      src = null;
    };

    crate2nix = {
      lamdy = import ./crate2nix;
      modz = [ "pkdjz" ];
    };

    deryveicyn = {
      lamdy = import ./deryveicyn;
      modz = [ "pkgs" "uyrld" "hob" ];
      src = null;
    };

    dunst = {
      lamdy = import ./dunst;
      modz = [ "pkgs" ];
    };

    emacs = {
      lamdy = import ./emacs;
      modz = [ "pkdjz" ];
      src = hob.emacs-overlay.mein;
    };

    ementEl = {
      lamdy = import ./ement-el;
      modz = [ "pkgs" ];
    };

    guix = {
      lamdy = import ./guix;
      modz = [ "lib" "pkgs" "hob" ];
    };

    home-manager = {
      lamdy = import ./home-manager;
      modz = [ "lib" "pkgs" "hob" ];
    };

    ivalNixos = {
      lamdy = import ./ivalNixos;
      modz = [ "lib" "pkgsSet" ];
      src = hob.nixpkgs.mein;
    };

    kreitOvyraidz = {
      lamdy = import ./kreitOvyraidz;
      modz = [ "pkgs" "lib" ];
      src = null;
    };

    kynvyrt = {
      lamdy = import ./kynvyrt;
      modz = [ "pkgs" "uyrld" ];
      src = null;
    };

    lib = {
      lamdy = import ./lib;
      src = hob.nixpkgs.mein;
    };

    librem5-flash-image = {
      lamdy = import ./librem5/flashImage.nix;
      modz = [ "pkgs" ];
    };

    mach-nix = { lamdy = import ./mach-nix; };

    meikPkgs = {
      lamdy = import ./meikPkgs;
      modz = [ "lib" ];
      src = hob.nixpkgs.mein;
    };

    meikImaks = {
      lamdy = import ./meikImaks;
      modz = [ "pkdjz" "hob" ];
      src = hob.emacs-overlay.mein;
    };

    mfgtools = {
      lamdy = import ./mfgtools;
      modz = [ "pkgs" ];
    };

    mkCargoNix = {
      lamdy = import ./mkCargoNix;
      modz = [ "pkgs" "lib" "pkdjz" ];
      src = null;
    };

    mozPkgs = {
      lamdy = import ./mozPkgs;
      modz = [ "pkdjz" ];
      src = hob.nixpkgs-mozilla.mein;
    };

    naersk = {
      lamdy = import ./naersk;
      modz = [ "pkgs" ];
    };

    nvimLuaPloginz = {
      lamdy = import ./nvimPloginz/lua.nix;
      modz = [ "hob" "pkdjz" ];
      src = null;
    };

    nvimPloginz = {
      lamdy = import ./nvimPloginz;
      modz = [ "hob" "pkdjz" ];
      src = null;
    };

    nerd-fonts = {
      lamdy = import ./nerd-fonts;
      modz = [ "pkgs" ];
      src = null;
    };

    nightlyRust = {
      lamdy = import ./nightlyRust;
      modz = [ "pkdjz" ];
      src = null;
    };

    nix = { lamdy = import ./nix; };

    nix-dev = {
      lamdy = import ./nix;
      modz = [ "pkgs" "pkdjz" ];
      src = hob.nix.maisiliym.dev;
    };

    pkgs = {
      lamdy = import ./pkgs;
      modz = [ "pkdjz" ];
    };

    pkgsNvimPloginz = {
      lamdy = import ./pkgsNvimPloginz;
      modz = [ "pkgsSet" "lib" "pkdjz" ];
      src = hob.nixpkgs.mein;
    };

    ql2nix = {
      lamdy = import ./ql2nix;
      modz = [ "pkgsSet" ];
    };

    sbcl = {
      lamdy = import ./sbcl/static.nix;
      modz = [ "pkgsSet" "pkgsStatic" ];
    };

    shen-bootstrap = {
      lamdy = import ./shen/bootstrap.nix;
      modz = [ "pkgs" ];
      src = hob.shen.mein;
    };

    shen-ecl-bootstrap = {
      lamdy = import ./shen/ecl.nix;
      modz = [ "pkgs" ];
      src = null;
    };

    shenPrelude = {
      lamdy = import ./shen/prelude.nix;
      modz = [ "pkgs" ];
    };

    slynkPackages = {
      lamdy = import ./slynkPackages;
      modz = [ "pkgs" ];
      src = null;
    };

    uniks = {
      lamdy = import ./uniks;
      modz = [ "pkgs" "pkdjz" ];
    };

    vimPloginz = {
      lamdy = import ./vimPloginz;
      modz = [ "pkgs" "pkdjz" "hob" ];
      src = null;
    };
  };

  aliases = {
    shen = pkdjz.shen-ecl-bootstrap;
  };

in
pkdjz // aliases 

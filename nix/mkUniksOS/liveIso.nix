{ pkgs, lib, hyraizyn, config, kor, nixOSRev, konstynts, ... }:
let
  inherit (builtins) concatStringsSep;
  inherit (lib) mkOverride;
  inherit (hyraizyn.astra) uniksNeim;
  inherit (konstynts.fileSystem.niks) priKriad;
  nixExec = config.nix.package + /bin/nix;

  bashGenerateNixKriad = concatStringsSep " " [
    nixExec
    "key generate-secret --key-name"
    uniksNeim
    ">"
    priKriad
  ];

in
{
  boot = {
    supportedFilesystems = mkOverride 10 [ "btrfs" "vfat" "xfs" "ntfs" ];
  };

  isoImage = {
    isoBaseName = "uniksos";
    volumeID = "uniksos-${nixOSRev}-${pkgs.stdenv.hostPlatform.uname.processor}";

    makeUsbBootable = true;
    makeEfiBootable = true;
  };

  systemd = {
    services = {
      kriadzGeneration = {
        description = "Generating uniksOS kriadz";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = bashGenerateNixKriad;
        };
      };
    };
  };

}

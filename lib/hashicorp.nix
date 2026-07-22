/*
  This function creates a derivation for installing binaries directly from releases.hashicorp.com.
  Found in the bowels if mitchellh/nixos-config and adapted for flakes/flake-parts
*/
{
  name,
  version,
  sha256,
  config,
  system ? builtins.currentSystem,
  pname ? "${name}-bin",

  pkgs,
}:

let
  # Mapping of Nix systems to the GOOS/GOARCH pairs.
  systemMap = {
    x86_64-linux = "linux_amd64";
    i686-linux = "linux_386";
    x86_64-darwin = "darwin_amd64";
    i686-darwin = "darwin_386";
    aarch64-linux = "linux_arm64";
  };

  # Get our system
  goSystem = systemMap.${system} or (throw "unsupported system: ${system}");

  # url for downloading composed of all the other stuff we built up.
  url = "https://releases.hashicorp.com/${name}/${version}/${name}_${version}_${goSystem}.zip";

  files = pkgs.lib.fileset.maybeMissing config;
in
pkgs.stdenv.mkDerivation {
  inherit pname version;
  src = pkgs.fetchurl { inherit url sha256; };

  # Our source is right where the unzip happens, not in a "src/" directory (default)
  sourceRoot = ".";

  # Stripping breaks darwin Go binaries
  dontStrip = pkgs.lib.strings.hasPrefix "darwin" goSystem;

  nativeBuildInputs = [
    pkgs.unzip
  ]
  ++ (
    if pkgs.stdenv.isLinux then
      [
        # On Linux we need to do this so executables work
        pkgs.autoPatchelfHook
      ]
    else
      [ ]
  );

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/config
    mv ${name} $out/bin
    cp -r ${config}/* $out/config
  '';
}

# { callPackage ? pkgs.callPackage
# , pkgs ? import <nixpkgs> {} }:
#
# callPackage (import ./hashicorp/generic.nix) {
#   name = "nomad";
#   version = "1.0.4";
#   sha256 = "0h78akj9hczgv4wrzwy93wxh8ki51b0g55n39i8ak3kc6sqvif6v";
# }

{
  description = "mphidflash";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem =
        { pkgs, system, ... }:
        {
          packages = rec {
            mphidflash = pkgs.stdenv.mkDerivation {
              pname = "mphidflash";
              version = "1.6";
              src = pkgs.fetchFromGitHub {
                owner = "EmbeddedMan";
                repo = "mphidflash";
                rev = "1.6";
                hash = "sha256-U15M9ay5YrXQ8phuMQ3sREzk4gh011NSSsqxNUIiwgA=";
              };
              nativeBuildInputs = [
                pkgs.libusb-compat-0_1
                pkgs.autoPatchelfHook
              ];
              installPhase = ''
                mkdir -p $out/bin
                cp $src/binaries/mphidflash-1.6-linux-64 $out/bin/mphidflash
              '';
            };
            default = mphidflash;
          };
        };
    };
}

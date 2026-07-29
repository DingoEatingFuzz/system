{
  description = "Nomad";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    {
      flake-parts,
      ...
    }@inputs:
    let
      mkHashicorp = import ../../lib/hashicorp.nix;
      hashes = {
        x86_64-linux = "786b04ee9d002e6b4231dbcb8dde3ab65c6fe0a728a01fcad14e87a681e48ce1";
        aarch64-linux = "53672b179cb71f9a814fdb40ec2fcabe91716d5d44eada84a2a63db38ad66077";
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { pkgs, system, ... }:
        {
          packages = rec {
            nomad-driver-podman = mkHashicorp {
              pkgs = pkgs;
              name = "nomad-driver-podman";
              binname = "podman";
              version = "0.6.5";
              sha256 = hashes.${system};
              system = system;
            };
            default = nomad-driver-podman;
          };
        };
    };
}

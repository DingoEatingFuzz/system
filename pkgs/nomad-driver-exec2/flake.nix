{
  description = "Nomad Exec2 Task Driver";
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
        x86_64-linux = "7174229002d9c5a4612b1bcd01cc5ab1dac869bd0deb7c2b867afe3e9bb293f8";
        aarch64-linux = "bd5546d0562f1e6f42e19660d1e34c2d9a37e1b634eb9a760613d8f428c1d9c3";
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
            nomad-driver-exec2 = mkHashicorp {
              pkgs = pkgs;
              name = "nomad-driver-exec2";
              pname = "nomad-driver-exec2";
              version = "0.1.2";
              sha256 = hashes.${system};
              system = system;
              buildInputs = [ pkgs.util-linux ];
            };
            default = nomad-driver-exec2;
          };
        };
    };
}

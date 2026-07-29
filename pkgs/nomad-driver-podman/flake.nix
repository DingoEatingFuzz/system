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
        x86_64-linux = "8455d5691de4cb451e9443282f1c0171570b480737fc6386992638c52a4795e4";
        aarch64-linux = "61cd1bf830b5db07e87ab5d1dbb73a7b23fbe4c5aed6d81dd0cddc04001b5500";
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
              version = "0.6.5";
              sha256 = hashes.${system};
              system = system;
            };
            default = nomad-driver-podman;
          };
        };
    };
}

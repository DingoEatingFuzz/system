{
  description = "Nomad Libvirt Task Driver";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    { flake-parts, ... }@inputs:
    let
      mkHashicorp = import ../../lib/hashicorp.nix;
      hashes = {
        x86_64-linux = "c7c3d20278c32da77529f367682bf01042fbf243bc12edd0b895af5edf925394";
        aarch64-linux = "9caa4878351ba274c3e3d0b87b2a571b0a878e0af731c87d2a67e25cb0f13c15";
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
            nomad-driver-virt = mkHashicorp {
              pkgs = pkgs;
              name = "nomad-driver-virt";
              pname = "nomad-driver-virt";
              version = "0.0.2-beta.1";
              sha256 = hashes.${system};
              system = system;
            };
            default = nomad-driver-virt;
          };
        };
    };
}

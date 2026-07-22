{
  description = "Nomad";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    {
      self,
      flake-parts,
      nixpkgs,
      ...
    }@inputs:
    let
      mkHashicorp = import ../../lib/hashicorp.nix;
      hashes = {
        x86_64-darwin = "0b536c17ad302518c4022f6d868fa86526c2f17142e8b004fca0d9217cefeb6d";
        aarch64-darwin = "e482c25c608ea7c40bcc75a6802c51580e3fa08e3a78e387faf62b6d499ecb0b";
        x86_64-linux = "8455d5691de4cb451e9443282f1c0171570b480737fc6386992638c52a4795e4";
        aarch64-linux = "61cd1bf830b5db07e87ab5d1dbb73a7b23fbe4c5aed6d81dd0cddc04001b5500";
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "i686-darwin"
        "aarch64-linux"
      ];

      perSystem =
        { pkgs, system, ... }:
        {
          packages = rec {
            nomad = mkHashicorp {
              pkgs = pkgs;
              name = "nomad";
              version = "2.0.3";
              sha256 = hashes.${system};
              system = system;
              config = ./../../config/nomad;
            };
            default = nomad;
          };
        };

      flake = {
        service =
          {
            package,
            pkgs,
            mode,
            serviceConfig ? { },
          }:
          let
            file = if mode == "server" then "server.hcl" else "client.hcl";
          in
          {
            enable = true;
            description = "Nomad Orchestrator";
            after = [ "network-online.target" ];
            wants = [
              "network-online.target"
              "nix-store.mount"
            ];
            wantedBy = [ "multi-user.target" ];
            path = [ pkgs.iproute2 ];
            serviceConfig = {
              Type = "notify";
              ExecReload = "kill -HUP";
              ExecStart = "${package}/bin/nomad agent -config ${package}/config/${file}";
              KillMode = "process";
              KillSignal = "SIGINT";
              LimitNOFILE = 65536;
              LimitNPROC = "infinity";
              Restart = "on-failure";
              RestartSec = 2;
              TasksMax = "infinity";
              OOMScoreAdjust = -1000; # Never kill Nomad
            }
            // serviceConfig;
          };
      };
    };
}

{
  description = "Nomad";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    podman.url = "path:./../nomad-driver-podman";
    libvirt.url = "path:./../nomad-driver-virt";
    exec2.url = "path:./../nomad-driver-exec2";
  };
  outputs =
    { flake-parts, ... }@inputs:
    let
      mkHashicorp = import ../../lib/hashicorp.nix;
      hashes = {
        x86_64-darwin = "0b536c17ad302518c4022f6d868fa86526c2f17142e8b004fca0d9217cefeb6d";
        aarch64-darwin = "e482c25c608ea7c40bcc75a6802c51580e3fa08e3a78e387faf62b6d499ecb0b";
        x86_64-linux = "8455d5691de4cb451e9443282f1c0171570b480737fc6386992638c52a4795e4";
        aarch64-linux = "61cd1bf830b5db07e87ab5d1dbb73a7b23fbe4c5aed6d81dd0cddc04001b5500";
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } (
      { getSystem, ... }: {
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];

        perSystem =
          { pkgs, system, ... }:
          let
            # Get driver packages for system
            podman = inputs.podman.packages.${system}.default;
            libvirt = inputs.libvirt.packages.${system}.default;
            exec2 = inputs.exec2.packages.${system}.default;
            nomadpkg = mkHashicorp {
              pkgs = pkgs;
              name = "nomad";
              version = "2.0.3";
              sha256 = hashes.${system};
              system = system;
              config = ./../../config/nomad;
            };

            # Copy driver packages into bin path via wrapping nomad (like neovim)
            pluginpath = pkgs.runCommandLocal "pluginpath" { } ''
              mkdir -p $out/plugins
              ln -vsfT ${podman}/bin/${pkgs.lib.getName podman} $out/plugins/${pkgs.lib.getName podman}
              ln -vsfT ${libvirt}/bin/${pkgs.lib.getName libvirt} $out/plugins/${pkgs.lib.getName libvirt}
              ln -vsfT ${exec2}/bin/${pkgs.lib.getName exec2} $out/plugins/${pkgs.lib.getName exec2}
            '';
          in
          {
            packages = rec {
              inherit pluginpath;
              nomad = mkHashicorp {
                pkgs = pkgs;
                name = "nomad";
                version = "2.0.3";
                sha256 = hashes.${system};
                system = system;
                config = ./../../config/nomad;
              };
              nomad2 = pkgs.symlinkJoin {
                name = "nomad2";
                paths = [
                  nomadpkg
                ];
                passthru = { inherit pluginpath; };
              };
              default = nomad2;
            };
          };

        flake = {
          service =
            {
              package,
              pkgs,
              mode,
              system,
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
              path = [
                pkgs.iproute2
                pkgs.iptables
                pkgs.cloud-init
                pkgs.dnsmasq
                pkgs.qemu
              ];
              serviceConfig = {
                Type = "notify";
                ExecReload = "kill -HUP";
                # Provide the -plugin-dir argument to ${package}/plugins
                ExecStart = "${package}/bin/nomad agent -config ${package}/config/${file} -plugin-dir ${(getSystem system).packages.pluginpath}/plugins";
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
      }
    );
}

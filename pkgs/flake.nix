{
  description = "Repo local packages";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvim.url = "path:./neovim";
    inky.url = "path:./inky";
  };
  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { pkgs, system, ... }:
        {
          packages = rec {
            nvim = inputs.nvim.packages.${system}.nvim2;
            inky = inputs.inky.packages.${system}.inky;
            nomad = inputs.nomad.packages.${system}.nomad;
            default = nvim;
          };
        };
    };
}

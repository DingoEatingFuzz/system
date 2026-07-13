{
  description = "Repo local packages";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvim.url = "path:./neovim";
    inky.url = "path:./inky";
    nomad.url = "path:./nomad";
    mphidflash.url = "path:./mphidflash";
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
        { system, ... }:
        let
          systemPkgs = {
            "x86_64-linux" = {
              mphidflash = inputs.mphidflash.packages.x86_64-linux.mphidflash;
            };
          };
          get = inp: inputs.${inp}.packages.${system}.default;
        in
        {
          # TODO: write a function that takes a set of packages and returns this hash by calling get with each val
          # default package should be a noop
          packages = rec {
            nvim = get "nvim";
            # nvim = inputs.nvim.packages.${system}.nvim2;
            inky = inputs.inky.packages.${system}.inky;
            nomad = inputs.nomad.packages.${system}.nomad;
            default = nvim;
          }
          // systemPkgs.${system};
        };
    };
}

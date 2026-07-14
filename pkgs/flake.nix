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
        { pkgs, system, ... }:
        let
          # A hash of packages that should only be installed for certain operating systems
          # It gets merged with packages below.
          systemPkgs = {
            "x86_64-linux" = {
              mphidflash = inputs.mphidflash.packages.x86_64-linux.mphidflash;
            };
          };

          # Each input in this meta flake represents a single package.
          # The getPackage function gets the default package from an input for the system.
          getPackage = inp: inputs.${inp}.packages.${system}.default;

          # Turn a list of package names into a hash of package exports
          inputzip = builtins.foldl' (acc: next: acc // { ${next} = getPackage next; }) { };

          # Make sure packages from a list includes a default package (flake requirement)
          mkPkgs = packages: (inputzip packages) // { default = pkgs.cowsay; };
        in
        {
          packages =
            (mkPkgs [
              "nvim"
              "inky"
              "nomad"
            ])
            // systemPkgs.${system};
        };
    };
}

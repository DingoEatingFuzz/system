{
  description = "System";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    ghostty.url = "github:ghostty-org/ghostty";
    affinity.url = "github:mrshmllow/affinity-nix";
    local.url = "path:./../pkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            system = system;
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
            local = inputs.local;
            ghostty = inputs.ghostty;
            affinity = inputs.affinity;
          };
          modules = [
            inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series1
            ./../machines/framework-13/configuration.nix
            ./../machines/framework-13/hardware-configuration.nix
            ./../lib/fonts.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.michael = import ./../profiles/framework-13.nix;
            }
          ];
        };
      };
    };
}

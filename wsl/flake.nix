{
  description = "System";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    ghostty.url = "github:ghostty-org/ghostty";
    affinity.url = "github:mrshmllow/affinity-nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    local = {
      url = "path:./../pkgs";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      unfree =
        input: system:
        import input {
          inherit system;
          config.allowUnfree = true;
        };
    in
    {
      nixosConfigurations = {
        wsl = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            system = system;
            pkgs-unstable = unfree inputs.nixpkgs-unstable system;
            local = inputs.local;
          };
          modules = [
            inputs.nixos-wsl.nixosModules.default
            home-manager.nixosModules.home-manager
            ./../machines/wsl.nix
            ./../lib/fonts.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.nixos = import ./../profiles/wsl.nix;
            }
          ];
        };
        nixos = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            system = system;
            pkgs-unstable = unfree inputs.nixpkgs-unstable system;
            local = inputs.local;
            ghostty = inputs.ghostty;
            affinity = unfree inputs.affinity system;
          };
          modules = [
            inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series1
            home-manager.nixosModules.home-manager
            ./configuration.nix
            ./hardware-configuration.nix
            ./fonts.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.michael = import ./laptop-home.nix;
            }
          ];
        };
      };
    };
}

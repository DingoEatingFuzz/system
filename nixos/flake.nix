{
  description = "System";

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
    connect-timeout = 5;
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    disko.url = "github:nix-community/disko";
    nixos-anywhere.url = "github:nix-community/nixos-anywhere";
    ghostty.url = "github:ghostty-org/ghostty";
    affinity.url = "github:mrshmllow/affinity-nix";
    local.url = "path:./../pkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nixos-raspberrypi,
      ...
    }:
    let
      unfree =
        input: system:
        import input {
          inherit system;
          config.allowUnfree = true;
        };
      inputsPassthru = system: {
        system = system;
        pkgs-unstable = unfree inputs.nixpkgs-unstable system;
        local = inputs.local;
      };
      home = user: path: specialArgs: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = specialArgs;
        home-manager.users.${user} = import path;
      };

      piSystemCustom =
        customModules: hostName:
        nixos-raspberrypi.lib.nixosSystem rec {
          system = "aarch64-linux";
          specialArgs = inputsPassthru system;
          modules = [
            inputs.disko.nixosModules.disko
            ./../machines/pi/hardware-configuration.nix
            home-manager.nixosModules.home-manager
            { networking.hostName = hostName; }
          ]
          ++ customModules;
        };

      piSystem = piSystemCustom [
        ./../machines/pi/configuration.nix
      ];
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = (inputsPassthru system) // {
            ghostty = inputs.ghostty;
            affinity = inputs.affinity;
          };
          modules = [
            inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series1
            ./../machines/framework-13/configuration.nix
            ./../machines/framework-13/hardware-configuration.nix
            ./../lib/fonts.nix
            home-manager.nixosModules.home-manager
            (home "michael" ./../profiles/framework-13.nix specialArgs)
          ];
        };
        olares = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = (inputsPassthru system);
          modules = [
            ./../machines/olares/configuration.nix
            ./../machines/olares/hardware-configuration.nix
            ./../lib/fonts.nix
            home-manager.nixosModules.home-manager
            (home "nixos" ./../profiles/olares.nix specialArgs)
          ];
        };
        wsl = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = inputsPassthru system;
          modules = [
            inputs.nixos-wsl.nixosModules.default
            home-manager.nixosModules.home-manager
            ./../machines/wsl.nix
            ./../lib/fonts.nix
            (home "nixos" ./../profiles/wsl.nix specialArgs)
          ];
        };
        pi1 = piSystem "pi-1";
        pi2 = piSystem "pi-2";
        pi3 = piSystem "pi-3";
        pi4 = piSystem "pi-4";
      };
    };
}

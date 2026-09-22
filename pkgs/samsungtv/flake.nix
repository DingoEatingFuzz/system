{
  description = "Samsung Smart TV";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pyproject.url = "github:pyproject-nix/pyproject.nix";
  };
  outputs =
    {
      pyproject,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem =
        { pkgs, ... }:
        let
          python = pkgs.python3;
          src = pkgs.fetchFromGitHub {
            owner = "xchwarze";
            repo = "samsung-tv-ws-api";
            rev = "v3.0.6";
            hash = "sha256-2o0CmMhlCx2yVitfwFXXjNQTrDDRlDcDV1kGv/pJxVo=";
          };
          project = pyproject.lib.project.loadPyproject {
            projectRoot = src;
          };
          attrs = project.renderers.buildPythonPackage {
            inherit python;
            extras = [ "cli" ];
          };
        in
        {
          packages = rec {
            samsungtvnix = python.pkgs.buildPythonPackage attrs;
            default = samsungtvnix;
          };
        };
    };
}

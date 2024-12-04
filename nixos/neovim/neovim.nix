{ config, pkgs, pkgs-unstable, inputs, ... }:

{
  imports = [ inputs.nixCats.homeModule ];
  config = {
    nixCats = {
      enable = true;
      addOverlays = [ (inputs.nixCats.utils.standardPluginOverlay inputs) ];
      packageNames = [ "nvim2" ];
      luaPath = "${./.}";

      categoryDefinitions.replace = ({ pkgs, settings, categories, name, ... }@packageDef: {
        lspsAndRuntimeDeps = {
          general = [];
        };

        startupPlugins = {
          general = [];
        };

        optionalPlugins = {
          general = [];
        };
      });

      packages = {
        nvim2 = {pkgs, ...}: {
          settings = {
            wrapRC = true;
          };
          categories = {
            general = true;
            test = true;
            boop = "snoot";
          };
        };
      };
    };
  };
}

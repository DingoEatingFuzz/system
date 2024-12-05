{
  description = "neovim wrapper";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  ouputs =
    {
      self,
      symlinkJoin,
      neovim-unwrapped,
      makeWrapper,
      runCommandLocal,
      lib,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { pkgs, system, ... }:
        let
          packageName = "nvim2";
          vimPlugins = pkgs.vimPlugins;

          startPlugins = [
            vimPlugins.telescope-nvim
            vimPlugins.nvim-treesitter.withAllGrammars
          ];

          foldPlugins = builtins.foldl' (
            acc: next: acc ++ [ next ] ++ (foldPlugins (next.dependencies or [ ]))
          ) [ ];

          startPluginsWithDeps = lib.unique (foldPlugins startPlugins);

          packpath = runCommandLocal "packpath" { } ''
            mkdir -p $out/pack/${packageName}/{start,opt}

            ${lib.concatMapStringsSep "\n" (
              plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/start/${lib.getName plugin}"
            ) startPluginsWithDeps}
          '';
        in
        {
          packages.default = symlinkJoin {
            name = "neovim-custom";
            paths = [ neovim-unwrapped ];
            nativeBuildInputs = [ makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/nvim \
                --add-flags '-u' \
                --add-flags '${./init.lua}' \
                --add-flags '--cmd' \
                --add-flags "'set packpath^=${packpath} | set runtimepath^=${packpath}'" \
                --set-default NVIM_APPNAME nvim2
            '';

            passthru = {
              inherit packpath;
            };
          };
        };
    };
}

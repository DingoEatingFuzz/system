{
  description = "neovim wrapper";
  inputs.nixpkgs.url = "nixpkgs/nixos-24.05";
  ouputs = { self, nixpkgs }@inputs:
  let
    packageName = "nvim2";

    startPlugins = [
      vimPlugins.telescope-nvim
      vimPlugins.nvim-treesitter.withAllGrammars
    ];

    foldPlugins = builtins.foldl' (
      acc: next:
        acc ++ [ next ] ++ (foldPlugins (next.dependencies or []))
    ) [];

    startPluginsWithDeps = lib.unique (foldPlugins startPlugins);

    packpath = runCommandLocal "packpath" {} ''
      mkdir -p $out/pack/${packageName}/{start,opt}

      ${
        lib.concatMapStringsSep
        "\n"
        (plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/start/${lib.getName plugin}")
        startPluginsWithDeps
      }
    '';
  in
    symlinkJoin {
      name = "neovim-custom";
      paths = [neovim-unwrapped];
      nativeBuildInputs = [makeWrapper];
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
    }
}

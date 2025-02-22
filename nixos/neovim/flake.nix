{
  description = "neovim wrapper";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    {
      self,
      nixpkgs,
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
          packageName = "nvim";
          vimPlugins = pkgs.vimPlugins;

          startPlugins = let
            standard = with vimPlugins; [
              # basics
              plenary-nvim
              telescope-nvim
              nvim-tree-lua
              nvim-web-devicons

              # formatting
              conform-nvim

              # language server
              nvim-lspconfig

              # autocomplete
              luasnip
              nvim-cmp
              cmp_luasnip
              cmp-nvim-lsp

              # tabs and status line
              lualine-nvim

              # syntax highlighting
              nvim-treesitter.withAllGrammars
            ];
            custom = [];
          in standard ++ custom;

          foldPlugins = builtins.foldl' (
            acc: next: acc ++ [ next ] ++ (foldPlugins (next.dependencies or [ ]))
          ) [ ];

          startPluginsWithDeps = pkgs.lib.unique (foldPlugins startPlugins);

          packpath = pkgs.runCommandLocal "packpath" { } ''
            mkdir -p $out/pack/${packageName}/{start,opt}

            ln -vsfT ${./cfg} $out/pack/${packageName}/start/cfg

            ${pkgs.lib.concatMapStringsSep "\n" (
              plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/start/${pkgs.lib.getName plugin}"
            ) startPluginsWithDeps}
          '';
        in
        {
          packages = {
            nvim2 = pkgs.symlinkJoin {
              name = "nvim";
              paths = with pkgs; [
                eslint_d
                prettierd
                vscode-langservers-extracted
                zls
                nixd
                rust-analyzer
                stylua
                gotools
                nixd
                nixfmt-rfc-style
                lua-language-server
                typescript-language-server
                neovim-unwrapped
              ];
              nativeBuildInputs = [ pkgs.makeWrapper ];
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
            default = self.packages.${system}.nvim2;
          };
        };
    };
}

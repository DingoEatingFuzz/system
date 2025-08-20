{
  config,
  pkgs,
  pkgs-unstable,
  nvim-wrapper,
  system,
  ...
}:

{
  home.username = "nixos";

  home.packages =
    let
      stable = with pkgs; [
        neofetch
        nurl

        zip
        xz
        unzip
        p7zip

        ripgrep
        jq
        yq-go
        eza
        fzf
        jless

        which
        tree
        gawk

        nix-output-monitor

        glow
        btop
        iotop
        iftop

        strace
        ltrace
        lsof

        sysstat

        git-credential-manager

        nodejs
        go

        wsl-open
        wslu
      ];
      unstable = with pkgs-unstable; [
        (pkgs.writeShellScriptBin "nvim-old" "exec -a $0 ${neovim}/bin/nvim $@")
      ];
      custom = [
        nvim-wrapper.packages.${system}.default
      ];
    in
    stable ++ unstable ++ custom;

  programs.git = {
    enable = true;
    userName = "Michael Lange";
    userEmail = "dingoeatingfuzz@gmail.com";
    extraConfig = {
      credential.helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
      credential.credentialStore = "wincredman";
    };
  };

  programs.helix = {
    enable = true;
    package = pkgs-unstable.helix;
    settings = {
      theme = "edge_light";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
      }
    ];
    themes = {
      edge_light = {
        # From https://github.com/CptPotato/helix-themes/blob/main/schemes/edge
        type = "yellow";
        constant = "purple";
        "constant.numeric" = "green";
        "constant.character.escape" = "cyan";
        "string" = "green";
        "string.regexp" = "orange";
        "comment" = "grey";
        "variable" = "fg";
        "variable.builtin" = "orange";
        "variable.parameter" = "fg";
        "variable.other.member" = "fg";
        "label" = "orange";
        "punctuation" = "grey";
        "punctuation.delimiter" = "grey";
        "punctuation.bracket" = "fg";
        "keyword" = "purple";
        "keyword.directive" = "cyan";
        "operator" = "red";
        "function" = "blue";
        "function.builtin" = "blue";
        "function.macro" = "cyan";
        "tag" = "yellow";
        "namespace" = "red";
        "attribute" = "cyan";
        "constructor" = "yellow";
        "module" = "red";
        "special" = "orange";

        "markup.heading.marker" = "grey";
        "markup.heading.1" = {
          fg = "purple";
          modifiers = [ "bold" ];
        };
        "markup.heading.2" = {
          fg = "red";
          modifiers = [ "bold" ];
        };
        "markup.heading.3" = {
          fg = "blue";
          modifiers = [ "bold" ];
        };
        "markup.heading.4" = {
          fg = "yellow";
          modifiers = [ "bold" ];
        };
        "markup.heading.5" = {
          fg = "green";
          modifiers = [ "bold" ];
        };
        "markup.heading.6" = {
          fg = "fg";
          modifiers = [ "bold" ];
        };
        "markup.list" = "red";
        "markup.bold" = {
          modifiers = [ "bold" ];
        };
        "markup.italic" = {
          modifiers = [ "italic" ];
        };
        "markup.link.url" = {
          fg = "green";
          modifiers = [ "underlined" ];
        };
        "markup.link.text" = "purple";
        "markup.quote" = "grey";
        "markup.raw" = "green";

        "diff.plus" = "green";
        "diff.delta" = "orange";
        "diff.minus" = "red";

        "ui.background" = {
          bg = "bg0";
        };
        "ui.background.separator" = "grey";
        "ui.cursor" = {
          fg = "bg0";
          bg = "fg";
        };
        "ui.cursor.match" = {
          fg = "orange";
          bg = "diff_yellow";
        };
        "ui.cursor.insert" = {
          fg = "black";
          bg = "grey";
        };
        "ui.cursor.select" = {
          fg = "bg0";
          bg = "blue";
        };
        "ui.cursorline.primary" = {
          bg = "bg1";
        };
        "ui.cursorline.secondary" = {
          bg = "bg1";
        };
        "ui.selection" = {
          bg = "bg4";
        };
        "ui.linenr" = "grey";
        "ui.linenr.selected" = "fg";
        "ui.statusline" = {
          fg = "fg";
          bg = "bg3";
        };
        "ui.statusline.inactive" = {
          fg = "grey";
          bg = "bg1";
        };
        "ui.statusline.normal" = {
          fg = "bg0";
          bg = "fg";
          modifiers = [ "bold" ];
        };
        "ui.statusline.insert" = {
          fg = "bg0";
          bg = "purple";
          modifiers = [ "bold" ];
        };
        "ui.statusline.select" = {
          fg = "bg0";
          bg = "blue";
          modifiers = [ "bold" ];
        };
        "ui.bufferline" = {
          fg = "grey";
          bg = "bg1";
        };
        "ui.bufferline.active" = {
          fg = "fg";
          bg = "bg4";
          modifiers = [ "bold" ];
        };
        "ui.popup" = {
          fg = "grey";
          bg = "bg2";
        };
        "ui.window" = {
          fg = "grey";
          bg = "bg0";
        };
        "ui.help" = {
          fg = "fg";
          bg = "bg2";
        };
        "ui.text" = "fg";
        "ui.text.focus" = "green";
        "ui.menu" = {
          fg = "fg";
          bg = "bg3";
        };
        "ui.menu.selected" = {
          fg = "bg0";
          bg = "blue";
        };
        "ui.virtual.whitespace" = {
          fg = "bg4";
        };
        "ui.virtual.indent-guide" = {
          fg = "bg4";
        };
        "ui.virtual.ruler" = {
          bg = "bg2";
        };

        "hint" = "blue";
        "info" = "green";
        "warning" = "yellow";
        "error" = "red";
        "diagnostic" = {
          underline = {
            style = "line";
          };
        };
        "diagnostic.hint" = {
          underline = {
            color = "blue";
            style = "dotted";
          };
        };
        "diagnostic.info" = {
          underline = {
            color = "green";
            style = "dotted";
          };
        };
        "diagnostic.warning" = {
          underline = {
            color = "yellow";
            style = "curl";
          };
        };
        "diagnostic.error" = {
          underline = {
            color = "red";
            style = "curl";
          };
        };

        palette = {
          black = "#dde2e7";
          bg0 = "#fafafa";
          bg1 = "#eef1f4";
          bg2 = "#e8ebf0";
          bg3 = "#e8ebf0";
          bg4 = "#dde2e7";
          bg_grey = "#bcc5cf";
          bg_red = "#e17373";
          diff_red = "#f6e4e4";
          bg_green = "#76af6f";
          diff_green = "#e5eee4";
          bg_blue = "#6996e0";
          diff_blue = "#e3eaf6";
          bg_purple = "#bf75d6";
          diff_yellow = "#f0ece2";
          fg = "#4b505b";
          red = "#d05858";
          orange = "#c76d3f"; # added for compatibility with `sonokai` scheme
          yellow = "#be7e05";
          green = "#608e32";
          cyan = "#3a8b84";
          blue = "#5079be";
          purple = "#b05ccc";
          grey = "#8790a0";
          grey_dim = "#bac3cb";
        };
      };
      edge_dark = {
        "inherits" = "edge_light";
        palette = {
          black = "#202023";
          bg0 = "#2b2d37";
          bg1 = "#333644";
          bg2 = "#363a49";
          bg3 = "#3a3e4e";
          bg4 = "#404455";
          bg_grey = "#7e869b";
          bg_red = "#ec7279";
          diff_red = "#55393d";
          bg_green = "#a0c980";
          diff_green = "#394634";
          bg_blue = "#6cb6eb";
          diff_blue = "#354157";
          bg_purple = "#d38aea";
          diff_yellow = "#4e432f";
          fg = "#c5cdd9";
          red = "#ec7279";
          orange = "#e59b77"; # added for compatibility with `sonokai` scheme
          yellow = "#deb974";
          green = "#a0c980";
          cyan = "#5dbbc1";
          blue = "#6cb6eb";
          purple = "#d38aea";
          grey = "#7e8294";
          grey_dim = "#5b5e71";
        };
      };
    };
  };

  # This is bugged. Likely due to existing broken bashrc?
  # programs.bash = {
  #   enable = true;
  #   enableCompletion = true;
  # };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}

{ config, pkgs, pkgs-unstable, ... }:

{
  home.username = "michael";
  home.homeDirectory = "/home/michael";

  home.packages = let
    stable = with pkgs; [
      neofetch

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
    ];
    unstable = with pkgs-unstable; [
      neovim
      nodejs

      # Language server dev stuff
      nodePackages."eslint_d"
      nodePackages."vscode-langservers-extracted"

      # These packages would be nice to install here, but they aren't
      # in nodePackages so they are installed with the post-install script
      # nodePackages."@fsouza/prettierd"
      # nodePackages."@lifeart/ember-language-server"
      # nodePackages."ember-template-lint"
      # nodePackages."vscode-css-languageservice"
    ];
  in stable ++ unstable; 

  programs.git = {
    enable = true;
    userName = "Michael Lange";
    userEmail = "dingoeatingfuzz@gmail.com";
    extraConfig = {
      credential.helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      credential.credentialStore = "secretservice";
    };
  };

  programs.alacritty = {
    enable = true;
    package = pkgs-unstable.alacritty; 
    settings = {
      window.padding = {
        x = 10;
	y = 10;
      };
      scrolling = {
        history = 5000;
      };
      font = {
        size = 12;
        # draw_bold_text_with_bright_colors = true;
        normal = {
	  family = "SauceCodePro Nerd Font";
	  style = "Regular";
	};
        bold = {
	  family = "SauceCodePro Nerd Font";
	  style = "Bold";
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

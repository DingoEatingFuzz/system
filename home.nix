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
      # alacritty
      neovim
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
      padding = {
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

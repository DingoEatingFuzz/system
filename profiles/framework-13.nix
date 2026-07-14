{
  pkgs,
  pkgs-unstable,
  local,
  ghostty,
  system,
  ...
}:

{
  home.username = "michael";
  home.homeDirectory = "/home/michael";

  home.packages =
    let
      stable = with pkgs; [
        affinity-v3

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

        starship
        glow
        btop
        iotop
        iftop

        strace
        ltrace
        lsof

        sysstat

        git-credential-manager
        _1password-cli
        _1password-gui

        nodejs
        go
      ];
      unstable = with pkgs-unstable; [
        (pkgs.writeShellScriptBin "nvim-old" "exec -a $0 ${neovim}/bin/nvim $@")
        discord-ptb
        signal-desktop
        zed-editor
        obsidian
        synology-drive-client
      ];
      custom = [
        local.packages.${system}.nvim
        local.packages.${system}.mphidflash
        ghostty.packages.${system}.default
      ];
    in
    stable ++ unstable ++ custom;

  programs.git = {
    enable = true;
    userName = "Michael Lange";
    userEmail = "dingoeatingfuzz@gmail.com";
    extraConfig = {
      credential.helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      credential.credentialStore = "secretservice";
      init.defaultBranch = "main";
    };
  };

  programs.alacritty = import ./../lib/alacritty.nix {
    alacritty = pkgs-unstable.alacritty;
    pkgs = pkgs;
  };

  programs.helix = import ./../lib/helix.nix {
    helix = pkgs-unstable.helix;
    pkgs = pkgs;
  };

  # This is bugged. Likely due to existing broken bashrc?
  # programs.bash = {
  #   enable = true;
  #   enableCompletion = true;
  # };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}

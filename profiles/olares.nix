{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  local,
  ghostty,
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
        less
        jless

        which
        tree
        gawk

        nix-output-monitor

        chezmoi
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

        nodejs
        go
      ];
      unstable = with pkgs-unstable; [
        (pkgs.writeShellScriptBin "nvim-old" "exec -a $0 ${neovim}/bin/nvim $@")
      ];
      custom = with local.packages.${system}; [
        nvim
        nomad
      ];
    in
    stable ++ unstable ++ custom;

  home.activation.chezmoi = lib.hm.dag.entryAfter [ "installPackages" ] ''
    echo "Path? $PATH"
    _path=$PATH
    PATH="${config.home.path}/bin:$PATH"
    echo "Setting up ChezMoi from ${config.home.homeDirectory}/system/dotfiles} ..."
    ${pkgs.chezmoi}/bin/chezmoi apply --force --verbose -S ${config.home.homeDirectory}/system/dotfiles
    PATH=$_path
  '';

  # TODO: Move git config into chezmoi to avoid the nixlang parasite
  programs.git = {
    enable = true;
    userName = "Michael Lange";
    userEmail = "dingoeatingfuzz@gmail.com";
    extraConfig = {
      credential.helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
      credential.credentialStore = "wincredman";
      init.defaultBranch = "main";
    };
  };

  programs.helix = import ./../lib/helix.nix {
    helix = pkgs-unstable.helix;
    pkgs = pkgs;
  };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}

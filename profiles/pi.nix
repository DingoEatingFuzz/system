{
  config,
  lib,
  pkgs,
  local,
  system,
  ...
}:
{
  home.username = "pi";
  home.packages =
    with pkgs;
    [
      fastfetch
      nurl
      zip
      xz
      unzip
      p7zip
      ripgrep
      jq
      which
      nix-output-monitor
      lsof
      sysstat
      git-credential-manager
      chezmoi
      starship
    ]
    ++ [ local.packages.${system}.nvim ];

  home.activation.chezmoi = lib.hm.dag.entryAfter [ "installPackages" ] ''
    echo "Path? $PATH"
    _path=$PATH
    PATH="${config.home.path}/bin:$PATH"
    echo "Setting up ChezMoi from ${config.home.homeDirectory}/system/dotfiles} ..."
    ${pkgs.chezmoi}/bin/chezmoi apply --force --verbose -S ${config.home.homeDirectory}/system/dotfiles
    PATH=$_path
  '';

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}

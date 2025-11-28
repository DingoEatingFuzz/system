{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    source-code-pro
    nerd-fonts.sauce-code-pro
  ];
}

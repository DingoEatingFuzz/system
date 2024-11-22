{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    source-code-pro
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
  ];
}

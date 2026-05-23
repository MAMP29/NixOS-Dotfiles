{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.noto
    jetbrains-mono

    # Fuentes para Mandarín / CJK
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
}

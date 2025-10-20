{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    android-studio
    jetbrains.idea-community-src
    jetbrains.pycharm-community-bin
  ];
}
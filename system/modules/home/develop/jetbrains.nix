{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    jetbrains.idea-community-src
    jetbrains.pycharm-community-bin
  ];
}
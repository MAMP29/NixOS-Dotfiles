{ config, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    android-studio
    jetbrains.idea-community-src
    jetbrains.pycharm-community-bin
  ] ++ (with pkgs-unstable; [
    jetbrains.pycharm-professional
  ]);
}
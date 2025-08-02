{ config, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    android-studio
  ];
}
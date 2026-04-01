{ config, pkgs-unstable, ... }:

{
  home.packages = with pkgs-unstable; [
    vintagestory
    mangohud
    goverlay
  ];
}
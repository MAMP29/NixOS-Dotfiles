{ config, pkgs, ... }:

{
  qt = {
    enable = true;
    platformTheme = "gtk";
    style = "adwaita-dark";
  };
}
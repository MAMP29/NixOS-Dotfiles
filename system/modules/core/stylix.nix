{ config, host, pkgs, ... }: 

let
  inherit (import ../../host${host}/variables.nix) stylixImage;
in
{
  stylix = {
    enable = true;
    image = stylixImage;
    polarity = "dark";
  };
}

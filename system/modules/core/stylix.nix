{ config, host, pkgs, ... }: 

let
  inherit (import ../../host/${host}/variables.nix) stylixImage;
in
{
  stylix = {
    enable = true;
    image = stylixImage;
    polarity = "dark";

    cursor = {
      name = "Adwaita";
      size = 20;
      package = pkgs.adwaita-icon-theme;
    };

    icons = {
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Dark";
    };
    
    homeManagerIntegration = {
      autoImport = true;
    };
    targets = {
      gtk.enable = true;
    };
  };
}

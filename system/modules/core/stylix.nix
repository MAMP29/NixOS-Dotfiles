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
      theme = "Papirus-Dark"; # 'theme' es la opción correcta, no 'dark'
    };
    
    homeManagerIntegration.autoImport = true;
    targets.gtk.enable = true;
  };
}

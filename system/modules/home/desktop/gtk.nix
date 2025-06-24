{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    catppuccin-gtk
    papirus-icon-theme
    adwaita-icon-theme
  ];

  gtk = {
    enable = true;

    theme = {
      name = "Catppuccin-Mocha-Red";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "red" ];
        variant = "mocha";
      };
    };

    cursorTheme = {
      name = "Adwaita";
      size = 20;
      package = pkgs.adwaita-icon-theme;   
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.pointerCursor = {
    name = "Adwaita";
    size = 20;
    package = pkgs.adwaita-icon-theme;
    x11.enable = true; 
    gtk.enable = true;
  };

}
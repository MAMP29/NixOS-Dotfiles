{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    catppuccin-gtk
    papirus-icon-theme
    adwaita-icon-theme
  ];

  gtk = {
    enable = true;

    cursorTheme = {
      name = "Adwaita";
      size = 20;
      package = pkgs.adwaita-icon-theme;   
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  home.pointerCursor = {
    name = "Adwaita";
    size = 20;
    package = pkgs.adwaita-icon-theme;
    x11.enable = true; 
    gtk.enable = true;
  };

  # services.swayosd.enable = true;
}
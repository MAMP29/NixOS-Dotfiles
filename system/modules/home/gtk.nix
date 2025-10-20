{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    papirus-icon-theme
  ];

  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override { color = "green"; };
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # services.swayosd.enable = true;
}
{ config, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    # Componentes de la UI de Hyprland
    awww
    waypaper
    hyprpicker
    grim          # screenshots
    slurp         # seleccionar área
    grimblast
    clipse # Portapaleles tui

    # Aplicaciones GUI
    networkmanagerapplet
    blueman
  ];
}

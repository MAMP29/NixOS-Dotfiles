{ config, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [

    # Editor
    vscode

    # Terminal
    kitty

    # Navegador
    brave
    
    # Componentes de la UI de Hyprland
    rofi
    waybar
    swaynotificationcenter
    libnotify
    swww
    waypaper
    hyprpicker
    grim          # screenshots
    slurp         # seleccionar área
    wlogout
    grimblast
    clipse # Portapaleles tui

    # Aplicaciones GUI
    networkmanagerapplet
    blueman
    gnome-calculator
    obs-studio
    libreoffice-fresh
    gnome-clocks
    upscaler
    switcheroo
    handbrake

    # Herramientas de Desarrollo y CLI de Usuario
    ripgrep
    bat
  ] ++ (with pkgs-unstable; [
    mission-center
    (btop.override {
      cudaSupport = true;
    })
    nvme-cli
    eza
  ]);
}
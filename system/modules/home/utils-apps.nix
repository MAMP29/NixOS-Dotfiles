{ config, pkgs, pkgs-unstable, ... }:

{
  programs = {
    btop = {
      enable = true;
      package = pkgs.btop.override {
        cudaSupport = true;
      };
    };
    bat.enable = true;
  };

  home.packages = with pkgs; [

    # Navegador
    brave
    
    # Componentes de la UI de Hyprland
    libnotify
    swww
    waypaper
    hyprpicker
    grim          # screenshots
    slurp         # seleccionar área
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
    file-roller
    eog
    gnome-disk-utility
    nemo-with-extensions
    pavucontrol
    #tidal-hifi
    evince
    polkit_gnome # Polkit

    # Herramientas de Desarrollo y CLI de Usuario
    ripgrep
    tree
  ] ++ (with pkgs-unstable; [
    mission-center
    nvme-cli
    eza
  ]);
}
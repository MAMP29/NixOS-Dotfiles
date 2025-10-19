{ config, pkgs, ... }:

{
  programs = {
    hyprland.enable = true;
    firefox.enable = true;
    zsh.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    helix # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    kitty
    brave
    pamixer

    # Cosas de hyprland
    rofi
    waybar
    swaynotificationcenter
    libnotify
    swww
    waypaper
    hyprpicker
    grim          # screenshots
    slurp         # seleccionar área
    wl-clipboard  # portapapeles utilidad
    hyprlock
    hypridle
    wlogout
    grimblast
    clipse # Portapaleles tui

    # Audio/Video
    pavucontrol
    mpv
    playerctl

    # Redes
    networkmanagerapplet
    blueman

    # Utilidades     
    file-roller
    gnome-calculator
    eog
    obs-studio

    # Brillo - Ahora en el default del host
    # brightnessctl

    # Desarrollo
    vscode
    git

    nemo-with-extensions
    
    htop
    cudatoolkit
    bc
    tldr
    nmap

    #(lutris.override {
    #  extraPkgs = pkgs: [
    #    winetricks
    #  ];
    #})
    # wine-staging
    # mangohud
   ];
}
{ config, pkgs, ... }:

{
  programs = {
    hyprland.enable = true;
    firefox.enable = true;
    zsh.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Sistema
    helix # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    cudatoolkit
    htop
    
     # Utilidades de Bajo Nivel
    pamixer
    wl-clipboard  # portapapeles
    playerctl

    # Multimedia
    ffmpeg
    mpv
    pavucontrol

    # Utilidades
    nmap
    bc
    tldr

    # Utilidades GUI
    file-roller
    eog
    gnome-disk-utility

    # Cosas de hyprland
    hyprlock # Necesita interactuar con systemd/logind para bloquear la sesión correctamente.
    hypridle # Demonio de inactividad que se ejecuta a nivel de sistema/sesión.

    # Navegador de archivos
    nemo-with-extensions
   ];
}



    #(lutris.override {
    #  extraPkgs = pkgs: [
    #    winetricks
    #  ];
    #})
    # wine-staging
    # mangohud
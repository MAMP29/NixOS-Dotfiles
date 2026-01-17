{ config, pkgs, ... }:

{
  programs = {
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

    # Utilidades
    nmap
    bc
    tldr

/*     # Cosas de hyprland
    hypridle # Demonio de inactividad que se ejecuta a nivel de sistema/sesión.
     */
   ];
}



    #(lutris.override {
    #  extraPkgs = pkgs: [
    #    winetricks
    #  ];
    #})
    # wine-staging
    # mangohud
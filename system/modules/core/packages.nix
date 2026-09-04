{ pkgs, ... }:

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
    wl-clipboard # portapapeles
    playerctl

    # Multimedia
    ffmpeg
    mpv

    # Utilidades
    nmap
    bc
    tldr

    # Juegos
    heroic
  ];
}

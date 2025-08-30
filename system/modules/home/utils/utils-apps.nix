{ config, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    libreoffice-fresh
    gnome-disk-utility
    gnome-clocks
    upscaler
    switcheroo
    handbrake
    ffmpeg
    ripgrep
    bat
  ] ++ (with pkgs-unstable; [
    mission-center
    (btop.override {
      cudaSupport = true;
    })
    gnome-frog
    nvme-cli
    eza
  ]);
}
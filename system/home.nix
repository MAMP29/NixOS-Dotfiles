
{ config, pkgs, ... }:

{
  home.username = "mamp";
  home.homeDirectory = "/home/mamp";
  home.stateVersion = "25.05";

  imports = [
    ./modules/home/develop/git.nix
    ./modules/home/develop/zsh.nix
    ./modules/home/desktop/gtk.nix
    ./modules/home/desktop/qt.nix
  ];

}

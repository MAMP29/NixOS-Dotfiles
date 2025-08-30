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
    ./modules/home/desktop/xdg.nix
    ./modules/home/develop/jetbrains.nix    
    ./modules/home/develop/direnv.nix
    ./modules/home/develop/minizinc.nix
    ./modules/home/develop/android.nix
    ./modules/home/develop/packet-tracer.nix
    ./modules/home/utils/utils-apps.nix
    ./modules/home/utils/emacs.nix
  # ./modules/home/utils/blender.nix
  ];

}

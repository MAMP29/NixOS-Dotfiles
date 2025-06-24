
{ config, pkgs, ... }:

{
  home.username = "mamp";
  home.homeDirectory = "/home/mamp";
  home.stateVersion = "25.05";

  imports = [
    ./modules/home/develop/git.nix
  ];


  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    shellAliases = {
      btw = "echo i use nixos btw";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
  };

  programs.oh-my-posh = {
    enable = true;
    useTheme = "powerlevel10k_rainbow";
    enableZshIntegration = true;    
  };
}

{ config, pkgs, ... }:

{
  programs.zsh = {
  enable = true;
  syntaxHighlighting.enable = true;
  autosuggestion.enable = true;
  autosuggestion.highlight = "fg=#a0b0c0,italic";
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
    useTheme = "atomic";
    enableZshIntegration = true;    
  };
}
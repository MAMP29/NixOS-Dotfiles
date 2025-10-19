{ config, host, pkgs, ... }:
let
  inherit (import ../../../host/an515-58/variables.nix) gitUserName gitEmail;
{
  programs.git = {
    enable = true;
    userName = "${gitUserName}";
    userEmail = "${gitEmail}";
       
    extraConfig = {
      init.defaultBranch = "main";
    };

    aliases = {
      st = "status";
      cm = "commit --message";
    };
  }; 
}

{ config, host, pkgs, ... }:

let
  inherit (import ../../host/${host}/variables.nix) gitUserName gitEmail;
in
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
      co = "checkout";
    };
  }; 
}

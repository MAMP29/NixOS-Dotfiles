{ config, host, pkgs, ... }:

let
  inherit (import ../../host/${host}/variables.nix) gitUserName gitEmail;
in
{
  programs.git = {
    enable = true;
    
    settings = {
      user = {
        name = "${gitUserName}";
        email = "${gitEmail}";
      };

      init = {
        defaultBranch = "main";
      };

      alias = {
        st = "status";
        cm = "commit --message";
        co = "checkout";
      };
    };
  }; 
}
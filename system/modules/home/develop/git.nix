{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "MAMP29";
    userEmail = "106500061+MAMP29@users.noreply.github.com";
       
    extraConfig = {
      init.defaultBranch = "main";
    };

    aliases = {
      st = "status";
      cm = "commit --message";
    };
  }; 
}

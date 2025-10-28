{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles = {
      default = {
        extensions = with.vscode-extensions; [
          vscode-icons-team.vscode-icons
          ritwickdey.liveserver
          jnoortheen.nix-ide
          mads-hartmann.bash-ide-vscode
          zainchen.json
          redhat.vscode-xml
        ];

        userSettings = {
          "workbench.iconTheme" = "vscode-icons";
          "extensions.autoCheckUpdates" = false;
          "extensions.autoUpdate" = false;
          "terminal.integrated.fontFamily": "FiraCode Nerd Font";
        };
      };
    };
  };
}
{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles = {
      default = {
        extensions = with pkgs.vscode-extensions; [
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
          "terminal.integrated.fontFamily" = "FiraCode Nerd Font";
        };
      };
    };
  };

  home.file.".vscode/argv.json" = {
    force = true; # Para asegurar que sobrescriba cualquier cambio manual del IDE
    text = ''
      {
        "enable-crash-reporter": true,
        "crash-reporter-id": "c93a0a9e-2861-4c1a-bda5-7cff36314259",
        "password-store": "gnome"
      }
    '';
  };
}
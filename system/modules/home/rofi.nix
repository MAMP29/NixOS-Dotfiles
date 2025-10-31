{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland; 

    extraConfig = {
      modi = "drun,run,filebrowser";
      show-icons = true;
      display-drun = " ";
      display-run = " ";
      display-filebrowser = "  ";
      drun-display-format = "{name}";
      window-format = "{w}   {c}   {t}";
      font = "JetBrains Mono Nerd Font 10";
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        background = mkLiteral "#${config.stylix.base16Scheme.base00}";      # Base00
        background-alt = mkLiteral "#${config.stylix.base16Scheme.base01}";  # Base01
        foreground = mkLiteral "#${config.stylix.base16Scheme.base05}";      # Base05
        selected = mkLiteral "#${config.stylix.base16Scheme.base02}";        # Base02
        active = mkLiteral "#${config.stylix.base16Scheme.base0D}";          # Base0D
        urgent = mkLiteral "#${config.stylix.base16Scheme.base0E}";          # Base0E
        border-color = mkLiteral "#${config.stylix.base16Scheme.base03}";    # Base03
        text-primary = mkLiteral "#${config.stylix.base16Scheme.base05}";    # Base05
        text-secondary = mkLiteral "#${config.stylix.base16Scheme.base04}";  # Base04
      };
      
      "window" = {
        transparency = "real";
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        fullscreen = false;
        width = mkLiteral "650px";
        height = mkLiteral "700px";
        x-offset = mkLiteral "0px";
        y-offset = mkLiteral "0px";
        enabled = true;
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border-radius = mkLiteral "16px";
        cursor = "default";
        background-color = mkLiteral "transparent";
      };

      "mainbox" = {
        enabled = true;
        spacing = mkLiteral "15px";
        padding = mkLiteral "30px";
        background-color = mkLiteral "transparent";
        children = map mkLiteral [ "inputbar" "listview" ];
      };

      "inputbar" = {
        enabled = true;
        spacing = mkLiteral "10px";
        margin = mkLiteral "0px";
        padding = mkLiteral "35px";
        border = mkLiteral "2px solid";
        border-radius = mkLiteral "16px";
        border-color = mkLiteral "@border-color";
        background-color = mkLiteral "@background";
        background-image = mkLiteral ''url("${config.stylix.image}", width)'';
        children = map mkLiteral [ "textbox-prompt-colon" "entry" "mode-switcher" ];
      };

      "textbox-prompt-colon" = {
        enabled = true;
        expand = false;
        padding = mkLiteral "12px";
        border-radius = mkLiteral "100%";
        background-color = mkLiteral "@selected";
        text-color = mkLiteral "@text-primary";
        str = " ";
      };

      "entry" = {
        enabled = true;
        padding = mkLiteral "10px 14px";
        border-radius = mkLiteral "100%";
        background-color = mkLiteral "rgba(0, 0, 0, 0.20)";
        text-color = mkLiteral "@text-primary";
        cursor = mkLiteral "text";
        placeholder = "Search...";
        placeholder-color = mkLiteral "@text-secondary";
      };

      "mode-switcher" = {
        enabled = true;
        spacing = mkLiteral "10px";
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px";
        background-color = mkLiteral "transparent";
      };

      "button" = {
        width = mkLiteral "45px";
        padding = mkLiteral "8px";
        border-radius = mkLiteral "100%";
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "@text-secondary";
        cursor = "pointer";
      };

      "button selected" = {
        background-color = mkLiteral "@selected";
        text-color = mkLiteral "@text-primary";
      };

      "listview" = {
        enabled = true;
        columns = 1;
        lines = 7;
        cycle = true;
        dynamic = true;
        scrollbar = false;
        layout = mkLiteral "vertical";
        reverse = false;
        fixed-height = true;
        fixed-columns = true;
        spacing = mkLiteral "8px";
        margin = mkLiteral "0px";
        padding = mkLiteral "15px";
        border = mkLiteral "2px solid";
        border-radius = mkLiteral "16px";
        border-color = mkLiteral "@border-color";
        background-color = mkLiteral "@background";
        cursor = "default";
      };

      "element" = {
        enabled = true;
        spacing = mkLiteral "12px";
        margin = mkLiteral "0px";
        padding = mkLiteral "12px 14px";
        border = mkLiteral "0px";
        border-radius = mkLiteral "12px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@text-primary";
        cursor = mkLiteral "pointer";
      };

      "element normal.normal" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@text-primary";
      };
      
      "element alternate.normal" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@text-primary";
      };

      "element selected.normal" = {
        background-color = mkLiteral "@selected";
        text-color = mkLiteral "@text-primary";
      };

      "element-icon" = {
        background-color = mkLiteral "transparent";
        size = mkLiteral "28px";
        cursor = mkLiteral "inherit";
      };

      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };

      "error-message" = {
        padding = mkLiteral "20px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground";
      };

      "message" = {
        padding = mkLiteral "0px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@urgent";
      };

      "textbox" = {
        padding = mkLiteral "12px";
        border = mkLiteral "2px solid";
        border-radius = mkLiteral "12px";
        border-color = mkLiteral "@border-color";
        background-color = mkLiteral "@background";
        text-color = mkLiteral "@foreground";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };
    };
  };
}
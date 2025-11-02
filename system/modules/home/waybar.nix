{ config, pkgs, ... }: {
  programs.waybar = {
    enable = true;
    systemd.target = "niri.service";
    settings = {
      # --- Configuración Principal de la Barra ---
      mainBar = {
        layer = "top";
        position = "top";
        height = 38;
        spacing = 0;
        width = 1250;
        "margin-top" = 3;

        # --- Distribución de Módulos ---
        "modules-left" = [
          "custom/icon"
          "niri/workspaces#roman"
          "network"
          "battery"
          "custom/swaync"
          "tray"
        ];
        "modules-center" = [ "clock" ];
        "modules-right" = [
          "pulseaudio"
          "pulseaudio#microphone"
          "memory"
          "cpu"
          "mpris"
        ];
        
        # --- Definiciones de Módulos ---

        "hyprland/window" = {
          format = "  {}";
          "separate-outputs" = true;
        };

        "niri/workspaces#roman" = {
          format = "{icon}";
          "all-outputs"= true;
          "on-click" = "activate";
          "format-icons" = {
            "1" = "I";
            "2" = "II";
            "3" = "III";
            "4" = "IV";
            "5" = "V";
            "6" = "VI";
            "7" = "VII";
            "8" = "VIII";
            "9" = "IX";
            "10" = "X";
          };
        };

 /*       "hyprland/workspaces#roman" = {
          "active-only" = false;
          "all-outputs" = true;
          format = "{icon}";
          "show-special" = false;
          "on-click" = "activate";
          "on-scroll-up" = "hyprctl dispatch workspace e+1";
          "on-scroll-down" = "hyprctl dispatch workspace e-1";
          "persistent-workspaces" = {
            "*" = 5;
          };
          "format-icons" = {
            "1" = "I";
            "2" = "II";
            "3" = "III";
            "4" = "IV";
            "5" = "V";
            "6" = "VI";
            "7" = "VII";
            "8" = "VIII";
            "9" = "IX";
            "10" = "X";
          };
        };*/

        "custom/separator" = {
          format = "|";
          rotate = 0;
        };

        "custom/icon" = {
          format = "󱄅";
          rotate = 0;
        };

        "tray" = {
          "icon-size" = 15;
          spacing = 10;
        };

        "clock" = {
          format = "{:%b | %d | %H:%M}";
          tooltip = true;
          "tooltip-format" = "{calendar}";
          calendar = {
            mode = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            format = {
              # Colores dinámicos tomados de tu configuración de Stylix
              months = "<span color='#${config.stylix.base16Scheme.base0D}'><b>{}</b></span>";      # Base0D
              days = "<span color='#${config.stylix.base16Scheme.base05}'><b>{}</b></span>";          # Base05
              weeks = "<span color='#${config.stylix.base16Scheme.base0C}'><b>W{}</b></span>";       # Base0C
              weekdays = "<span color='#${config.stylix.base16Scheme.base0A}'><b>{}</b></span>";    # Base0A
              today = "<span color='#${config.stylix.base16Scheme.base0E}'><b><u>{}</u></b></span>"; # Base0E
            };
          };
        };

        "mpris" = {
          format = "{player_icon} {title}";
          "max-length" = 22;
          "format-paused" = "󰏤 <i>{title}</i>";
          "player-icons" = { "default" = ""; };
          "status-icons" = { "paused" = "󰏤"; };
          "ignored-players" = [ "firefox" "brave" ];
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          "format-charging" = "󰂄 {capacity}%";
          "format-plugged" = "󰂄 {capacity}%";
          "format-alt" = "{time} {icon}";
          "format-icons" = [ "󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };

        "pulseaudio" = {
          format = "{icon}  {volume}%";
          tooltip = false;
          "format-muted" = "  Muted";
          "on-click" = "pamixer -t";
          "on-scroll-up" = "pamixer -i 1";
          "on-scroll-down" = "pamixer -d 1";
          "scroll-step" = 5;
          "format-icons" = {
            headphone = "";
            "hands-free" = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" "" ];
          };
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          "format-source" = " {volume}%";
          "format-source-muted" = "  Muted";
          "on-click" = "pamixer --default-source -t";
          "on-scroll-up" = "pamixer --default-source -i 5";
          "on-scroll-down" = "pamixer --default-source -d 5";
          "scroll-step" = 5;
        };

        "memory" = {
          interval = 10;
          format = "󰾆 {used:0.1f}G";
        };

        "cpu" = {
          interval = 10;
          format = "󰍛 {usage}%";
        };

        "network" = {
          "format-wifi" = "";
          "format-ethernet" = "󰈀";
          "format-disconnected" = "󰖪";
          "tooltip-format-disconnected" = "Desconectado";
          "tooltip-format-wifi" = "Conectado a: {essid}";
          "on-click" = "nm-connection-editor";
        };

        "custom/swaync" = {
          tooltip = true;
          "tooltip-format" = "Left Click: Launch Notification Center\nRight Click: Do not Disturb";
          format = "{icon} {text}"; # Indexación automatica no soportada en nuevas versiones, agregado para cuando actualice paquetes
          "format-icons" = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            "dnd-notification" = "󰂛<span foreground='red'><sup></sup></span>";
            "dnd-none" = "󰂛";
            "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            "inhibited-none" = "";
            "dnd-inhibited-notification" = "󰂛<span foreground='red'><sup></sup></span>";
            "dnd-inhibited-none" = "󰂛";
          };
          "return-type" = "json";
          "exec-if" = "which swaync-client";
          exec = "swaync-client -swb";
          "on-click" = "sleep 0.1 && swaync-client -t -sw";
          "on-click-right" = "swaync-client -d -sw";
          escape = true;
        };
      };
    };

    style = ''
      
      /* --- Variables de Color Dinámicas --- */
      @define-color background #${config.stylix.base16Scheme.base00};
      @define-color foreground #${config.stylix.base16Scheme.base05};
      @define-color border #${config.stylix.base16Scheme.base02};
      @define-color color1 #${config.stylix.base16Scheme.base01};
      @define-color color2 #${config.stylix.base16Scheme.base02};
      @define-color color3 #${config.stylix.base16Scheme.base03};
      @define-color color4 #${config.stylix.base16Scheme.base04};
      @define-color color5 #${config.stylix.base16Scheme.base05};
      @define-color color6 #${config.stylix.base16Scheme.base06};
      @define-color color7 #${config.stylix.base16Scheme.base07};
      @define-color color8 #${config.stylix.base16Scheme.base08};
      @define-color color9 #${config.stylix.base16Scheme.base09};
      @define-color color10 #${config.stylix.base16Scheme.base0A};
      @define-color color11 #${config.stylix.base16Scheme.base0B};
      @define-color color12 #${config.stylix.base16Scheme.base0C};
      @define-color color13 #${config.stylix.base16Scheme.base0D};
      @define-color color14 #${config.stylix.base16Scheme.base0E};
      @define-color color15 #${config.stylix.base16Scheme.base0F};

      /* --- Estilos Globales --- */
      * {
          border: none;
          border-radius: 0;
          font-family: JetBrainsMono Nerd Font, monospace;
          font-weight: bold;
          font-size: 14px;
          min-height: 0;
      }

      window#waybar {
          background: rgba(0, 0, 0, 1);
          color: #cdd6f4;
      }

      /* --- Estilo Base para Módulos --- */
      #workspaces, #network, #battery, #bluetooth, #tray, #custom-separator,
      #custom-swaync, #custom-icon, #clock, #mpris, #pulseaudio, #memory, #cpu {
          background-color: #000000;
          padding: 0 10px;
          margin: 5px 0;
          color: #ffffff;
          transition: all 0.3s ease;
      }

      /* --- Grupos y Extremos de la Barra --- */
      #workspaces {
          border-radius: 0px 0 0 0px;
          padding-left: 15px;
      }
      
      #mpris { /* El último módulo a la derecha */
          border-radius: 0 0px 0px 0;
          padding-right: 15px;
      }

      #custom-icon {
          color: #ffffff;
          margin: 5px 0px;
          font-size: 18px;
      }

      /* --- Estilos Específicos por Módulo --- */
      #workspaces button {
          padding: 0 5px;
          color: @color13; /* Color dinámico para workspaces inactivos */
      }

      #workspaces button:hover {
          color: #cdd6f4;
          background-color: rgba(0, 0, 0, 0.2);
          border-radius: 10px;
      }

      #workspaces button.active {
          color: @foreground; /* Color dinámico para el workspace activo */
          font-size: 18px;
      }
      
      #workspaces button.empty {
          color: #545764;
      }
      
      #workspaces button.empty:hover {
          color: @color4; /* Color dinámico */
      }
      
      #workspaces button.urgent {
          color: #11111b;
          background: #313244;
      }

      #tray {
          padding: 0 12px;
      }

      #clock {
          font-weight: bold;
          color: #ffffff;
          border-radius: 0px;
      }
      
      #mpris {
          color: @foreground; /* Color dinámico */
      }

      #battery.critical {
          color: #f38ba8;
          animation: blink 1.5s linear infinite;
      }

      @keyframes blink {
          50% { opacity: 0.2; }
      }

      /* --- Efecto Hover General --- */
      #network:hover, #battery:hover, #pulseaudio:hover, #memory:hover, #cpu:hover {
          background-color: #313244;
      }
    '';
  };
}
{ config, ... }:

{
  programs.wlogout = {
    enable = true;
    layout = [
      {
          "label" : "lock",
          "action" : "loginctl lock-session",
          "text" : "Lock",
          "keybind" : "l"
      }
      {
          "label" : "reboot",
          "action" : "systemctl reboot",
          "text" : "Reboot",
          "keybind" : "r"
      }
      {
          "label" : "shutdown",
          "action" : "systemctl poweroff",
          "text" : "Shutdown",
          "keybind" : "s"
      }
      {
          "label" : "logout",
          "action" : "hyprctl dispatch exit || pkill Hyprland || loginctl terminate-user $USER",
          "text" : "Logout",
          "keybind" : "e"
      }
      {
          "label" : "suspend",
          "action" : "systemctl suspend",
          "text" : "Suspend",
          "keybind" : "u"
      }
      {
          "label" : "hibernate",
          "action" : "systemctl hibernate",
          "text" : "Hibernate",
          "keybind" : "h"
      }
    ];

    style = ''
      window {
          font-family: 'JetBrains Mono', 'Symbols Nerd Font';
          font-size: 18pt;
          color: #${config.lib.stylix.colors.base05};
          background-color: rgba(26, 28, 25, 0.85);
          border-radius: 15px;
      }

      button {
          background-repeat: no-repeat;
          background-position: center;
          background-size: 40%;
          background-color: transparent;
          border: none;
          border-radius: 12px;
          background-size: 25%;
          margin: 10px;
          transition: all 0.3s ease;
          outline-style: none;
      }

      button:focus {
          background-color: #${config.lib.stylix.colors.base02};
      }

      button:hover {
          background-color: #${config.lib.stylix.colors.base01};
          color: #${config.lib.stylix.colors.base04};
          background-size: 35%;
      }

      button:active {
          background-color: #${config.lib.stylix.colors.base03};
      }

      #lock {
          background-image: image(url("./icons/lock.png"));
      }
      #lock:hover {
          background-image: image(url("./icons/lock-hover.png"));
      }

      #logout {
          background-image: image(url("./icons/logout.png"));
      }
      #logout:hover {
          background-image: image(url("./icons/logout-hover.png"));
      }

      #suspend {
          background-image: image(url("./icons/sleep.png"));
      }
      #suspend:hover {
          background-image: image(url("./icons/sleep-hover.png"));
      }

      #shutdown {
          background-image: image(url("./icons/power.png"));
      }
      #shutdown:hover {
          background-image: image(url("./icons/power-hover.png"));
      }

      #reboot {
          background-image: image(url("./icons/restart.png"));
      }
      #reboot:hover {
          background-image: image(url("./icons/restart-hover.png"));
      }

      #hibernate {
          background-image: image(url("./icons/hibernate.png"));
      }
      #hibernate:hover {
          background-image: image(url("./icons/hibernate-hover.png"));
      }
    '';
  };
  home.file.".config/wlogout/icons" = {
    source = ./icons;
    recursive = true;
  };
}

{ ... }: 
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        # 1) Atenuar brillo después de 2 minutos
        {
          timeout = 120;
          on-timeout = "brightnessctl -s set 5";
          on-resume = "brightnessctl -r";
        }

        # 2) Bloquear después de 3 minutos
        {
          timeout = 180;
          on-timeout = "loginctl lock-session";
        }

        # 3) Apagar pantallas después de 5 minutos
        {
          timeout = 300;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        # 4) Suspender después de 10 minutos
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}

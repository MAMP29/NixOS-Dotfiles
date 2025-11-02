{ pkgs, ... }: 

{
  services.hypridle = {
    enable = true;
    settings = {
      # --- Bloque General ---
      general = {
        lock_cmd = "pidof hyprlock || niri msg action do-screen-transition && hyprlock";
        before_sleep_cmd = "loginctl lock-session";
      };

      # --- Bloque de Listeners ---
      listener = [
        # Listener 1: Atenuar el brillo después de 2 minutos.
        {
          timeout = 120;
          on-timeout = "brightnessctl -s set 5";
          on-resume = "brightnessctl -r";
        }
        # Listener 2: Bloquear la pantalla después de 3 minutos.
        {
          timeout = 180;
          on-timeout = "loginctl lock-session";
        }
        # Listener 3: Apagar las pantallas después de 5 minutos.
        {
          timeout = 300;
          on-timeout = "niri msg action set-dpms-off";
          on-resume = "niri msg action set-dpms-on";
        }
        # Listener 4: Suspender el sistema después de 10 minutos.
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
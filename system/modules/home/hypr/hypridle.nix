{ pkgs, ... }: 

{
  services.hypridle = {
    enable = false;
    settings = {
      # --- Bloque General ---
      general = {
        lock_cmd = ''${pkgs.procps}/bin/pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock'';
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      };

      # --- Bloque de Listeners ---
      listener = [
        # Listener 1: Atenuar el brillo después de 2 minutos.
        {
          timeout = 120;
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 5";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }
        # Listener 2: Bloquear la pantalla después de 3 minutos.
        {
          timeout = 180;
          on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
        }
        # Listener 3: Apagar las pantallas después de 5 minutos.
        {
          timeout = 300;
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
        # Listener 4: Suspender el sistema después de 10 minutos.
        {
          timeout = 600;
          on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
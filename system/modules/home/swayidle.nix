{ pkgs, ... }:
  
let
  # --- Definición de Tiempos ---
  seconds = 1;
  minutes = 60 * seconds;

  attenuate_timeout = 2 * minutes;      # 2 minutos para atenuar
  lock_timeout = 3 * minutes;           # 3 minutos para bloquear
  screen_off_timeout = 5 * minutes;     # 5 minutos para apagar la pantalla
  suspend_timeout = 10 * minutes;       # 10 minutos para suspender

    # --- Script de Bloqueo Personalizado ---.
  lock-script = pkgs.writeShellApplication {
    name = "lock-script";
    runtimeInputs = with pkgs; [
      hyprlock
      playerctl
      procps
      #bitwarden-cli # Dependencia para el bloqueo opcional de Bitwarden
    ];
    text = ''
      # 1. Evita iniciar múltiples instancias de hyprlock
      if pidof hyprlock; then
          exit 0
      fi

      # 2. Pausa cualquier reproducción de medios (música, YouTube, etc.)
      # El '2>/dev/null || true' evita que el script falle si no hay nada que pausar.
      playerctl pause 2>/dev/null || true

      # 3. (Opcional) Bloquea Bitwarden si se está ejecutando
      # if pgrep bitwarden; then
      #   bw lock
      # fi

      # 4. Finalmente, ejecuta el bloqueador de pantalla
      hyprlock
    '';
  };

in {
  # script añadido al PATH del usuario
  home.packages = [ lock-script ];

  services.swayidle = {
    enable = false;
    # Esto asegura que swayidle se inicie junto con la sesión de Niri.
    systemdTarget = "niri.service";

    # --- Eventos del Sistema ---
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        event = "lock";
        command = "${lock-script}/bin/lock-script";
      }
    ];

    # --- Temporizadores de Inactividad ---
    timeouts = [
      # 2 minutos: Atenuar brillo
      {
        timeout = attenuate_timeout;
        command = "${pkgs.brightnessctl}/bin/brightnessctl -s set 5";
        resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -r";
      }
      # 3 minutos: Disparar el evento de bloqueo
      {
        timeout = lock_timeout;
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      # 5 minutos: Apagar las pantallas
      {
        timeout = screen_off_timeout;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
      # 10 minutos: Suspender el sistema
      {
        timeout = suspend_timeout;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };
}
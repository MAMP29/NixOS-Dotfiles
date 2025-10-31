{ config, pkgs, ... }: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 1;
        fractional_scaling = 2;
        immediate_render = true;
      };

      background = [{
        monitor = "";
        path = "screenshot"; # Usa una captura de pantalla como fondo
        color = "rgb(0,0,0)";

        # --- Efectos de Desenfoque y Visuales ---
        blur_size = 3;
        blur_passes = 2;
        noise = 0.0117;
        contrast = 1.3000;
        brightness = 0.8000;
        vibrancy = 0.2100;
        vibrancy_darkness = 0.0;
      }];

      label = [
        # --- Etiqueta: Fecha ---
        {
          monitor = "";
          text = ''cmd[update:18000000] echo "<b> "$(date +'%A, %-d %B')" </b>"'';
          color = "rgb(${config.stylix.base16Scheme.base05})"; # Base 5
          font_size = 16;
          font_family = "Victor Mono Bold Italic";
          position = "0, -120";
          halign = "center";
          valign = "center";
        }
        # --- Etiqueta: Hora ---
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%H")"'';
          color = "rgb(${config.stylix.base16Scheme.base05})"; # Base 5
          font_size = 200;
          font_family = "JetBrainsMono Nerd Font ExtraBold";
          position = "0, -60";
          halign = "center";
          valign = "top";
        }
        # --- Etiqueta: Minutos ---
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%M")"'';
          color = "rgb(${config.stylix.base16Scheme.base08})"; # Base 8
          font_size = 200;
          font_family = "JetBrainsMono Nerd Font ExtraBold";
          position = "0, -340";
          halign = "center";
          valign = "top";
        }
        # --- Etiqueta: Usuario ---
        {
          monitor = "";
          text = "  $USER";
          color = "rgb(${config.stylix.base16Scheme.base05})"; # Base 5
          font_size = 24;
          font_family = "Victor Mono Bold Oblique";
          position = "0, 220";
          halign = "center";
          valign = "bottom";
        }
        # --- Etiqueta: Distribución del Teclado ---
        {
          monitor = "";
          text = "$LAYOUT";
          color = "rgb(${config.stylix.base16Scheme.base05})"; # Base 5
          font_size = 10;
          font_family = "Victor Mono Bold Oblique";
          position = "0, 70";
          halign = "center";
          valign = "bottom";
        }
      ];

      input-field = [{
        monitor = "";
        size = "200, 60";
        outline_thickness = 2;
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        outer_color = "rgb(${config.stylix.base16Scheme.base04})"; # Base 4
        inner_color = "rgba(255, 255, 255, 0.1)";
        capslock_color = "rgb(255,255,255)";
        font_color = "rgb(${config.stylix.base16Scheme.base05})"; # Base 5
        fade_on_empty = false;
        font_family = "Victor Mono Bold Oblique";
        placeholder_text = ''<i><span foreground="##ffffff99">🔒 Type Password</span></i>'';
        hide_input = false;
        position = "0, 100";
        halign = "center";
        valign = "bottom";
      }];
    };
  };
}
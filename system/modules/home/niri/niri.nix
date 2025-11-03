{ lib, config, pkgs, ... }:

{

    home.packages = with pkgs; [
        polkit_gnome
        (writeShellScriptBin "niri-color-picker" ''
        niri msg pick-color | awk '$1 == "Hex:" { printf "%s", $2 }' | wl-copy
        '')
        (writeShellScriptBin "manage-volume" ''
            # Tomado y adaptado directamente de ArchRiot, todos mis agradecimientos para CyphrRiot: https://github.com/CyphrRiot/ArchRiot/tree/master

            # Function to send notifications
            notify() {
                local title="$1"
                local message="$2"
                local icon="$3"
                local volume=$(pamixer --get-volume)

                # -h int:value:$volume       -> Para que swaync pueda mostrar una barra de progreso.
                # -h string:x-canonical-private-synchronous:volume -> Un hint común para notificaciones que se actualizan.
                # --replace-id=8888          -> El ID para reemplazar.
                notify-send "Volume Control" "$message" \
                    --app-name="volume-control" \
                    --icon="$icon" \
                    --replace-id=8888 \
                    -h int:value:"$volume" \
                    -h string:x-canonical-private-synchronous:volume \
                    -t 1200
            }

            # Function to get microphone status
            get_mic_status() {
                if pamixer --default-source --get-mute &> /dev/null; then
                    local is_muted=$(pamixer --default-source --get-mute)
                    local volume=$(pamixer --default-source --get-volume)

                    if [ "$is_muted" = "true" ]; then
                        echo "Microphone: Muted"
                    else
                        echo "Microphone: ''${volume}%"
                    fi
                else
                    echo "Microphone: Error"
                fi
            }

            # Function to get speaker status
            get_speaker_status() {
                if pamixer --get-mute &> /dev/null; then
                    local is_muted=$(pamixer --get-mute)
                    local volume=$(pamixer --get-volume)

                    if [ "$is_muted" = "true" ]; then
                        echo "Speaker: Muted"
                    else
                        echo "Speaker: ''${volume}%"
                    fi
                else
                    echo "Speaker: Error"
                fi
            }

            # Main script logic
            case "$1" in
                --toggle-mic)
                    if pamixer --default-source --toggle-mute; then
                        status=$(get_mic_status)
                        if pamixer --default-source --get-mute | grep -q "true"; then
                            notify "Microphone Muted" "$status" "microphone-sensitivity-muted"
                        else
                            notify "Microphone Unmuted" "$status" "microphone-sensitivity-high"
                        fi
                    else
                        notify "Error" "Failed to toggle microphone" "dialog-error"
                    fi
                    ;;

                --mic-inc)
                    if pamixer --default-source --increase 5; then
                        status=$(get_mic_status)
                        notify "Microphone Volume" "$status" "microphone-sensitivity-high"
                    else
                        notify "Error" "Failed to increase microphone volume" "dialog-error"
                    fi
                    ;;

                --mic-dec)
                    if pamixer --default-source --decrease 5; then
                        status=$(get_mic_status)
                        notify "Microphone Volume" "$status" "microphone-sensitivity-low"
                    else
                        notify "Error" "Failed to decrease microphone volume" "dialog-error"
                    fi
                    ;;

                --toggle)
                    if pamixer --toggle-mute; then
                        status=$(get_speaker_status)
                        if pamixer --get-mute | grep -q "true"; then
                            notify "Audio Muted" "$status" "audio-volume-muted"
                        else
                            notify "Audio Unmuted" "$status" "audio-volume-high"
                        fi
                    else
                        notify "Error" "Failed to toggle audio" "dialog-error"
                    fi
                    ;;

                --inc)
                    if pamixer --increase 5; then
                        status=$(get_speaker_status)
                        notify "Volume Up" "$status" "audio-volume-high"
                    else
                        notify "Error" "Failed to increase volume" "dialog-error"
                    fi
                    ;;

                --dec)
                    if pamixer --decrease 5; then
                        status=$(get_speaker_status)
                        notify "Volume Down" "$status" "audio-volume-low"
                    else
                        notify "Error" "Failed to decrease volume" "dialog-error"
                    fi
                    ;;

                --get-mic)
                    get_mic_status
                    ;;

                --get-speaker)
                    get_speaker_status
                    ;;

                *)
                    echo "Usage: $0 [OPTION]"
                    echo "Options:"
                    echo "  --toggle-mic    Toggle microphone mute"
                    echo "  --mic-inc       Increase microphone volume by 5%"
                    echo "  --mic-dec       Decrease microphone volume by 5%"
                    echo "  --toggle        Toggle speaker mute"
                    echo "  --inc           Increase speaker volume by 5%"
                    echo "  --dec           Decrease speaker volume by 5%"
                    echo "  --get-mic       Get microphone status"
                    echo "  --get-speaker   Get speaker status"
                    exit 1
                    ;;
            esac

            exit 0
        '')
        (writeShellScriptBin "manage-brightness" ''
            # Tomado y adaptado directamente de ArchRiot, todos mis agradecimientos para CyphrRiot: https://github.com/CyphrRiot/ArchRiot/tree/master

            notify() {
                local title="$1"
                local message="$2"
                local icon="$3"
                local brightness=$(get_brightness)

                notify-send "Brightness Control" "$message" \
                    --app-name="brightness-control" \
                    --icon="$icon" \
                    --replace-id=9999 \
                    -h int:value:"$brightness" \
                    -h string:x-canonical-private-synchronous:brightness \
                    -t 1200
            }

            # Function to get current brightness percentage
            get_brightness() {
                if command -v brightnessctl &> /dev/null; then
                    brightnessctl -m | cut -d, -f4 | tr -d '%'
                else
                    echo "0"
                fi
            }

            # Function to get brightness icon based on level
            get_brightness_icon() {
                local brightness="$1"

                if [ "$brightness" -ge 66 ]; then
                    echo "display-brightness-high-symbolic"
                elif [ "$brightness" -ge 33 ]; then
                    echo "display-brightness-medium-symbolic"
                elif [ "$brightness" -gt 0 ]; then
                    echo "display-brightness-low-symbolic"
                else
                    # Cuando el brillo es 0
                    echo "display-brightness-off-symbolic"
                fi
            }

            # Main brightness control function
            control_brightness() {
                local action="$1"
                local current_brightness
                local new_brightness
                local icon

                case "$action" in
                    --up)
                        if command -v brightnessctl &> /dev/null; then
                            brightnessctl set 5%+ > /dev/null
                            new_brightness=$(get_brightness)
                            icon=$(get_brightness_icon "$new_brightness")
                            notify "Brightness" "''${new_brightness}%" "$icon"
                        fi
                        ;;
                    --down)
                        if command -v brightnessctl &> /dev/null; then
                            brightnessctl set 5%- > /dev/null
                            new_brightness=$(get_brightness)
                            icon=$(get_brightness_icon "$new_brightness")
                            notify "Brightness" "''${new_brightness}%" "$icon"
                        fi
                        ;;
                    --set)
                        local value="$2"
                        if [[ -n "$value" && "$value" =~ ^[0-9]+$ ]]; then
                            if command -v brightnessctl &> /dev/null; then
                                brightnessctl set "''${value}%" > /dev/null
                                new_brightness=$(get_brightness)
                                icon=$(get_brightness_icon "$new_brightness")
                                notify "Brightness" "''${new_brightness}%" "$icon"
                            fi
                        else
                            echo "Error: Invalid brightness value. Use a number between 0-100."
                            exit 1
                        fi
                        ;;
                    --get)
                        get_brightness
                        ;;
                    *)
                        echo "Usage: $0 {--up|--down|--set <value>|--get}"
                        echo "  --up      Increase brightness by 5%"
                        echo "  --down    Decrease brightness by 5%"
                        echo "  --set <n> Set brightness to n% (0-100)"
                        echo "  --get     Get current brightness percentage"
                        exit 1
                        ;;
                esac
            }

            # Check if brightnessctl is installed
            if ! command -v brightnessctl &> /dev/null; then
                notify "Brightness Error" "brightnessctl not found" "dialog-error"
                echo "Error: brightnessctl is not installed"
                exit 1
            fi

            # Main execution
            control_brightness "$@"
        '')
    ];

    programs.niri = {
        settings = {
        #======================================================================
        # CONFIGURACIÓN GENERAL
        #======================================================================
        prefer-no-csd = true;
        hotkey-overlay.skip-at-startup = true;
        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        #======================================================================
        # ENTORNO Y ARRANQUE
        #======================================================================
        environment = {
            CLUTTER_BACKEND = "wayland";
            GDK_BACKEND = "wayland";
            NIXOS_OZONE_WL = "1";
            QT_AUTO_SCREEN_SCALE_FACTOR = "1";
            QT_QPA_PLATFORM = "wayland";
            QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
            SDL_VIDEODRIVER = "wayland";
            _JAVA_AWT_WM_NONREPARENTING = "1";
        };

        # Aplicaciones que se lanzan directamente con Niri
        spawn-at-startup =
            let
                sh = [ "sh" "-c" ];
                polkit-agent = "${pkgs.polkit_gnome}/lib/polkit-gnome/polkit-gnome-authentication-agent-1";
            in
            [
                { command = [ "swww-daemon" ]; }
                { command = sh ++ [ "clipse -listen" ]; }
                { command = sh ++ [ "systemctl --user start hypridle.service" ]; }
                { command = sh ++ [ "systemctl --user start waybar.service" ]; }
                { command = sh ++ [ "systemctl --user start swaync.service" ]; }
                { command = [ "exec" polkit-agent ]; }
            ];

        #======================================================================
        # CONFIGURACIÓN DE ENTRADA (INPUT)
        #======================================================================
        input = {
            warp-mouse-to-focus.enable = true;
            focus-follows-mouse = {
                enable = true;
                max-scroll-amount = "0%";
            };
            keyboard = {
                track-layout = "global";
                numlock = true;
                xkb = {
                    layout = "us,es";
                    options = "grp:win_space_toggle";
                };
            };
            touchpad = {
                tap = true;
                drag = true;
                natural-scroll = true;
                scroll-method = "two-finger";
            };
            mouse = {
                accel-speed = 0.0;
                accel-profile = "adaptive";
            };
        };

        #======================================================================
        # CONFIGURACIÓN DE PANTALLAS (OUTPUTS)
        #======================================================================
        outputs = {
            "eDP-1" = {
                mode.height = 1920;
                mode.width = 1080;
                mode.refresh = 144.0;
                scale = 1.0;
                position.x = 0;
                position.y = 0;
                focus-at-startup = true;
            };
            "HDMI-A-1" = {
                mode.height = 1360;
                mode.width = 768;
                mode.refresh = 60.0;
                scale = 1.0;
                position.x = -1360;
                position.y = 0;
            };
        };

        #======================================================================
        # DISEÑO Y APARIENCIA (LAYOUT)
        #======================================================================
        layout = {
            gaps = 12;
            center-focused-column = "never";
            default-column-width.proportion = 0.5;
            preset-column-widths = [
                { proportion = 0.33333; }
                { proportion = 0.5; }
                { proportion = 0.66667; }
            ];
            tab-indicator = {
                gap = 5.0;
                width = 4.0;
                length.total-proportion = 0.5;
                position = "left";
                gaps-between-tabs = 0.0;
                corner-radius = 0.0;
            };
            focus-ring = {
                width = 3;
                active.color = "#${config.stylix.base16Scheme.base03}";
                inactive.color = "#${config.stylix.base16Scheme.base0D}";
                urgent.color = "#${config.stylix.base16Scheme.base0E}";
            };
            border.width = 0;
        };

        #======================================================================
        # REGLAS DE VENTANAS Y CAPAS
        #======================================================================
        window-rules = [
            # Regla global para bordes redondeados
            {
                geometry-corner-radius =
                  let
                    radius = 4.0;
                  in
                  {
                    bottom-left = radius;
                    bottom-right = radius;
                    top-left = radius;
                    top-right = radius;
                  };
                clip-to-geometry = true;
                draw-border-with-background = false;
            }
            # Reglas para ventanas específicas
            {
                matches = [{ app-id = "^org\\.wezfurlong\\.wezterm$"; }];
                default-column-width = { };
            }
            {
                matches = [{ app-id = "firefox$"; title = "^Picture-in-Picture$"; }];
                open-floating = true;
            }
            {
                matches = [{ app-id = "brave$"; title = "^Picture-in-Picture$"; }];
                open-floating = true;
            }
            {
                matches = [{ app-id = "clipse"; }];
                open-floating = true;
                default-column-width.fixed = 722;
                default-window-height.fixed = 652;
            }
            {
                matches = [{ app-id = "^com\\.obsproject\\.Studio$"; }];
                default-column-width.proportion = 1.0;
            }
        ];

        layer-rules = [{
            matches = [
            { namespace = "notification"; }
            { namespace = "swaync-control-center"; }
            ];
            block-out-from = [ "screencast" ];
        }];

        #======================================================================
        # GESTOS
        #======================================================================
        gestures.hot-corners.enable = false;

        #======================================================================
        # ATAJOS DE TECLADO (BINDS)
        #======================================================================
        binds =
            {
                "Mod+Shift+Slash".action.show-hotkey-overlay = [];

                # --- Lanzadores de Aplicaciones ---
                "Mod+Q".action.spawn = "kitty";
                "Mod+D".action.spawn-sh = "rofi -show drun";
                "Mod+A".action.spawn-sh = "kitty --class clipse -e 'clipse'";
                "Mod+P".action.spawn = "niri-color-picker";
                "Mod+E".action.spawn = "nemo";
                "Mod+N".action.spawn-sh = "swaync-client -t";
                "Mod+Escape".action.spawn = "wlogout";

                # --- Teclas Multimedia y de Sistema ---
                "XF86AudioRaiseVolume".action.spawn-sh = "manage-volume --inc";
                "XF86AudioLowerVolume".action.spawn-sh = "manage-volume --dec";
                "XF86AudioMute".action.spawn-sh = "manage-volume --toggle";
                "XF86AudioMicMute".action.spawn-sh = "manage-volume --toggle-mic";
                "XF86MonBrightnessUp".action.spawn-sh = "manage-brightness --up";
                "XF86MonBrightnessDown".action.spawn-sh = "manage-brightness --down";

                "Mod+C".action.close-window = [];
                "Mod+O".action.toggle-overview = [];

                "Mod+Left".action.focus-column-left = [];
                "Mod+Down".action.focus-window-down = [];
                "Mod+Up".action.focus-window-up = [];
                "Mod+Right".action.focus-column-right = [];

                "Mod+Shift+Left".action.move-column-left = [];
                "Mod+Shift+Down".action.move-window-down = [];
                "Mod+Shift+Up".action.move-window-up = [];
                "Mod+Shift+Right".action.move-column-right = [];

                "Mod+Home".action.focus-column-first = [];
                "Mod+End".action.focus-column-last = [];
                "Mod+Ctrl+Home".action.move-column-to-first = [];
                "Mod+Ctrl+End".action.move-column-to-last = [];

                "Mod+Ctrl+Left".action.focus-monitor-left = [];
                "Mod+Ctrl+Down".action.focus-monitor-down = [];
                "Mod+Ctrl+Up".action.focus-monitor-up = [];
                "Mod+Ctrl+Right".action.focus-monitor-right = [];
                "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = [];
                "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = [];
                "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = [];
                "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = [];

                "Mod+U".action.focus-workspace-down = [];
                "Mod+I".action.focus-workspace-up = [];
                "Mod+Ctrl+U".action.move-column-to-workspace-down = [];
                "Mod+Ctrl+I".action.move-column-to-workspace-up = [];
                "Mod+Shift+U".action.move-workspace-down = [];
                "Mod+Shift+I".action.move-workspace-up = [];

                "Mod+1".action.focus-workspace = [1];
                "Mod+2".action.focus-workspace = [2];
                "Mod+3".action.focus-workspace = [3];
                "Mod+4".action.focus-workspace = [4];
                "Mod+5".action.focus-workspace = [5];
                "Mod+6".action.focus-workspace = [6];
                "Mod+7".action.focus-workspace = [7];
                "Mod+8".action.focus-workspace = [8];
                "Mod+9".action.focus-workspace = [9];
                "Mod+Shift+1".action.move-column-to-workspace = [1];
                "Mod+Shift+2".action.move-column-to-workspace = [2];
                "Mod+Shift+3".action.move-column-to-workspace = [3];
                "Mod+Shift+4".action.move-column-to-workspace = [4];
                "Mod+Shift+5".action.move-column-to-workspace = [5];
                "Mod+Shift+6".action.move-column-to-workspace = [6];
                "Mod+Shift+7".action.move-column-to-workspace = [7];
                "Mod+Shift+8".action.move-column-to-workspace = [8];
                "Mod+Shift+9".action.move-column-to-workspace = [9];

                "Mod+Shift+BracketLeft".action.consume-window-into-column = [];
                "Mod+Shift+BracketRight".action.expel-window-from-column = [];

                "Mod+Comma".action.consume-or-expel-window-left = [];
                "Mod+Period".action.consume-or-expel-window-right = [];

                "Mod+R".action.switch-preset-column-width = [];
                "Mod+Shift+R".action.switch-preset-window-height = [];
                "Mod+Ctrl+R".action.reset-window-height = [];
                "Mod+F".action.maximize-column = [];
                "Mod+M".action.fullscreen-window = [];

                "Mod+Ctrl+F".action.expand-column-to-available-width = [];

                "Mod+Ctrl+C".action.center-column = [];
                "Mod+Shift+Ctrl+C".action.center-visible-columns = [];

                "Mod+Minus".action.set-column-width = ["-10%"];
                "Mod+Equal".action.set-column-width = ["+10%"];

                "Mod+Shift+Minus".action.set-window-height = ["-10%"];
                "Mod+Shift+Equal".action.set-window-height = ["+10%"];

                "Mod+V".action.toggle-window-floating = [];
                "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [];

                "Mod+W".action.toggle-column-tabbed-display = [];

                "Print".action.screenshot = [];
                "Ctrl+Print".action.screenshot-screen = [];
                "Alt+Print".action.screenshot-window = [];

                "Mod+Shift+E".action.quit = [];
                "Ctrl+Alt+Delete".action.quit = [];

                "Mod+Shift+P".action.power-off-monitors = [];
            };
        };
    };
}
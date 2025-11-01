{ config, pkgs, ... }:

{

    home.packages = with pkgs; [
        xwayland-satellite
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
        config = ''
            input {
                keyboard {
                    xkb {
                        layout "en,es"
                        options "grp:win_space_toggle"
                    }
                    track-layout "global"
                    numlock
                }
                touchpad {
                    tap
                    drag true
                    scroll-method "two-finger"        
                }
                mouse {
                    accel-speed 0.0
                    accel-profile "adaptive"
                }

                trackpoint { }

                // Uncomment this to make the mouse warp to the center of newly focused windows.
                warp-mouse-to-focus

                // Focus windows and outputs automatically when moving the mouse into them.
                // Setting max-scroll-amount="0%" makes it work only on windows already fully on screen.
                focus-follows-mouse max-scroll-amount="0%"
            }

            // You can configure outputs by their name, which you can find
            // by running `niri msg outputs` while inside a niri instance.
            output "eDP-1" {

                // The format is "<width>x<height>" or "<width>x<height>@<refresh rate>".
                mode "1920x1080@144"
                scale 1
                transform "normal"

                // Position of the output in the global coordinate space.
                position x=0 y=0

                focus-at-startup
            }

            output "HDMI-A-1" {
                mode "1360x768@60"
                scale 1
                transform "normal"
                position x=-1360 y=0
            }

            // Settings that influence how windows are positioned and sized.
            layout {
                gaps 12
                center-focused-column "never"
                preset-column-widths {
                    proportion 0.33333
                    proportion 0.5
                    proportion 0.66667
                }
                tab-indicator {
                    gap 5.000000
                    width 4.000000
                    length total-proportion=0.500000
                    position "left"
                    gaps-between-tabs 0.000000
                    corner-radius 0.000000
                }
                default-column-width { proportion 0.5; }
                focus-ring {
                    width 2
                    active-color "#${config.stylix.base16Scheme.base03}"
                    inactive-color "#${config.stylix.base16Scheme.base0D}"
                    urgent-color "#${config.stylix.base16Scheme.base0E}"
                }
                border { }
                shadow { }
                struts {
                    left 0
                    right 0
                    top 0
                    bottom 0
                }
            }

            // Add lines like this to spawn processes at startup.
            // Note that running niri as a session supports xdg-desktop-autostart,
            // Waybar, swaync. swayidle estan en el home, por lo que no seran necesarios
            spawn-at-startup "swww-daemon"
            spawn-at-startup "clipse -listen"
            spawn-at-startup "exec /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"

            hotkey-overlay {
                skip-at-startup
            }

            prefer-no-csd

            environment {
                "CLUTTER_BACKEND" "wayland"
                "GDK_BACKEND" "wayland"
                "NIXOS_OZONE_WL" "1"
                "QT_AUTO_SCREEN_SCALE_FACTOR" "1"
                "QT_QPA_PLATFORM" "wayland"
                "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1"
                "SDL_VIDEODRIVER" "wayland"
                "_JAVA_AWT_WM_NONREPARENTING" "1"
            }

            screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

            window-rule {
            geometry-corner-radius 4
            clip-to-geometry true
            draw-border-with-background false
            }

            window-rule {
                match app-id=r#"^org\.wezfurlong\.wezterm$"#
                default-column-width {}
            }

            window-rule {
                match app-id=r#"firefox$"# title="^Picture-in-Picture$"
                open-floating true
            }

            window-rule {
                match app-id=r#"brave$"# title="^Picture-in-Picture$"
                open-floating true
            }

            // Clipse, flotante y con proporciones fijas
            window-rule {
                match app-id="clipse"
                open-floating true
            }

            window-rule {
                match app-id="clipse"
                default-column-width { fixed 622; }
                default-window-height { fixed 652; }
            }

            // OBS en anchura completa
            window-rule {
                match app-id=r#"^com\.obsproject\.Studio$"#
                default-column-width { proportion 1.0; }
            }


            // No comparte swaync
            layer-rule {
                match namespace="notification"
                match namespace="swaync-control-center"
                block-out-from "screencast"
            }

            gestures {
                hot-corners {
                    off
                }
            }

            binds {

                Mod+Shift+Slash { show-hotkey-overlay; }

                // Suggested binds for running programs: terminal, app launcher, screen locker.
                Mod+T hotkey-overlay-title="Open a Terminal: Kitty" { spawn "kitty"; }
                Mod+D hotkey-overlay-title="Run an Application: rofi" { spawn "rofi"; }
                Mod+A { spawn-sh "kitty --class clipse -e 'clipse'"; }
                Mod+P { spawn "niri-color-picker"; }
                Mod+E { spawn "nemo"; }
                Super+Alt+L hotkey-overlay-title="Lock the Screen: hyprlock" { spawn "hyprlock"; }
                Mod+Escape { spawn "wlogout"; }


                XF86AudioRaiseVolume allow-when-locked=true { spawn "manage-volume --inc"; }
                XF86AudioLowerVolume allow-when-locked=true { spawn "manage-volume --dec"; }
                XF86AudioMute        allow-when-locked=true { spawn "manage-volume --toggle"; }
                XF86AudioMicMute     allow-when-locked=true { spawn "manage-volume --toggle-mic"; }

                XF86MonBrightnessUp allow-when-locked=true { spawn "manage-brightness --up"; }
                XF86MonBrightnessDown allow-when-locked=true { spawn "manage-brightness --down"; }

                // Open/close the Overview: a zoomed-out view of workspaces and windows.
                Mod+O repeat=false { toggle-overview; }

                Mod+Q repeat=false { close-window; }

                Mod+Left  { focus-column-left; }
                Mod+Down  { focus-window-down; }
                Mod+Up    { focus-window-up; }
                Mod+Right { focus-column-right; }
                Mod+H     { focus-column-left; }
                Mod+J     { focus-window-down; }
                Mod+K     { focus-window-up; }
                Mod+L     { focus-column-right; }

                Mod+Ctrl+Left  { move-column-left; }
                Mod+Ctrl+Down  { move-window-down; }
                Mod+Ctrl+Up    { move-window-up; }
                Mod+Ctrl+Right { move-column-right; }
                Mod+Ctrl+H     { move-column-left; }
                Mod+Ctrl+J     { move-window-down; }
                Mod+Ctrl+K     { move-window-up; }
                Mod+Ctrl+L     { move-column-right; }

                Mod+Home { focus-column-first; }
                Mod+End  { focus-column-last; }
                Mod+Ctrl+Home { move-column-to-first; }
                Mod+Ctrl+End  { move-column-to-last; }

                Mod+Shift+Left  { focus-monitor-left; }
                Mod+Shift+Down  { focus-monitor-down; }
                Mod+Shift+Up    { focus-monitor-up; }
                Mod+Shift+Right { focus-monitor-right; }
                Mod+Shift+H     { focus-monitor-left; }
                Mod+Shift+J     { focus-monitor-down; }
                Mod+Shift+K     { focus-monitor-up; }
                Mod+Shift+L     { focus-monitor-right; }

                Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
                Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
                Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
                Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
                Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
                Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
                Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
                Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

                Mod+Page_Down      { focus-workspace-down; }
                Mod+Page_Up        { focus-workspace-up; }
                Mod+U              { focus-workspace-down; }
                Mod+I              { focus-workspace-up; }
                Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
                Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
                Mod+Ctrl+U         { move-column-to-workspace-down; }
                Mod+Ctrl+I         { move-column-to-workspace-up; }

                Mod+Shift+Page_Down { move-workspace-down; }
                Mod+Shift+Page_Up   { move-workspace-up; }
                Mod+Shift+U         { move-workspace-down; }
                Mod+Shift+I         { move-workspace-up; }

                Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
                Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
                Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
                Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

                Mod+WheelScrollRight      { focus-column-right; }
                Mod+WheelScrollLeft       { focus-column-left; }
                Mod+Ctrl+WheelScrollRight { move-column-right; }
                Mod+Ctrl+WheelScrollLeft  { move-column-left; }

                Mod+Shift+WheelScrollDown      { focus-column-right; }
                Mod+Shift+WheelScrollUp        { focus-column-left; }
                Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
                Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

                Mod+1 { focus-workspace 1; }
                Mod+2 { focus-workspace 2; }
                Mod+3 { focus-workspace 3; }
                Mod+4 { focus-workspace 4; }
                Mod+5 { focus-workspace 5; }
                Mod+6 { focus-workspace 6; }
                Mod+7 { focus-workspace 7; }
                Mod+8 { focus-workspace 8; }
                Mod+9 { focus-workspace 9; }
                Mod+Ctrl+1 { move-column-to-workspace 1; }
                Mod+Ctrl+2 { move-column-to-workspace 2; }
                Mod+Ctrl+3 { move-column-to-workspace 3; }
                Mod+Ctrl+4 { move-column-to-workspace 4; }
                Mod+Ctrl+5 { move-column-to-workspace 5; }
                Mod+Ctrl+6 { move-column-to-workspace 6; }
                Mod+Ctrl+7 { move-column-to-workspace 7; }
                Mod+Ctrl+8 { move-column-to-workspace 8; }
                Mod+Ctrl+9 { move-column-to-workspace 9; }

                Mod+BracketLeft  { consume-or-expel-window-left; }
                Mod+BracketRight { consume-or-expel-window-right; }

                Mod+Comma  { consume-window-into-column; }
                Mod+Period { expel-window-from-column; }

                Mod+R { switch-preset-column-width; }

                Mod+Shift+R { switch-preset-window-height; }
                Mod+Ctrl+R { reset-window-height; }
                Mod+F { maximize-column; }
                Mod+Shift+F { fullscreen-window; }

                Mod+Ctrl+F { expand-column-to-available-width; }

                Mod+C { center-column; }

                Mod+Ctrl+C { center-visible-columns; }

                Mod+Minus { set-column-width "-10%"; }
                Mod+Equal { set-column-width "+10%"; }

                Mod+Shift+Minus { set-window-height "-10%"; }
                Mod+Shift+Equal { set-window-height "+10%"; }

                Mod+V       { toggle-window-floating; }
                Mod+Shift+V { switch-focus-between-floating-and-tiling; }

                Mod+W { toggle-column-tabbed-display; }

                Print { screenshot; }
                Ctrl+Print { screenshot-screen; }
                Alt+Print { screenshot-window; }

                Ctrl+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

                Mod+Shift+E { quit; }
                Ctrl+Alt+Delete { quit; }

                Mod+Shift+P { power-off-monitors; }
            }
        '';
    };
}
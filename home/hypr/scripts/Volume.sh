#!/usr/bin/env bash

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
            echo "Microphone: ${volume}%"
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
            echo "Speaker: ${volume}%"
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
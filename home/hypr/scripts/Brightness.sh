#!/usr/bin/env bash

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
                notify "Brightness" "${new_brightness}%" "$icon"
            fi
            ;;
        --down)
            if command -v brightnessctl &> /dev/null; then
                brightnessctl set 5%- > /dev/null
                new_brightness=$(get_brightness)
                icon=$(get_brightness_icon "$new_brightness")
                notify "Brightness" "${new_brightness}%" "$icon"
            fi
            ;;
        --set)
            local value="$2"
            if [[ -n "$value" && "$value" =~ ^[0-9]+$ ]]; then
                if command -v brightnessctl &> /dev/null; then
                    brightnessctl set "${value}%" > /dev/null
                    new_brightness=$(get_brightness)
                    icon=$(get_brightness_icon "$new_brightness")
                    notify "Brightness" "${new_brightness}%" "$icon"
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
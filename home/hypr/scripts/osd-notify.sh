
#!/bin/sh

# Función para enviar la notificación al servidor de SwayOSD
# Uso: notify_osd <tipo> <valor>
notify_osd() {
    swayosd-client --${1}-slider-full ${2}
}

# Función principal
case $1 in
    volume_up)
        # Sube el volumen y luego obtiene el nuevo valor para mostrarlo
        wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
        VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')
        notify_osd volume $VOLUME
        ;;

    volume_down)
        # Baja el volumen y luego obtiene el nuevo valor para mostrarlo
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')
        notify_osd volume $VOLUME
        ;;

    volume_mute)
        # Mutea/desmutea y muestra un indicador de mute
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        IS_MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTE && echo "yes" || echo "no")
        if [ "$IS_MUTED" = "yes" ]; then
            swayosd-client --output-muted
        else
            VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')
            notify_osd volume $VOLUME
        fi
        ;;

    mic_mute)
        # Mutea/desmutea el micrófono y muestra el indicador
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        IS_MIC_MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTE && echo "yes" || echo "no")
        if [ "$IS_MIC_MUTED" = "yes" ]; then
            swayosd-client --mic-muted
        else
            swayosd-client --mic-unmuted
        fi
        ;;

    brightness_up)
        # Sube el brillo y obtiene el nuevo valor
        brightnessctl set 5%+
        BRIGHTNESS=$(brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}')
        notify_osd brightness $BRIGHTNESS
        ;;

    brightness_down)
        # Baja el brillo y obtiene el nuevo valor
        brightnessctl set 5%-
        BRIGHTNESS=$(brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}')
        notify_osd brightness $BRIGHTNESS
        ;;
esac

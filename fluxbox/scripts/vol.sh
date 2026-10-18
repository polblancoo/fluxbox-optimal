#!/bin/sh
# Volumen con aviso visual: vol.sh up | down | mute
# (Win + ↑ / Win + ↓ / Win + 0, y también las teclas multimedia)
S=@DEFAULT_AUDIO_SINK@
case "$1" in
    up)   wpctl set-mute "$S" 0; wpctl set-volume -l 1.0 "$S" 5%+ ;;
    down) wpctl set-volume "$S" 5%- ;;
    mute) wpctl set-mute "$S" toggle ;;
esac

v=$(wpctl get-volume "$S")                      # "Volume: 0.45" o "Volume: 0.45 [MUTED]"
pct=$(echo "$v" | awk '{printf "%d", $2 * 100 + 0.5}')
case "$v" in
    *MUTED*) notify-send -t 1500 -h string:x-dunst-stack-tag:vol -h int:value:0 "󰖁  Silenciado" ;;
    *)       notify-send -t 1500 -h string:x-dunst-stack-tag:vol -h int:value:"$pct" "󰕾  Volumen $pct%" ;;
esac

#!/bin/bash
# Menú de salida de audio (Win + A): lista todas las salidas (parlantes, HDMI,
# auriculares, Bluetooth), cambia la predeterminada y mueve lo que esté sonando.
export LC_ALL=C

current=$(pactl get-default-sink)

choice=$(pactl list sinks | awk -v cur="$current" '
    $1=="Name:"        { name=$2 }
    $1=="Description:" { sub(/^[[:space:]]*Description: /,""); printf "%s%s\t%s\n", (name==cur ? "● " : "  "), $0, name }
' | rofi -dmenu -i -p "󰕾  Salida de audio" -display-columns 1 -display-column-separator '\t')
[ -z "$choice" ] && exit 0

sink=${choice##*$'\t'}
label=${choice%%$'\t'*}; label=${label#??}

pactl set-default-sink "$sink"
pactl list short sink-inputs | while read -r id _; do pactl move-sink-input "$id" "$sink" 2>/dev/null; done
notify-send -t 2500 "󰕾 Audio" "$label"

#!/bin/sh
# Luz nocturna (Win + Shift + N): pantalla cálida on / off
STATE="${XDG_RUNTIME_DIR:-/tmp}/fluxbox-night-light"
if ! command -v gammastep >/dev/null; then
    notify-send "Luz nocturna" "Falta instalar: sudo apt install gammastep"; exit 1
fi
if [ -e "$STATE" ]; then
    rm -f "$STATE"; gammastep -x >/dev/null 2>&1
    notify-send -t 2000 "🌙 Luz nocturna: OFF"
else
    touch "$STATE"; gammastep -O 4000 >/dev/null 2>&1
    notify-send -t 2000 "🌙 Luz nocturna: ON" "4000 K"
fi

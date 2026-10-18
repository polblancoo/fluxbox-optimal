#!/bin/sh
# Prender / apagar picom (Win + Shift + P)
if pgrep -x picom >/dev/null; then
    pkill -x picom
    notify-send -t 2000 "picom: OFF" "Sin efectos (máximo rendimiento)"
else
    picom --daemon
    notify-send -t 2000 "picom: ON" "Sombras, dim y sin tearing"
fi

#!/bin/sh
# Modo película (Win + M): alterna entre
#   ON : pantalla nunca se apaga + notificaciones pausadas
#   OFF: vuelve a lo normal (apagado a los 10 min, notificaciones activas)
STATE="${XDG_RUNTIME_DIR:-/tmp}/fluxbox-movie-mode"

if [ -e "$STATE" ]; then
    rm -f "$STATE"
    xset s 600 600 s on +dpms dpms 600 600 600
    dunstctl set-paused false
    notify-send -t 2500 "🎬 Modo película: OFF" "Pantalla y notificaciones normales"
else
    touch "$STATE"
    notify-send -t 2500 "🎬 Modo película: ON" "La pantalla no se apaga · notificaciones en pausa"
    sleep 2.6
    xset s off -dpms
    dunstctl set-paused true
fi

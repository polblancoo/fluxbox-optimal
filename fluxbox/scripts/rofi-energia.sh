#!/bin/bash
# Menú de energía (Win + X): bloquear, suspender, cerrar sesión, reiniciar, apagar.
choice=$(printf '%s\n' \
    "  Bloquear" \
    "󰤄  Suspender" \
    "󰍃  Cerrar sesión" \
    "  Reiniciar" \
    "  Apagar" | rofi -dmenu -i -p "  Energía")

confirmar() {
    [ "$(printf 'No\nSí, %s\n' "$1" | rofi -dmenu -i -p "¿$1?")" = "Sí, $1" ]
}

case "$choice" in
    *Bloquear*)       slock ;;
    *Suspender*)      (slock &) ; sleep 0.5; systemctl suspend ;;
    *"Cerrar sesión"*) confirmar "cerrar sesión" && pkill -x fluxbox ;;
    *Reiniciar*)      confirmar "reiniciar" && systemctl reboot ;;
    *Apagar*)         confirmar "apagar" && systemctl poweroff ;;
esac

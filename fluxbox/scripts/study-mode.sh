#!/bin/sh
# Modo estudio (Win + E): alterna entre
#   ON : notificaciones en pausa + pantalla cálida (gammastep) + pomodoro 25/5
#   OFF: todo vuelve a lo normal
STATE="${XDG_RUNTIME_DIR:-/tmp}/fluxbox-study-mode"

# avisa aunque dunst esté en pausa (despausa un momento)
avisar() {
    dunstctl set-paused false
    notify-send -u critical -t 8000 "$1" "$2"
    sleep 8
    [ -e "$STATE" ] && dunstctl set-paused true
}

if [ -e "$STATE" ]; then
    kill "$(cat "$STATE")" 2>/dev/null
    rm -f "$STATE"
    command -v gammastep >/dev/null && gammastep -x >/dev/null 2>&1
    dunstctl set-paused false
    notify-send -t 2500 "📚 Modo estudio: OFF" "Notificaciones y colores normales"
else
    notify-send -t 2500 "📚 Modo estudio: ON" "Notificaciones en pausa · pomodoro 25/5 · Win+E para salir"
    sleep 2.6
    command -v gammastep >/dev/null && gammastep -O 4500 >/dev/null 2>&1
    dunstctl set-paused true
    (
        n=1
        while true; do
            sleep 1500; avisar "🍅 Pomodoro $n terminado" "Descanso de 5 minutos"
            sleep 292;  avisar "📚 A estudiar" "Arranca el pomodoro $((n + 1))"
            n=$((n + 1))
        done
    ) &
    echo $! > "$STATE"
fi

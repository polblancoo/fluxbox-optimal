#!/bin/sh
# Terminal desplegable (F12): la crea si no existe, si no la muestra/oculta.
id=$(xdotool search --classname '^scratchpad$' 2>/dev/null | head -1)

if [ -z "$id" ]; then
    exec kitty --class=scratchpad
elif [ "$(xdotool getactivewindow 2>/dev/null)" = "$id" ]; then
    xdotool windowminimize "$id"
else
    wmctrl -i -a "$id"
fi

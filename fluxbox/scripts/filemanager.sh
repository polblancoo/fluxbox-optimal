#!/bin/sh
# Gestor de archivos (Win + F): superfile (spf) en kitty si está; si no, uno gráfico.
if command -v spf >/dev/null; then
    exec kitty --class=filemanager -T "spf" -e spf
fi
for fm in thunar pcmanfm nautilus dolphin; do
    command -v "$fm" >/dev/null && exec "$fm"
done
exec xdg-open "$HOME"

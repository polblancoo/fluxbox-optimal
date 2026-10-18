#!/bin/sh
# Videos desde el portapapeles (copiá la URL antes):
#   yt.sh       -> reproducir en mpv (máx 720p, liviano)
#   yt.sh baja  (Win + Shift + Y) -> descargar a ~/Videos
export PATH="$HOME/.local/bin:$PATH"
URL=$(xclip -o -selection clipboard 2>/dev/null)
case "$URL" in
    http*) ;;
    *) notify-send "yt" "No hay una URL en el portapapeles"; exit 1 ;;
esac
if [ "$1" = baja ]; then
    notify-send -t 3000 "⬇ Descargando" "$URL"
    if yt-dlp -o "$HOME/Videos/%(title)s.%(ext)s" "$URL"; then
        notify-send "✅ Descarga lista" "en ~/Videos"
    else
        notify-send -u critical "❌ Falló la descarga" "$URL"
    fi
else
    notify-send -t 2000 "▶ Abriendo en mpv" "$URL"
    exec mpv --ytdl-format='bv*[height<=720]+ba/b[height<=720]/b' "$URL"
fi

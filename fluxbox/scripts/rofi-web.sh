#!/bin/bash
# Buscar en la web (Win + S). Prefijos:
#   gh bevy      → GitHub            yt lofi    → YouTube
#   w linux      → Wikipedia         (sin prefijo) → DuckDuckGo
q=$(rofi -dmenu -l 0 -p "  Buscar" -mesg "prefijos: gh · yt · w  —  o escribí directo" </dev/null)
[ -z "$q" ] && exit 0

enc() { python3 -c 'import sys,urllib.parse; print(urllib.parse.quote_plus(sys.argv[1]))' "$1"; }

case "$q" in
    "gh "*)    url="https://github.com/search?type=repositories&q=$(enc "${q#gh }")" ;;
    "yt "*)    url="https://www.youtube.com/results?search_query=$(enc "${q#yt }")" ;;
    "w "*)     url="https://es.wikipedia.org/w/index.php?search=$(enc "${q#w }")" ;;
    http*://*) url="$q" ;;
    *)         url="https://duckduckgo.com/?q=$(enc "$q")" ;;
esac

exec xdg-open "$url"

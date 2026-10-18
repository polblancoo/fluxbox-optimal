#!/bin/bash
# Abrir un proyecto (Win + O): lista los repos git bajo $HOME (los más recientes
# primero) y abre kitty ahí con nvim. Al salir de nvim queda la terminal en la carpeta.
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/rofi-proyectos.txt"
mkdir -p "$(dirname "$CACHE")"

buscar() {
    find "$HOME" -maxdepth 5 -xdev -type d -name .git \
        -not -path '*/node_modules/*' -not -path '*/.cargo/*' -not -path '*/.cache/*' \
        -not -path '*/.local/*' -not -path '*/target/*' -not -path '*/snap/*' 2>/dev/null |
    while read -r g; do d=${g%/.git}; printf '%s\t%s\n' "$(stat -c %Y "$d")" "$d"; done |
    sort -rn | cut -f2 > "$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"
}

[ -s "$CACHE" ] || buscar            # primera vez: buscar ya
(buscar &) >/dev/null 2>&1           # siempre: refrescar en segundo plano

choice=$(sed "s#^$HOME/##" "$CACHE" | rofi -dmenu -i -p "  Proyecto")
[ -z "$choice" ] && exit 0
dir="$HOME/$choice"
[ -d "$dir" ] || exit 1

exec kitty --directory "$dir" --title "󱘗 ${choice##*/}" "${SHELL:-sh}" -ic 'nvim .; exec "${SHELL:-sh}"'

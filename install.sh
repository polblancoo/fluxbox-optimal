#!/usr/bin/env bash
# fluxbox-optimal · instalador
#   ./install.sh              instala (pregunta lo opcional)
#   ./install.sh --dry-run    muestra qué haría, sin tocar nada
#   ./install.sh --yes        responde sí a todo lo opcional
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
DRY=0; YES=0
for a in "$@"; do
    case "$a" in
        --dry-run) DRY=1 ;;
        --yes|-y)  YES=1 ;;
        -h|--help) sed -n '2,5p' "$0"; exit 0 ;;
        *) echo "opción desconocida: $a" >&2; exit 1 ;;
    esac
done

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m  %s\n' "$*"; }
run()  { if [ "$DRY" = 1 ]; then printf '   [dry-run] %s\n' "$*"; else "$@"; fi; }
ask()  { [ "$YES" = 1 ] && return 0; [ "$DRY" = 1 ] && { printf '   [dry-run] preguntaría: %s\n' "$1"; return 1; }
         read -r -p "$1 [s/N] " r; [[ "$r" =~ ^[sSyY]$ ]]; }

# --- 1. paquetes (apt) ------------------------------------------------------
if command -v apt-get >/dev/null; then
    say "Paquetes base (apt) — pide sudo"
    mapfile -t PKGS < <(grep -vE '^\s*(#|$)' "$REPO/packages-apt.txt")
    run sudo apt-get update
    run sudo apt-get install -y "${PKGS[@]}"
    # el agente polkit cambia de nombre según la versión
    for p in policykit-1-gnome polkit-gnome; do
        apt-cache show "$p" >/dev/null 2>&1 && { run sudo apt-get install -y "$p"; break; }
    done
else
    warn "No hay apt. Instalá a mano lo que figura en packages-apt.txt con tu gestor de paquetes."
fi

# --- 2. copiar configuración (con backup) -----------------------------------
backup() {  # backup <ruta>
    [ -e "$1" ] || return 0
    run mv "$1" "$1.bak-$STAMP"; warn "backup: $1 → $1.bak-$STAMP"
}
install_tree() {  # install_tree <origen> <destino>  (sustituye @HOME@ en texto)
    local src=$1 dst=$2
    backup "$dst"
    run mkdir -p "$dst"
    run cp -a "$src/." "$dst/"
    [ "$DRY" = 1 ] && return 0
    { grep -rlI '@HOME@' "$dst" 2>/dev/null || true; } | while read -r f; do sed -i "s#@HOME@#$HOME#g" "$f"; done
}

say "Fluxbox → ~/.fluxbox"
install_tree "$REPO/fluxbox" "$HOME/.fluxbox"

say "kitty, rofi, dunst, picom, conky → ~/.config"
for d in kitty rofi dunst picom; do install_tree "$REPO/config/$d" "$HOME/.config/$d"; done
install_tree "$REPO/config/conky" "$HOME/.config/conky"
if [ "$DRY" = 0 ]; then
    IFACE=$(ip route show default 2>/dev/null | awk '{print $5; exit}')
    sed -i "s#__IFACE__#${IFACE:-lo}#g" "$HOME/.config/conky/conky.conf"
    echo "   interfaz de red para conky: ${IFACE:-lo}"
fi

# --- 3. opcionales ----------------------------------------------------------
if ! fc-list 2>/dev/null | grep -qi 'MesloLGM Nerd'; then
    if ask "Bajar la fuente MesloLG Nerd Font (iconos del toolbar, kitty y conky)?"; then
        run mkdir -p "$HOME/.local/share/fonts"
        tmp=$(mktemp -d)
        run curl -fL -o "$tmp/Meslo.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
        run unzip -qo "$tmp/Meslo.zip" -d "$HOME/.local/share/fonts/MesloNerd"
        run fc-cache -f
    fi
fi

if [ ! -f "$HOME/.config/nvim/lua/chadrc.lua" ]; then
    if ask "Instalar NvChad (starter oficial) en ~/.config/nvim?"; then
        backup "$HOME/.config/nvim"
        run git clone --depth 1 https://github.com/NvChad/starter "$HOME/.config/nvim"
        warn "Abrí nvim una vez: lazy.nvim baja los plugins."
    fi
fi

if command -v cargo >/dev/null && ! command -v tubetui >/dev/null; then
    ask "Instalar tubetui con cargo (YouTube en la terminal)?" && run cargo install tubetui
fi

# --- 4. lo que queda a mano -------------------------------------------------
cat <<MSG

Listo. Lo que no se instala solo (opcional):
  • tubetui     cargo install tubetui        (si no tenés Rust: https://rustup.rs)
  • spf         gestor de archivos en terminal → https://superfile.dev
  • greenclip   historial del portapapeles (Win+V) → releases de https://github.com/erebe/greenclip
  • aMule       sudo apt install amule
  • wallpaper   el del repo es ~/.fluxbox/wallpaper-default.png; el tuyo: ~/.fluxbox/wallpaper.jpg (o .png)

Cerrá sesión y elegí "Fluxbox" en el login. Atajos: Win + ?  (o Win + F12).
MSG

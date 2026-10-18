#!/bin/bash
# ---------------------------------------------------------------
# help.sh - Chuleta de atajos de Fluxbox (Win + ?  /  Ctrl + ?  /  Alt + F12)
# Dos columnas, colores Tokyo Night. Sale con q.
# Si cambiás ~/.fluxbox/keys, actualizá también esta lista.
# ---------------------------------------------------------------

B=$'\e[1;38;2;122;162;247m'   # azul    (títulos)
K=$'\e[1;38;2;187;154;247m'   # magenta (teclas)
T=$'\e[38;2;192;202;245m'     # texto
D=$'\e[38;2;86;95;137m'       # gris
N=$'\e[0m'

KEYW=23      # ancho de la columna de teclas
COLW=70      # ancho visible de cada columna
L=(); R=(); col=L

# cada línea se guarda como "texto<TAB>largo visible" para alinear sin contar colores
line() { if [ "$col" = L ]; then L+=("$1"$'\t'"$2"); else R+=("$1"$'\t'"$2"); fi; }
sec() {
    local t=" ━━ $1 " n=$((COLW - 4 - ${#1} - 1))
    line "${B}${t}${D}$(printf '━%.0s' $(seq 1 $n))${N}" "$((${#t} + n))"
}
k() {
    local pad=$((KEYW - ${#1})); ((pad < 1)) && pad=1
    line "   ${K}$1$(printf '%*s' $pad '')${N} ${T}$2${N}" "$((3 + ${#1} + pad + 1 + ${#2}))"
}
gap() { line "" 0; }

# ======================= COLUMNA IZQUIERDA =======================
col=L
sec "LANZADORES"
k "Win + Enter / Alt + F1" "Terminal (kitty)"
k "Win + B"                "Navegador"
k "Win + N"                "Neovim (NvChad)"
k "Win + F"                "Archivos (superfile / spf)"
k "Win + Esc"              "btop (monitor del sistema)"
k "Win + P / W"            "Rofi: apps / ventanas abiertas"
k "Win + O"                "Abrir un proyecto git (kitty + nvim)"
k "Win + S"                "Buscar en la web (gh yt w)"
k "F12"                    "Terminal desplegable (mostrar/ocultar)"
k "Alt + F2"               "Ejecutar comando (fbrun)"
k "Win/Ctrl + ?  Alt+F12"  "Esta ayuda"
gap
sec "HERRAMIENTAS"
k "Win + A"                "Salida de audio: compu/TV/auris/BT"
k "Win + Shift + B"        "Bluetooth: conectar auriculares"
k "Win + V"                "Historial del portapapeles"
k "Win + M"                "Modo película (pantalla siempre on)"
k "Win + Shift + P"        "Prender / apagar efectos (picom)"
k "Win + L"                "Bloquear pantalla (slock)"
k "Win + X"                "Energía: suspender / reiniciar / apagar"
gap
sec "ESTUDIO Y MEDIA"
k "Win + E"                "Modo estudio: sin notifs + pomodoro"
k "Win + Shift + N"        "Luz nocturna (pantalla cálida) on/off"
k "Win + Y"                "tubetui: YouTube + video integrado, pestañas, música local"
k "Win + Shift + Y"        "Descargar URL copiada a ~/Videos"
gap
sec "VENTANAS"
k "Alt + Tab (+Shift)"     "Ventana siguiente / anterior"
k "Alt + F4 / F5"          "Cerrar / forzar cierre"
k "Alt + F9 / F10 / F11"   "Minimizar / maximizar / completa"
k "Alt + Espacio"          "Menú de la ventana"
k "Alt + 1 / 2"            "Mover ventana al monitor 1 / 2"
k "Win + Tab / 1..9"       "Pestañas: siguiente / ir a la N"
gap
sec "TUBETUI (Win + Y)"
k "tubetui"                "YouTube + música/videos locales, en la terminal"
k "cargo install tubetui"  "Instalarlo (necesita Rust)"
gap
sec "NEOVIM"
k "nvim"                   "NvChad: la config se baja con install.sh"

# ======================= COLUMNA DERECHA =========================
col=R
sec "ACOMODAR VENTANAS"
k "Win + R"                "Modo ventana: hjkl mover, Shift=tamaño"
k "Win + Shift + ← / →"    "Mitad izquierda / derecha"
k "Win + Shift + ↑ / ↓"    "Maximizar / mediana centrada"
k "Alt + flechas"          "Redimensionar (5%)"
k "Alt + Shift + flechas"  "Mover (10 px)"
gap
sec "ESCRITORIOS"
k "Ctrl + F1 / F2"         "Ir al escritorio 1 / 2"
k "Ctrl + Alt + ← / →"     "Escritorio anterior / siguiente"
k "Win + F1 / F2"          "Enviar ventana al escritorio 1 / 2"
k "Ctrl + Win + F1 / F2"   "Enviar ventana e ir con ella"
k "Win (+Ctrl) + ← / →"    "Enviar (e ir) al escritorio ant / sig"
gap
sec "KITTY (hints: marca con letras)"
k "Ctrl + Shift + E"       "Abrir una URL de la pantalla en el navegador"
k "Ctrl + Shift + G"       "Error de cargo (archivo:línea) → nvim"
k "Ctrl + Shift + Y"       "Copiar palabra / ruta de la pantalla"
gap
sec "MULTIMEDIA Y SISTEMA"
k "Win + ↑ / ↓ / 0"        "Volumen subir / bajar / silenciar"
k "ImpPant (+Shift)"       "Captura: selección / completa (~/Capturas)"
k "Win + RePág / AvPág"    "Brillo subir / bajar (o teclas de brillo)"
k "Ctrl + Alt + Supr"      "Salir de Fluxbox"
gap
sec "RATÓN"
k "Alt + clic izq / der"   "Mover / redimensionar ventana"
k "Alt + clic medio"       "Mandar ventana al fondo"
k "Doble clic en título"   "Enrollar / desenrollar"
k "Clic der (título/fondo)" "Menú de la ventana / principal"
k "Ctrl + arrastrar título" "Agrupar ventanas como pestañas"
k "Rueda (fondo / barra)"  "Cambiar escritorio / ventana"

# ======================= IMPRESIÓN ===============================
{
printf " ${B} FLUXBOX · ATAJOS DE TECLADO${N}   ${D}Win = tecla Windows · q = salir · config en ~/.fluxbox/keys${N}\n\n"
max=${#L[@]}; ((${#R[@]} > max)) && max=${#R[@]}
for ((i = 0; i < max; i++)); do
    l=${L[i]-$'\t0'}; r=${R[i]-$'\t0'}
    ltxt=${l%$'\t'*}; llen=${l##*$'\t'}
    rtxt=${r%$'\t'*}
    printf "%s%*s   %s\n" "$ltxt" $((COLW - llen)) "" "$rtxt"
done
printf " ${D}Recargar atajos/menú: clic der → Configuración → Recargar config · colores: Reiniciar Fluxbox${N}\n"
} | less -R -S -P ' q = salir '

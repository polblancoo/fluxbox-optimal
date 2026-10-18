#!/bin/bash
# Menú Bluetooth con rofi (Win + Shift + B)
# Elegís un dispositivo emparejado: se conecta y le pasa el audio.
# Si ya está conectado pero el audio sale por otro lado, le pasa el audio;
# si ya es la salida en uso, lo desconecta.

powered() { bluetoothctl show | grep -q 'Powered: yes'; }

# salida de PipeWire de un dispositivo BT; según la versión el nombre es
# bluez_output.AA:BB:.. o bluez_output.AA_BB_...1
bt_sink() {
    pactl list short sinks | awk -v a="bluez_output.$1" -v b="bluez_output.${1//:/_}" \
        'index($2, a)==1 || index($2, b)==1 {print $2; exit}'
}

# a veces BlueZ dice "Connected: no" con el auricular conectado y sonando,
# así que si existe su salida de audio también cuenta como conectado
is_connected() { bluetoothctl info "$1" | grep -q 'Connected: yes' || [ -n "$(bt_sink "$1")" ]; }

# espera a que PipeWire cree la salida BT (tarda ~6 s tras conectar) y le pasa el audio
use_bt_audio() {
    local mac=$1 sink=
    for _ in $(seq 1 75); do
        sink=$(bt_sink "$mac")
        [ -n "$sink" ] && break
        sleep 0.2
    done
    [ -z "$sink" ] && return 1
    pactl set-default-sink "$sink"
    pactl list short sink-inputs | while read -r id _; do pactl move-sink-input "$id" "$sink" 2>/dev/null; done
}

connect_bt() {
    local mac=$1 name=$2
    notify-send -t 2000 "Bluetooth" "Conectando: $name…"
    # sin "trust" blueman pide autorización por cada perfil y la conexión queda a medias
    bluetoothctl trust "$mac" >/dev/null
    for _ in 1 2; do
        is_connected "$mac" && break
        bluetoothctl --timeout 12 connect "$mac" >/dev/null
        sleep 1
    done
    if ! is_connected "$mac"; then
        notify-send -u critical "Bluetooth" "No se pudo conectar: $name"
        return 1
    fi
    if use_bt_audio "$mac"; then
        notify-send -t 2500 "Bluetooth" "Conectado: $name — audio por BT"
    else
        notify-send -t 3500 "Bluetooth" "Conectado: $name (no apareció la salida de audio)"
    fi
}

# uso directo sin menú: bt-menu.sh connect <MAC> [nombre]
if [ "$1" = connect ] && [ -n "$2" ]; then
    connect_bt "$2" "${3:-$2}"
    exit
fi

menu() {
    if powered; then
        echo "󰂲  Apagar Bluetooth"
        bluetoothctl devices Paired | while read -r _ mac name; do
            if is_connected "$mac"; then
                sink=$(bt_sink "$mac")
                if [ -z "$sink" ]; then  # conectado pero sin audio (mouse, teclado…)
                    printf '󰂱  %s  (conectado — desconectar)\t%s\n' "$name" "$mac"
                elif [ "$sink" = "$(pactl get-default-sink)" ]; then
                    printf '󰂱  %s  (en uso — desconectar)\t%s\n' "$name" "$mac"
                else
                    printf '󰂱  %s  (conectado — pasar audio)\t%s\n' "$name" "$mac"
                fi
            else
                printf '󰂯  %s\t%s\n' "$name" "$mac"
            fi
        done
    else
        echo "󰂯  Encender Bluetooth"
    fi
    echo "  Emparejar nuevo (blueman)"
}

choice=$(menu | rofi -dmenu -i -p "  Bluetooth" -display-columns 1 -display-column-separator '\t')
[ -z "$choice" ] && exit 0

case "$choice" in
    *"Apagar Bluetooth"*)   bluetoothctl power off && notify-send -t 2500 "Bluetooth" "Apagado" ;;
    *"Encender Bluetooth"*) bluetoothctl power on  && notify-send -t 2500 "Bluetooth" "Encendido" ;;
    *"Emparejar nuevo"*)    blueman-manager & ;;
    *)
        mac=${choice##*$'\t'}
        name=${choice%%$'\t'*}; name=${name#*  }; name=${name%  (*}
        case "$choice" in
            *"— desconectar)"*)
                bluetoothctl disconnect "$mac" >/dev/null && notify-send -t 2500 "Bluetooth" "Desconectado: $name"
                ;;
            *"(conectado — pasar audio)"*)
                if use_bt_audio "$mac"; then
                    notify-send -t 2500 "Bluetooth" "$name — audio por BT"
                else
                    notify-send -t 3500 "Bluetooth" "$name: no apareció la salida de audio"
                fi
                ;;
            *)
                connect_bt "$mac" "$name"
                ;;
        esac
        ;;
esac

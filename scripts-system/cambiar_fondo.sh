#!/bin/bash

WALLPAPER_DIR="/home/hideon/Pictures/wallpapers"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
WOFI_CSS="$HOME/.cache/wal/wofi-dynamic.css"

# 1. Asegurar que exista un CSS para Wofi si es la primera vez
[ ! -f "$WOFI_CSS" ] && echo "* { background: #111; color: #fff; }" > "$WOFI_CSS"

# 2. Desplegar Wofi usando el CSS que ya tenemos (aunque sea del fondo anterior)
SELECTION=$(ls "$WALLPAPER_DIR" | wofi --show dmenu --prompt "Elige tu entorno estético:" --style "$WOFI_CSS")

if [ -z "$SELECTION" ]; then
    exit 0
fi

IMAGE="$WALLPAPER_DIR/$SELECTION"

# 3. Aplicar fondo
if ! pgrep -x "hyprpaper" > /dev/null; then
    nohup hyprpaper > /dev/null 2>&1 &
    sleep 0.3
fi
hyprctl hyprpaper unload all > /dev/null 2>&1
hyprctl hyprpaper preload "$IMAGE" > /dev/null 2>&1
hyprctl hyprpaper wallpaper ",$IMAGE" > /dev/null 2>&1

# 4. Regenerar paleta
wal -i "$IMAGE" -q

# 5. Crear el nuevo CSS dinámico para la PRÓXIMA vez que abras Wofi
if [ -f "$HOME/.cache/wal/colors.sh" ]; then
    . "$HOME/.cache/wal/colors.sh"
    cat <<EOF > "$WOFI_CSS"
window { background-color: $background; color: $foreground; }
#entry:selected { background-color: $color1; color: $background; }
EOF
fi

# 6. Aplicar colores a bordes
if [ -f "$HOME/.cache/wal/colors.sh" ]; then
    
    C1=$(grep "^color1=" "$HOME/.cache/wal/colors.sh" | cut -d "'" -f2)
    C2=$(grep "^color2=" "$HOME/.cache/wal/colors.sh" | cut -d "'" -f2)

    hyprctl keyword general:col.active_border "rgba(${C1#\#}cc) rgba(${C#\#}cc) 45deg" -q
    hyprctl keyword general:col.inactive_border "rgba(${C2#\#}aa)" -q

fi    

# 7. Reiniciar herramientas
killall waybar 2>/dev/null
nohup waybar > /dev/null 2>&1 &
[ $(pgrep -x "cava") ] && killall -SIGUSR1 cava 2>/dev/null

#!/bin/bash

WALLPAPER_DIR="/home/hideon/Pictures/wallpapers"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
WOFI_CSS="$HOME/.cache/wal/wofi-dynamic.css"
LAST_WAL_IMG="$HOME/.cache/wal/wal"

# 1. Asegurar que exista un CSS para Wofi si es la primera vez
[ ! -f "$WOFI_CSS" ] && echo "* { background: #111; color: #fff; }" > "$WOFI_CSS"

# --- MODO INICIO AUTOMÁTICO (Sin Wofi) ---
if [ "$1" = "init" ] && [ -f "$LAST_WAL_IMG" ]; then
    IMAGE=$(cat "$LAST_WAL_IMG")
else
    # 2. Desplegar Wofi si no es el arranque
    SELECTION=$(ls "$WALLPAPER_DIR" | wofi --show dmenu --prompt "Elige tu entorno estético:" --style "$WOFI_CSS")
    if [ -z "$SELECTION" ]; then
        exit 0
    fi
    IMAGE="$WALLPAPER_DIR/$SELECTION"
fi

# 3. Aplicar fondo
if ! pgrep -x "hyprpaper" > /dev/null; then
    nohup hyprpaper > /dev/null 2>&1 &
    sleep 0.5
fi
hyprctl hyprpaper unload all > /dev/null 2>&1
hyprctl hyprpaper preload "$IMAGE" > /dev/null 2>&1
hyprctl hyprpaper wallpaper ",$IMAGE" > /dev/null 2>&1

# 4. Regenerar paleta (O recargarla en el inicio)
if [ "$1" = "init" ]; then
    wal -R -q  # -R recarga los últimos colores guardados instantáneamente
else
    wal -i "$IMAGE" -q
fi

# 5. Crear el nuevo CSS dinámico para la PRÓXIMA vez que abras Wofi
if [ -f "$HOME/.cache/wal/colors.sh" ]; then
    . "$HOME/.cache/wal/colors.sh"
    cat <<EOF > "$WOFI_CSS"
window { background-color: $background; color: $foreground; }
#entry:selected { background-color: $color1; color: $background; }
EOF
fi

# 6. Aplicar colores a bordes (Corregido el typo de variable ${C})
if [ -f "$HOME/.cache/wal/colors.sh" ]; then
    C1=$(grep "^color1=" "$HOME/.cache/wal/colors.sh" | cut -d "'" -f2)
    C2=$(grep "^color2=" "$HOME/.cache/wal/colors.sh" | cut -d "'" -f2)

    hyprctl keyword general:col.active_border "rgba(${C1#\#}cc) rgba(${C2#\#}cc) 45deg" -q
    hyprctl keyword general:col.inactive_border "rgba(${C2#\#}aa)" -q
fi

# 7. Reiniciar herramientas
killall waybar 2>/dev/null
nohup waybar > /dev/null 2>&1 &
[ "$(pgrep -x "cava")" ] && killall -SIGUSR1 cava 2>/dev/null

#!/bin/bash

WALLPAPER_DIR="/home/hideon/Pictures/wallpapers"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
WOFI_CSS="$HOME/.cache/wal/wofi-dynamic.css"
LAST_WAL_IMG="$HOME/.cache/wal/wal"
ROFI_THEME="$HOME/.config/rofi/selector-fondos.rasi"

# 1. Asegurar que exista un CSS para Wofi si es la primera vez
[ ! -f "$WOFI_CSS" ] && echo "* { background: #111; color: #fff; }" > "$WOFI_CSS"

# --- MODO INICIO AUTOMÁTICO (Sin Rofi/Wofi) ---
if [ "$1" = "init" ] && [ -f "$LAST_WAL_IMG" ]; then
    IMAGE=$(cat "$LAST_WAL_IMG")
else
    # 2. Desplegar Rofi con previsualizaciones si no es el arranque
    SELECTION=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | while read -r img; do
        echo -e "$(basename "$img")\0icon\x1f$img"
    done | rofi -dmenu -theme "$ROFI_THEME" -p "Elige tu entorno estético:")

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
    wal -R -q
else
    wal -i "$IMAGE" -q
fi

# 5. Crear el nuevo CSS dinámico para Wofi
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
    hyprctl keyword general:col.active_border "rgba(${C1#\#}cc) rgba(${C2#\#}cc) 45deg" -q
    hyprctl keyword general:col.inactive_border "rgba(${C2#\#}aa)" -q
fi

# ==============================================================================
# 7. Sincronizar Temas de Wofi e inyectar Pywal
# ==============================================================================

WOFI_DIR="/home/hideon/.config/wofi"
mkdir -p "$WOFI_DIR"

if [ -f "$HOME/.cache/wal/colors.sh" ]; then
    . "$HOME/.cache/wal/colors.sh"

    # Escribir el CSS nativo de GTK3 para Wofi
    cat <<EOF > "$WOFI_DIR/style.css"
/* Estilos Pywal para Wofi */
window {
    margin: 0px;
    border: 2px solid $color1;
    border-radius: 12px;
    background-color: $background;
    font-family: "JetBrainsMono Nerd Font", monospace;
    font-size: 14px;
}

#outer-box {
    margin: 5px;
    border: none;
    background-color: transparent;
}

#input {
    margin: 5px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 6px;
    color: $foreground;
    background-color: rgba(0, 0, 0, 0.2);
}

#inner-box {
    margin: 5px;
    border: none;
    background-color: transparent;
}

#text {
    margin: 5px;
    color: $foreground;
}

/* Cambiar la barra azul genérica por tu color cobrizo de Pywal */
#entry:selected {
    background-color: $color1;
    border-radius: 6px;
}

#text:selected {
    color: $background;
    font-weight: bold;
}
EOF
fi

# Reiniciar servicios básicos de la barra superior
killall waybar 2>/dev/null
nohup waybar > /dev/null 2>&1 &
[ "$(pgrep -x "cava")" ] && killall -SIGUSR1 cava 2>/dev/null

# Limpieza total de Walker para liberar RAM
uwsm stop app-walker.service 2>/dev/null || uwsm stop walker 2>/dev/null
killall -9 walker 2>/dev/null

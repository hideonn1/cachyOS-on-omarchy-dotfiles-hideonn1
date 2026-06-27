#!/bin/bash
PLAYER="spotify"

# Usamos timeout para asegurar que si playerctl no responde, el script termine en 1 seg
if STATUS=$(timeout 1 playerctl -p $PLAYER status 2>/dev/null); then
    # Solo intentamos obtener metadatos si el estatus es exitoso

    ARTIST=$(timeout 1 playerctl -p $PLAYER metadata artist)
    TITLE=$(timeout 1 playerctl -p $PLAYER metadata title)
    echo "{\"text\": \"$ARTIST - $TITLE\", \"class\": \"playing\"}"
else
    echo "{\"text\": \"\", \"class\": \"paused\"}"
fi

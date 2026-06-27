#!/bin/bash

# Comprobar si la interfaz proton0 existe y está activa
if ip link show proton0 > /dev/null 2>&1; then
    # Está activa: podemos poner un icono o texto en verde
    echo "{\"text\": \"󰖂 VPN\", \"class\": \"connected\"}"
else
    # No está activa: texto en rojo o simplemente ocultarlo
    echo "{\"text\": \"󰖂 OFF\", \"class\": \"disconnected\"}"
fi

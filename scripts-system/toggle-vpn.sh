#!/bin/bash

# Verificar si la interfaz existe (está conectada)
if ip link show proton0 > /dev/null 2>&1; then
    # Si está conectada, desconectamos
    protonvpn disconnect
else
    protonvpn connect
fi

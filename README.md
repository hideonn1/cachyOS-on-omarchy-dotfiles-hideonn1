# Dotfiles - CachyOS/Arch Linux Setup

Mi configuración personal de entorno de trabajo para **Arch Linux / CachyOS**, enfocada en rendimiento, seguridad y estética personalizada.

## 🛠️ Tecnologías y Herramientas
* **WM:** Hyprland
* **Barra:** Waybar (con configuración personalizada y glifos especiales)
* **Terminal:** kitty + fish
* **Editor:** Zed (con integración Vim)
* **Gestión de Red:** `iproute2` y utilidades de seguridad.

## 🚀 Instalación
Este repositorio utiliza un **directorio Git bare** para gestionar los archivos de configuración directamente en `$HOME` sin necesidad de enlaces simbólicos.

### Inicialización
```bash
# Clonar el repositorio
git clone --bare git@github.com:hideonn1/cachyOS-on-omarchy-dotfiles-hideonn1.git $HOME/.dotfiles
```

# Definir el alias de gestión
```bash
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

# Desplegar archivos
```bash
config checkout
```

## ⚙️ Uso
Para gestionar tus archivos de configuración, utiliza siempre el alias config en lugar de git:

```bash
# Ver estado:
config status

# Añadir un nuevo archivo:
config add .config/tu-archivo

# Commit:
config commit -m "Descripción del cambio"

# Subir/empujar cambios:
config push
```

# Dotfiles - CachyOS/Arch Linux Setup

<p align="center">
  <a href="./README.md">Español</a> | <strong>English</strong>
</p>

<p align="center">
    <img src="./assets/banner-principal.png" alt="CachyOS Hyprland Setup" width="900">
</p>

My personal workstation setup built on **Arch Linux / CachyOS + Omarchy**, strictly focused on performance, security, and tailored aesthetics.

## 🛠️ Core Technologies & Tools
* **Base OS:** CachyOS (Arch Linux) — Minimal CLI installation (No-DE)
* **Framework / Base:** Omarchy
* **WM:** Hyprland (Wayland)
* **Status Bar:** Waybar (featuring custom configurations and special glyphs)
* **Terminal:** kitty + fish
* **Editor:** Zed (integrated with Vim keybindings)
* **Networking:** `iproute2` and specialized security utilities.

## 📸 Visual Showcases

### Aesthetic Environment Selector (Rofi Grid + Previews)
A custom-built integration designed to preview available wallpapers within a dynamic grid layout before applying changes.
<p align="center">
    <img src="./assets/rofi-selector.png" alt="Rofi Wallpaper Selector" width="850">
</p>

### Dynamic Color Palettes (Pywal Integration)
The `cambiar_fondo.sh` core script completely automates the environment's runtime regeneration. It dynamically adapts borders for Hyprland, Waybar, Kitty, and systemic tools within milliseconds based on the wallpaper's color scheme:

| Red Theme (Claire Redfield, RE:Code Veronica Remake) | Purple Theme (Digital Art) |
| :---: | :---: |
| <img src="./assets/sistema-rojo.png" width="420"> | <img src="./assets/sistema-morado.png" width="420"> |

### System Specifications
<p align="center">
    <img src="./assets/system-spec.png" alt="System Specifications" width="850">
</p>

## 🚀 Installation
This repository leverages a **Git bare directory** structure to manage configuration files natively within `$HOME`, eliminating the need for symlinks.

### Initialization
```bash
# Clone the repository as bare
git clone --bare git@github.com:hideonn1/cachyOS-on-omarchy-dotfiles-hideonn1.git $HOME/.dotfiles
```

### Setting Up the Management Alias
```bash
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

### Deploying the Files
```bash
config checkout
```

##⚙️ Usage

To seamlessly manage your configuration files, always use the config alias instead of standard git:

```bash
# Check configuration status:
config status

# Add a specific configuration file:
config add .config/your-file

# Commit changes:
config commit -m "feat: core change description"

# Push to your remote repository:
config push
```

## 🌌 Wallpaper Collection

The backgrounds used throughout this environment (including the Claire Redfield concept art and digital design pieces) are curated and hosted externally to keep the repository's history lightweight.
You can browse, view, and download the full collection in high-resolution directly from my public profile (accessible once you are logged into Wallhaven):

📌 **[My Collection on Wallhaven](https://wallhaven.cc/favorites/2187134)**

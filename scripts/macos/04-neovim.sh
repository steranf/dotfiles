#!/bin/bash
# 04-neovim.sh (macOS) - Configuración de Neovim (LazyVim)
set -euo pipefail
trap 'echo -e "\e[31m[ERROR] Script falló en la línea $LINENO\e[0m"' ERR

_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR="$(cd "$_DIR/../.." && pwd)"

echo -e "\n\e[33m[*] Restaurando configuración de Neovim (LazyVim)...\e[0m"
if [ -d "$DIR/nvim" ]; then
    if [ -d "$HOME/.config/nvim" ]; then
        if [ ! -d "$HOME/.config/nvim.bak" ]; then
            echo "Realizando backup de configuración local de Neovim..."
            mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
        else
            echo "Backup de Neovim ya existe. Reemplazando configuración local."
            rm -rf "$HOME/.config/nvim"
        fi
    fi
    cp -r "$DIR/nvim" "$HOME/.config/nvim"
    echo -e "\e[32m[✓] Configuración de Neovim (LazyVim) restaurada.\e[0m"
else
    echo -e "\e[33m[ADVERTENCIA] No se encontró el directorio nvim en el repositorio.\e[0m"
fi

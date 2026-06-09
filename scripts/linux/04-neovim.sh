#!/bin/bash
set -euo pipefail
trap 'echo -e "\e[31m[ERROR] Script falló en la línea $LINENO\e[0m"' ERR

_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/linux/env.sh
source "$_DIR/env.sh"

echo -e "\n\e[33m[*] Restaurando configuración de Neovim (LazyVim)...\e[0m"
if [ -d "$DIR/stow/nvim/.config/nvim" ]; then
    if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
        if [ ! -d "$HOME/.config/nvim.bak" ]; then
            echo "Realizando backup de configuración local de Neovim..."
            mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
        else
            echo "Backup de Neovim ya existe. Reemplazando configuración local."
            rm -rf "$HOME/.config/nvim"
        fi
    elif [ -L "$HOME/.config/nvim" ]; then
        rm -f "$HOME/.config/nvim"
    fi
    mkdir -p "$HOME/.config"
    stow -d "$DIR/stow" -t "$HOME" nvim
    echo "Configuración de Neovim (LazyVim) vinculada vía stow."
else
    echo -e "\e[33m[ADVERTENCIA] No se encontró el directorio nvim en el repositorio.\e[0m"
fi

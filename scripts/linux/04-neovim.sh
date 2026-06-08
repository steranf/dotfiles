#!/bin/bash
set -euo pipefail
trap 'echo -e "\e[31m[ERROR] Script falló en la línea $LINENO\e[0m"' ERR

_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$_DIR/env.sh"

echo -e "\n\e[33m[*] Restaurando configuración de Neovim (LazyVim)...\e[0m"
if [ -d "$DIR/nvim" ]; then
    if [ -d "$HOME/.config/nvim" ]; then
        echo "Realizando backup de configuración local de Neovim..."
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
    fi
    cp -r "$DIR/nvim" "$HOME/.config/nvim"
    echo "Configuración de Neovim (LazyVim) restaurada desde dotfiles."
else
    echo -e "\e[33m[ADVERTENCIA] No se encontró el directorio nvim en el repositorio.\e[0m"
fi

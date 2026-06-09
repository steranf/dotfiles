#!/bin/bash
# 99-restore.sh (macOS) - Revierte configuraciones a su estado original
set -euo pipefail
trap 'echo -e "\e[31m[ERROR] Script falló en la línea $LINENO\e[0m"' ERR

_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR="$(cd "$_DIR/../.." && pwd)"

echo -e "\n\e[35m[*] Revirtiendo configuraciones a su estado original...\e[0m"

# Desvincular dotfiles gestionados por stow
if command -v stow >/dev/null 2>&1; then
    stow -D -d "$DIR/stow" -t "$HOME" zsh git omp nvim 2>/dev/null || true
    echo -e "\e[32m[OK] Dotfiles desvinculados (stow).\e[0m"
fi

if [ -f "$HOME/.zshrc.bak" ]; then
    cp "$HOME/.zshrc.bak" "$HOME/.zshrc"
    echo -e "\e[32m[OK] Perfil .zshrc restaurado.\e[0m"
fi

if [ -d "$HOME/.config/nvim.bak" ]; then
    rm -rf "$HOME/.config/nvim"
    mv "$HOME/.config/nvim.bak" "$HOME/.config/nvim"
    echo -e "\e[32m[OK] Configuración de Neovim restaurada.\e[0m"
elif [ -d "$HOME/.config/nvim" ]; then
    rm -rf "$HOME/.config/nvim"
    echo -e "\e[32m[OK] Configuración de Neovim eliminada.\e[0m"
fi

# macOS: chsh en vez de usermod
if command -v bash >/dev/null 2>&1; then
    sudo chsh -s "$(command -v bash)" "$USER"
    echo -e "\e[32m[OK] Shell por defecto revertida a bash.\e[0m"
fi

echo -e "\n\e[33mReinicia tu terminal para aplicar los cambios.\e[0m"

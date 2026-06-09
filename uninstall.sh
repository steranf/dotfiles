#!/bin/bash
# uninstall.sh - Purga completa del entorno instalado por dotfiles.
# Revierte configs, elimina binarios, Oh My Zsh, NVM y Pyenv.
set -euo pipefail

echo -e "\e[36m====================================================\e[0m"
echo -e "\e[31m   TERMINAL NIVEL DIOS - DESINSTALADOR COMPLETO    \e[0m"
echo -e "\e[36m====================================================\e[0m"
echo -e "\e[33m"
echo -e "Este script eliminará:"
echo -e "  • Binarios de GitHub Releases (/usr/local/bin)"
echo -e "  • Oh My Zsh (~/.oh-my-zsh) y sus plugins"
echo -e "  • NVM (~/.nvm)"
echo -e "  • Pyenv (~/.pyenv)"
echo -e "  • Configuración de OMP (~/.config/omp)"
echo -e "  • Configuración de Neovim (~/.config/nvim)"
echo -e "  • Perfil Zsh (~/.zshrc) → restaurado desde .bak si existe"
echo -e "  • Shell por defecto → revertida a bash"
echo -e "\e[0m"
read -r -p "¿Estás seguro? Escribe 'si' para continuar: " confirm
if [ "$confirm" != "si" ]; then
    echo "Desinstalación cancelada."
    exit 0
fi

echo ""

# --- 1. Configs ---

echo -e "\e[33m[*] Revirtiendo configuraciones...\e[0m"

if [ -f "$HOME/.zshrc.bak" ]; then
    cp "$HOME/.zshrc.bak" "$HOME/.zshrc"
    echo -e "  \e[32m[✓] .zshrc restaurado desde .zshrc.bak\e[0m"
elif [ -f "$HOME/.zshrc" ]; then
    rm -f "$HOME/.zshrc"
    echo -e "  \e[32m[✓] .zshrc eliminado (sin .bak previo)\e[0m"
fi

if [ -d "$HOME/.config/nvim.bak" ]; then
    rm -rf "$HOME/.config/nvim"
    mv "$HOME/.config/nvim.bak" "$HOME/.config/nvim"
    echo -e "  \e[32m[✓] Configuración de Neovim restaurada desde .bak\e[0m"
elif [ -d "$HOME/.config/nvim" ]; then
    rm -rf "$HOME/.config/nvim"
    echo -e "  \e[32m[✓] Configuración de Neovim eliminada\e[0m"
fi

if [ -d "$HOME/.config/omp" ]; then
    rm -rf "$HOME/.config/omp"
    echo -e "  \e[32m[✓] Configuración de Oh My Posh eliminada\e[0m"
fi

# --- 2. Shell por defecto ---

echo -e "\e[33m[*] Revirtiendo shell por defecto a bash...\e[0m"
if command -v bash >/dev/null 2>&1; then
    sudo usermod -s "$(command -v bash)" "$USER"
    echo -e "  \e[32m[✓] Shell revertida a bash\e[0m"
fi

# --- 3. Binarios de GitHub Releases ---

echo -e "\e[33m[*] Eliminando binarios de GitHub Releases...\e[0m"
_MANIFEST="$HOME/.local/share/dotfiles-manager/github-binaries"
if [ -f "$_MANIFEST" ]; then
    while IFS= read -r _bin; do
        if [ -f "/usr/local/bin/${_bin}" ]; then
            sudo rm -f "/usr/local/bin/${_bin}"
            echo -e "  \e[32m[✓] Eliminado: /usr/local/bin/${_bin}\e[0m"
        fi
    done < "$_MANIFEST"
    rm -rf "$HOME/.local/share/dotfiles-manager"
else
    for _bin in oh-my-posh eza lazygit fastfetch nvim; do
        if [ -f "/usr/local/bin/${_bin}" ]; then
            sudo rm -f "/usr/local/bin/${_bin}"
            echo -e "  \e[32m[✓] Eliminado: /usr/local/bin/${_bin}\e[0m"
        fi
    done
fi

# --- 4. Oh My Zsh ---

echo -e "\e[33m[*] Eliminando Oh My Zsh...\e[0m"
if [ -d "$HOME/.oh-my-zsh" ]; then
    rm -rf "$HOME/.oh-my-zsh"
    echo -e "  \e[32m[✓] ~/.oh-my-zsh eliminado\e[0m"
else
    echo -e "  [!] Oh My Zsh no encontrado, omitiendo."
fi

# --- 5. NVM ---

echo -e "\e[33m[*] Eliminando NVM...\e[0m"
if [ -d "$HOME/.nvm" ]; then
    rm -rf "$HOME/.nvm"
    echo -e "  \e[32m[✓] ~/.nvm eliminado\e[0m"
else
    echo -e "  [!] NVM no encontrado, omitiendo."
fi

# --- 6. Pyenv ---

echo -e "\e[33m[*] Eliminando Pyenv...\e[0m"
if [ -d "$HOME/.pyenv" ]; then
    rm -rf "$HOME/.pyenv"
    echo -e "  \e[32m[✓] ~/.pyenv eliminado\e[0m"
else
    echo -e "  [!] Pyenv no encontrado, omitiendo."
fi

# --- Fin ---

echo ""
echo -e "\e[32m====================================================\e[0m"
echo -e "\e[32m¡Desinstalación completa!\e[0m"
echo -e "\e[33mReinicia WSL para aplicar todos los cambios:\e[0m"
echo -e "\e[33m  wsl --shutdown   (ejecutar en PowerShell/CMD)\e[0m"
echo -e "\e[32m====================================================\e[0m"

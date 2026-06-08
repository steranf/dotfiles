#!/bin/bash
set -euo pipefail
trap 'echo -e "\e[31m[ERROR] Script falló en la línea $LINENO\e[0m"' ERR

_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$_DIR/env.sh"

echo -e "\n\e[35m[*] Revirtiendo configuraciones a su estado original...\e[0m"

# Restaurar .zshrc
if [ -f "$HOME/.zshrc.bak" ]; then
    cp "$HOME/.zshrc.bak" "$HOME/.zshrc"
    echo -e "\e[32m[OK] Perfil .zshrc restaurado.\e[0m"
fi

# Restaurar Neovim config
if [ -d "$HOME/.config/nvim.bak" ]; then
    rm -rf "$HOME/.config/nvim"
    mv "$HOME/.config/nvim.bak" "$HOME/.config/nvim"
    echo -e "\e[32m[OK] Configuración de Neovim restaurada.\e[0m"
elif [ -d "$HOME/.config/nvim" ]; then
    rm -rf "$HOME/.config/nvim"
    echo -e "\e[32m[OK] Configuración de Neovim eliminada.\e[0m"
fi

# Restaurar default shell a bash
if command -v bash >/dev/null 2>&1; then
    sudo usermod -s "$(which bash)" "$USER"
    echo -e "\e[32m[OK] Shell por defecto revertida a bash.\e[0m"
fi

# Remover binarios descargados por Github Releases
sudo rm -f /usr/local/bin/oh-my-posh /usr/local/bin/eza /usr/local/bin/lazygit /usr/local/bin/fastfetch /usr/local/bin/nvim
echo -e "\e[32m[OK] Ejecutables de GitHub Releases eliminados.\e[0m"

echo -e "\n\e[33mLa desinstalación ha concluido. Para reiniciar tu entorno por completo, por favor reinicia WSL ('wsl --shutdown' en Windows).\e[0m"

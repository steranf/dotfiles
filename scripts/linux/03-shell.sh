#!/bin/bash
set -euo pipefail
trap 'echo -e "\e[31m[ERROR] Script falló en la línea $LINENO\e[0m"' ERR

_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$_DIR/env.sh"

echo -e "\n\e[33m[*] Configurando Zsh como shell por defecto...\e[0m"
if command -v zsh >/dev/null 2>&1; then
    sudo usermod -s "$(which zsh)" "$USER"
else
    echo -e "\e[31mError: Zsh no está instalado correctamente.\e[0m"
fi

echo -e "\n\e[33m[*] Instalando Oh My Zsh y plugins...\e[0m"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone --branch "$ZSH_AUTOSUGGESTIONS_VERSION" --depth 1 https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone --branch "$ZSH_SYNTAX_HIGHLIGHTING_VERSION" --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

echo -e "\n\e[33m[*] Restaurando perfil .zshrc con backup...\e[0m"
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
    echo "Backup de .zshrc creado en ~/.zshrc.bak"
fi
cp "$DIR/linux/.zshrc" "$HOME/.zshrc"

echo -e "\n\e[33m[*] Instalando tema local de Oh My Posh...\e[0m"
mkdir -p "$HOME/.config/omp"
cp "$DIR/themes/catppuccin_mocha.omp.json" "$HOME/.config/omp/catppuccin_mocha.omp.json"

echo -e "\n\e[33m[*] Configurando plantilla de Git...\e[0m"
if [ ! -f "$HOME/.gitconfig" ]; then
    cp "$DIR/linux/.gitconfig" "$HOME/.gitconfig"
    echo "Plantilla .gitconfig copiada. Edita nombre y email: git config --global user.name / user.email"
else
    echo "Ya existe ~/.gitconfig, omitiendo para no sobrescribir tu configuración."
fi

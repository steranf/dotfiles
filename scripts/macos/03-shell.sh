#!/bin/bash
# 03-shell.sh (macOS) - Oh My Zsh, plugins, .zshrc y tema OMP
set -euo pipefail
trap 'echo -e "\e[31m[ERROR] Script falló en la línea $LINENO\e[0m"' ERR

_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR="$(cd "$_DIR/../.." && pwd)"
# shellcheck source=scripts/linux/env.sh
source "$_DIR/../linux/env.sh"

echo -e "\n\e[33m[*] Configurando Zsh como shell por defecto...\e[0m"
if command -v zsh >/dev/null 2>&1; then
    # macOS: chsh en vez de usermod
    sudo chsh -s "$(command -v zsh)" "$USER"
    echo -e "\e[32m[✓] Shell por defecto: zsh\e[0m"
else
    echo -e "\e[31mError: Zsh no está instalado. Ejecuta primero el paso [2].\e[0m"
    exit 1
fi

echo -e "\n\e[33m[*] Instalando Oh My Zsh y plugins...\e[0m"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
    actual_omz=$(git -C "$HOME/.oh-my-zsh" rev-parse HEAD)
    if [ "$actual_omz" != "$ZSH_OMZ_COMMIT" ]; then
        echo -e "\e[33m[!] Oh My Zsh commit difiere del pin registrado en env.sh.\e[0m"
        echo -e "    Instalado : $actual_omz"
        echo -e "    Registrado: $ZSH_OMZ_COMMIT"
    else
        echo -e "\e[32m[✓] Oh My Zsh commit verificado: $actual_omz\e[0m"
    fi
fi
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone --branch "$ZSH_AUTOSUGGESTIONS_VERSION" --depth 1 \
        https://github.com/zsh-users/zsh-autosuggestions \
        "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone --branch "$ZSH_SYNTAX_HIGHLIGHTING_VERSION" --depth 1 \
        https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
fi

echo -e "\n\e[33m[*] Vinculando dotfiles con GNU Stow...\e[0m"

# .zshrc — backup antes de stow
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    if [ ! -f "$HOME/.zshrc.bak" ]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
        echo "Backup creado en ~/.zshrc.bak"
    else
        echo "Backup de .zshrc ya existe, omitiendo para evitar sobreescritura."
    fi
fi
rm -f "$HOME/.zshrc"
stow -d "$DIR/stow" -t "$HOME" zsh

# Tema de Oh My Posh
mkdir -p "$HOME/.config/omp"
rm -f "$HOME/.config/omp/catppuccin_mocha.omp.json"
stow -d "$DIR/stow" -t "$HOME" omp

# .gitconfig — solo si no existe
if [ ! -f "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ]; then
    stow -d "$DIR/stow" -t "$HOME" git
    echo "Plantilla .gitconfig vinculada vía stow. Edita: git config --global user.name / user.email"
else
    echo "Ya existe ~/.gitconfig, omitiendo."
fi

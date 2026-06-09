#!/bin/bash
# 01-core.sh (macOS) - Homebrew + herramientas base y de terminal
set -euo pipefail
trap 'echo -e "\e[31m[ERROR] Script falló en la línea $LINENO\e[0m"' ERR

echo -e "\n\e[33m[*] Verificando Homebrew...\e[0m"
if ! command -v brew >/dev/null 2>&1; then
    echo "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Apple Silicon: añadir brew al PATH de la sesión actual
    if [ -f /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi
echo -e "\e[32m[✓] $(brew --version | head -1)\e[0m"

echo -e "\n\e[33m[*] Instalando utilidades base...\e[0m"
brew install git curl wget jq fzf zoxide bat ripgrep fd stow

echo -e "\n\e[33m[*] Instalando herramientas de terminal...\e[0m"
brew install jandedobbeleer/oh-my-posh/oh-my-posh eza lazygit fastfetch neovim

echo -e "\e[32m[✓] Herramientas instaladas correctamente.\e[0m"

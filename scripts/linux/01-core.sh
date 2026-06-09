#!/bin/bash
set -euo pipefail
trap 'echo -e "\e[31m[ERROR] Script falló en la línea $LINENO\e[0m"' ERR

_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=scripts/linux/env.sh
source "$_DIR/env.sh"

echo -e "\n\e[33m[*] Instalando Zsh y utilidades base...\e[0m"
if command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y epel-release
    sudo dnf install -y zsh git curl wget unzip tar util-linux-user jq file fzf zoxide bat gcc make ripgrep fd-find
elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update -qq
    sudo apt-get install -y zsh git curl wget unzip tar jq file fzf zoxide bat gcc make ripgrep fd-find
else
    echo -e "\e[31m[ERROR] Gestor de paquetes no soportado (requiere dnf o apt-get).\e[0m"
    exit 1
fi

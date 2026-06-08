#!/bin/bash
set -euo pipefail
trap 'echo -e "\e[31m[ERROR] Script falló en la línea $LINENO\e[0m"' ERR

_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$_DIR/env.sh"

echo -e "\n\e[33m[*] Instalando Zsh, EPEL y utilidades base...\e[0m"
sudo dnf install -y epel-release zsh git curl wget unzip tar util-linux-user jq file fzf zoxide bat gcc make ripgrep fd-find

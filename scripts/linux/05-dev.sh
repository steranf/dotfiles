#!/bin/bash
set -euo pipefail
trap 'echo -e "\e[31m[ERROR] Script falló en la línea $LINENO\e[0m"' ERR

_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$_DIR/env.sh"

echo -e "\n\e[33m[*] Instalando NVM y Pyenv...\e[0m"
NVM_INSTALL_VERSION="v0.40.5"
PYENV_VERSION="v2.7.1"

if [ ! -d "$HOME/.nvm" ]; then
    echo "Instalando NVM (${NVM_INSTALL_VERSION})..."
    curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_INSTALL_VERSION}/install.sh" | bash
else
    echo "NVM ya instalado, omitiendo."
fi

if [ ! -d "$HOME/.pyenv" ]; then
    echo "Instalando Pyenv (${PYENV_VERSION})..."
    git clone --branch "$PYENV_VERSION" --depth 1 https://github.com/pyenv/pyenv.git "$HOME/.pyenv"
else
    echo "Pyenv ya instalado, omitiendo."
fi

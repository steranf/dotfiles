#!/bin/bash
set -euo pipefail
trap 'echo -e "\e[31m[ERROR] Script falló en la línea $LINENO\e[0m"' ERR

# Obtener directorio del repositorio
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Versiones congeladas para asegurar reproducibilidad
OMP_VERSION="v25.0.0"
EZA_VERSION="v0.20.2"
LAZYGIT_VERSION="0.48.0"
FASTFETCH_VERSION="2.38.0"
NVIM_VERSION="v0.12.2"
ZSH_AUTOSUGGESTIONS_VERSION="v0.7.1"
ZSH_SYNTAX_HIGHLIGHTING_VERSION="0.8.0"

# Detectar arquitectura
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    OMP_ARCH="amd64"
    EZA_ARCH="x86_64"
    LAZYGIT_ARCH="x86_64"
    FASTFETCH_ARCH="amd64"
    NVIM_ARCH="x86_64"
    OMP_SHA256="61b79c4ea5ab40927875eea2797ef74a2e7ed8d7cf1e2ab74b70c7bf8bab9074"
    EZA_SHA256="a926f4fdc50e85d218d6076b5bd7536f6560d0f4ce5e899c48d9d77c8d83d188"
    LAZYGIT_SHA256="291722c643a10805de3bd7b58f51d5275878269aeadb046709708f8683f558d7"
    FASTFETCH_SHA256="f61abf31129d0b932f47d40f2956df27d174b1f9cc775432bed11bdfbfb76aee"
    NVIM_SHA256="31cf85945cb600d96cdf69f88bc68bec814acbff50863c5546adef3a1bcef260"
elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    OMP_ARCH="arm64"
    EZA_ARCH="aarch64"
    LAZYGIT_ARCH="arm64"
    FASTFETCH_ARCH="aarch64"
    NVIM_ARCH="arm64"
    OMP_SHA256="dc60d5b5c3eeae998aa3cc9dd5d31f3e892f7a8abed86e843a839479db6f946c"
    EZA_SHA256="720b00b9f1244253600aecbc3377d5e5df886a6d0301d8a3c3ee917961586718"
    LAZYGIT_SHA256="37150ec77bd42d92b7dc96f05fca5f1cd310551936e32556011ac145ccd9d62b"
    FASTFETCH_SHA256="d8067104d7764802209bf760cfc0e72f3e98d37a4c3c2e0700f33f69d2a7547e"
    NVIM_SHA256="f697d4e4582b6e4b5c3c26e76e06ce26efa08ba1768e03fd2733fcc422bb0490"
else
    echo -e "\e[31mArquitectura $ARCH no soportada automáticamente.\e[0m"
    exit 1
fi

verify_sha256() {
    local file="$1" expected="$2" actual
    actual=$(sha256sum "$file" | awk '{print $1}')
    if [ "$actual" != "$expected" ]; then
        echo -e "\e[31m[ERROR] Checksum SHA256 inválido para $file\e[0m"
        echo -e "  Esperado: $expected\n  Obtenido: $actual"
        exit 1
    fi
    echo -e "\e[32m[✓] Checksum OK: $(basename "$file")\e[0m"
}

function install_base_packages {
    echo -e "\n\e[33m[*] Instalando Zsh, EPEL y utilidades base...\e[0m"
    sudo dnf install -y epel-release zsh git curl wget unzip tar util-linux-user jq file fzf zoxide bat gcc make ripgrep fd-find
}

function install_github_tools {
    echo -e "\n\e[33m[*] Instalando utilidades desde GitHub releases...\e[0m"
    local WORK_DIR
    WORK_DIR=$(mktemp -d)
    # shellcheck disable=SC2064
    trap "cd '$DIR'; rm -rf '$WORK_DIR'" RETURN EXIT

    cd "$WORK_DIR" || exit 1

    # Oh My Posh
    echo "Descargando Oh My Posh (${OMP_VERSION})..."
    wget --https-only -qO oh-my-posh "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/${OMP_VERSION}/posh-linux-${OMP_ARCH}" || { echo "Descarga falló"; exit 1; }
    file oh-my-posh | grep -q 'ELF' || { echo "oh-my-posh no es un ejecutable válido"; exit 1; }
    verify_sha256 oh-my-posh "$OMP_SHA256"
    sudo mv oh-my-posh /usr/local/bin/oh-my-posh
    sudo chmod +x /usr/local/bin/oh-my-posh

    # Eza
    echo "Descargando Eza (${EZA_VERSION})..."
    wget --https-only -qO eza.tar.gz "https://github.com/eza-community/eza/releases/download/${EZA_VERSION}/eza_${EZA_ARCH}-unknown-linux-gnu.tar.gz" || { echo "Descarga falló"; exit 1; }
    file eza.tar.gz | grep -q 'gzip' || { echo "eza.tar.gz no es un tar.gz válido"; exit 1; }
    verify_sha256 eza.tar.gz "$EZA_SHA256"
    tar xzf eza.tar.gz
    sudo mv eza /usr/local/bin/eza
    sudo chmod +x /usr/local/bin/eza

    # LazyGit
    echo "Descargando LazyGit (v${LAZYGIT_VERSION})..."
    wget --https-only -qO lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz" || { echo "Descarga falló"; exit 1; }
    file lazygit.tar.gz | grep -q 'gzip' || { echo "lazygit.tar.gz no es un tar.gz válido"; exit 1; }
    verify_sha256 lazygit.tar.gz "$LAZYGIT_SHA256"
    tar xzf lazygit.tar.gz lazygit
    sudo mv lazygit /usr/local/bin/lazygit
    sudo chmod +x /usr/local/bin/lazygit

    # Fastfetch
    echo "Descargando Fastfetch (${FASTFETCH_VERSION})..."
    wget --https-only -qO fastfetch.tar.gz "https://github.com/fastfetch-cli/fastfetch/releases/download/${FASTFETCH_VERSION}/fastfetch-linux-${FASTFETCH_ARCH}.tar.gz" || { echo "Descarga falló"; exit 1; }
    file fastfetch.tar.gz | grep -q 'gzip' || { echo "fastfetch.tar.gz no es un tar.gz válido"; exit 1; }
    verify_sha256 fastfetch.tar.gz "$FASTFETCH_SHA256"
    tar xzf fastfetch.tar.gz
    local FF_DIR="fastfetch-linux-${FASTFETCH_ARCH}"
    sudo mv "${FF_DIR}/usr/bin/fastfetch" /usr/local/bin/fastfetch
    sudo chmod +x /usr/local/bin/fastfetch

    # Neovim
    echo "Descargando Neovim (${NVIM_VERSION})..."
    wget --https-only -qO nvim.tar.gz "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-${NVIM_ARCH}.tar.gz" || { echo "Descarga falló"; exit 1; }
    file nvim.tar.gz | grep -q 'gzip' || { echo "nvim.tar.gz no es un tar.gz válido"; exit 1; }
    verify_sha256 nvim.tar.gz "$NVIM_SHA256"
    tar xzf nvim.tar.gz
    sudo cp -r nvim-linux-${NVIM_ARCH}/* /usr/local/
    
}

function configure_zsh {
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
}

function configure_neovim {
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
}

function configure_git {
    echo -e "\n\e[33m[*] Configurando plantilla de Git...\e[0m"
    if [ ! -f "$HOME/.gitconfig" ]; then
        cp "$DIR/linux/.gitconfig" "$HOME/.gitconfig"
        echo "Plantilla .gitconfig copiada. Edita nombre y email: git config --global user.name / user.email"
    else
        echo "Ya existe ~/.gitconfig, omitiendo para no sobrescribir tu configuración."
    fi
}

function install_nvm_pyenv {
    echo -e "\n\e[33m[*] Instalando NVM y Pyenv...\e[0m"
    local NVM_INSTALL_VERSION="v0.40.5"
    local PYENV_VERSION="v2.7.1"

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
}

function restore_backups {
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
}

function run_all {
    install_base_packages
    install_github_tools
    configure_zsh
    configure_neovim
    configure_git
    install_nvm_pyenv
    echo -e "\n\e[32m=======================================================\e[0m"
    echo -e "\e[32m¡INSTALACIÓN COMPLETADA EXITOSAMENTE EN WSL!\e[0m"
    echo -e "\e[33mPor favor escribe 'zsh' o abre una nueva pestaña para disfrutar de tu entorno.\e[0m"
    echo -e "\e[32m=======================================================\e[0m"
}

if [[ "${1:-}" == "--all" || "${1:-}" == "-a" ]]; then
    run_all
    exit 0
fi

while true; do
    clear
    echo -e "\e[36m==========================================\e[0m"
    echo -e "\e[35m   TERMINAL NIVEL DIOS - INSTALADOR (LINUX)\e[0m"
    echo -e "\e[36m==========================================\e[0m"
    echo " [1] Instalación Completa (Modo Dios)"
    echo " [2] Instalar Utilidades Base (DNF)"
    echo " [3] Instalar Herramientas Modernas (GitHub Releases)"
    echo " [4] Configurar Oh My Zsh y Temas"
    echo " [5] Configurar Neovim (LazyVim)"
    echo " [6] Instalar NVM y Pyenv"
    echo ""
    echo -e " \e[33m[R] Revertir (Restaurar bash y copias de seguridad)\e[0m"
    echo -e " \e[31m[Q] Salir\e[0m"
    echo -e "\e[36m==========================================\e[0m"
    
    read -p "Seleccione una opción: " opt

    case "$opt" in
        1) ( run_all ) || echo -e "\e[31m[Error] La instalación falló. Revisa los mensajes de arriba.\e[0m"
           read -p "Presione Enter para continuar..."; break ;;
        2) ( install_base_packages ) || echo -e "\e[31m[Error] Falló. Regresando al menú...\e[0m"
           read -p "Presione Enter para continuar..." ;;
        3) ( install_github_tools ) || echo -e "\e[31m[Error] Falló. Regresando al menú...\e[0m"
           read -p "Presione Enter para continuar..." ;;
        4) ( configure_zsh ) || echo -e "\e[31m[Error] Falló. Regresando al menú...\e[0m"
           read -p "Presione Enter para continuar..." ;;
        5) ( configure_neovim ) || echo -e "\e[31m[Error] Falló. Regresando al menú...\e[0m"
           read -p "Presione Enter para continuar..." ;;
        6) ( install_nvm_pyenv ) || echo -e "\e[31m[Error] Falló. Regresando al menú...\e[0m"
           read -p "Presione Enter para continuar..." ;;
        [rR]) ( restore_backups ) || echo -e "\e[31m[Error] Falló. Regresando al menú...\e[0m"
              read -p "Presione Enter para continuar..." ;;
        [qQ]) exit 0 ;;
        *) echo -e "\e[31mOpción inválida.\e[0m"; sleep 1 ;;
    esac
done

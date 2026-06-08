#!/bin/bash
set -euo pipefail
trap 'echo -e "\e[31m[ERROR] Script falló en la línea $LINENO\e[0m"' ERR

echo -e "\e[36mIniciando instalación del entorno en WSL (AlmaLinux 9)...\e[0m"

# Obtener directorio del repositorio
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Versiones congeladas para asegurar reproducibilidad
OMP_VERSION="v25.0.0"
EZA_VERSION="v0.20.2"
LAZYGIT_VERSION="0.48.0"
FASTFETCH_VERSION="2.38.0"

# Detectar arquitectura
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    OMP_ARCH="amd64"
    EZA_ARCH="x86_64"
    LAZYGIT_ARCH="x86_64"
    FASTFETCH_ARCH="amd64"
    OMP_SHA256="61b79c4ea5ab40927875eea2797ef74a2e7ed8d7cf1e2ab74b70c7bf8bab9074"
    EZA_SHA256="a926f4fdc50e85d218d6076b5bd7536f6560d0f4ce5e899c48d9d77c8d83d188"
    LAZYGIT_SHA256="291722c643a10805de3bd7b58f51d5275878269aeadb046709708f8683f558d7"
    FASTFETCH_SHA256="f61abf31129d0b932f47d40f2956df27d174b1f9cc775432bed11bdfbfb76aee"
elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    OMP_ARCH="arm64"
    EZA_ARCH="aarch64"
    LAZYGIT_ARCH="arm64"
    FASTFETCH_ARCH="aarch64"
    OMP_SHA256="dc60d5b5c3eeae998aa3cc9dd5d31f3e892f7a8abed86e843a839479db6f946c"
    EZA_SHA256="720b00b9f1244253600aecbc3377d5e5df886a6d0301d8a3c3ee917961586718"
    LAZYGIT_SHA256="37150ec77bd42d92b7dc96f05fca5f1cd310551936e32556011ac145ccd9d62b"
    FASTFETCH_SHA256="d8067104d7764802209bf760cfc0e72f3e98d37a4c3c2e0700f33f69d2a7547e"
else
    echo -e "\e[31mArquitectura $ARCH no soportada automáticamente.\e[0m"
    exit 1
fi

# 1. Instalar paquetes base (requiere sudo)
echo -e "\n\e[33m[1/7] Instalando Zsh, EPEL y utilidades...\e[0m"
sudo dnf install -y epel-release zsh git curl wget unzip tar util-linux-user jq file

# 2. Instalar herramientas de EPEL (FZF, Zoxide, Bat)
echo -e "\n\e[33m[2/7] Instalando FZF, Zoxide y Bat...\e[0m"
sudo dnf install -y fzf zoxide bat

# 3. Instalar Oh My Posh, Eza, LazyGit y Fastfetch (Descarga con validación robusta)
echo -e "\n\e[33m[3/7] Instalando utilidades desde GitHub releases...\e[0m"
WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT
cd "$WORK_DIR"

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

# Oh My Posh
echo "Descargando Oh My Posh (${OMP_VERSION})..."
wget --https-only -qO oh-my-posh "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/${OMP_VERSION}/posh-linux-${OMP_ARCH}" || { echo "Descarga falló"; exit 1; }
file oh-my-posh | grep -q 'ELF' || { echo "oh-my-posh no es un ejecutable válido (posible 404)"; exit 1; }
verify_sha256 oh-my-posh "$OMP_SHA256"
sudo mv oh-my-posh /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Eza
echo "Descargando Eza (${EZA_VERSION})..."
wget --https-only -qO eza.tar.gz "https://github.com/eza-community/eza/releases/download/${EZA_VERSION}/eza_${EZA_ARCH}-unknown-linux-gnu.tar.gz" || { echo "Descarga falló"; exit 1; }
file eza.tar.gz | grep -q 'gzip' || { echo "eza.tar.gz no es un tar.gz válido (posible 404)"; exit 1; }
verify_sha256 eza.tar.gz "$EZA_SHA256"
tar xzf eza.tar.gz
sudo mv eza /usr/local/bin/eza
sudo chmod +x /usr/local/bin/eza

# LazyGit
echo "Descargando LazyGit (v${LAZYGIT_VERSION})..."
wget --https-only -qO lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz" || { echo "Descarga falló"; exit 1; }
file lazygit.tar.gz | grep -q 'gzip' || { echo "lazygit.tar.gz no es un tar.gz válido (posible 404)"; exit 1; }
verify_sha256 lazygit.tar.gz "$LAZYGIT_SHA256"
tar xzf lazygit.tar.gz lazygit
sudo mv lazygit /usr/local/bin/lazygit
sudo chmod +x /usr/local/bin/lazygit

# Fastfetch
echo "Descargando Fastfetch (${FASTFETCH_VERSION})..."
wget --https-only -qO fastfetch.tar.gz "https://github.com/fastfetch-cli/fastfetch/releases/download/${FASTFETCH_VERSION}/fastfetch-linux-${FASTFETCH_ARCH}.tar.gz" || { echo "Descarga falló"; exit 1; }
file fastfetch.tar.gz | grep -q 'gzip' || { echo "fastfetch.tar.gz no es un tar.gz válido (posible 404)"; exit 1; }
verify_sha256 fastfetch.tar.gz "$FASTFETCH_SHA256"
tar xzf fastfetch.tar.gz
FF_DIR="fastfetch-linux-${FASTFETCH_ARCH}"
sudo mv "${FF_DIR}/usr/bin/fastfetch" /usr/local/bin/fastfetch
sudo chmod +x /usr/local/bin/fastfetch

# 4. Cambiar shell predeterminado de forma segura
echo -e "\n\e[33m[4/7] Configurando Zsh como shell por defecto...\e[0m"
if command -v zsh >/dev/null 2>&1; then
    sudo usermod -s "$(which zsh)" "$USER"
else
    echo -e "\e[31mError: Zsh no está instalado correctamente.\e[0m"
fi

# 5. Instalar Oh My Zsh y Plugins
echo -e "\n\e[33m[5/7] Instalando Oh My Zsh y plugins...\e[0m"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

# 6. Restaurar .zshrc
echo -e "\n\e[33m[6/7] Restaurando perfil .zshrc con backup...\e[0m"
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
    echo "Backup de .zshrc creado en ~/.zshrc.bak"
fi
cp "$DIR/linux/.zshrc" "$HOME/.zshrc"

# 7. Copiar Tema de Oh My Posh localmente
echo -e "\n\e[33m[7/7] Instalando tema local de Oh My Posh...\e[0m"
mkdir -p "$HOME/.config/omp"
cp "$DIR/themes/catppuccin_mocha.omp.json" "$HOME/.config/omp/catppuccin_mocha.omp.json"
echo "Tema local de Oh My Posh instalado."

echo -e "\n\e[32m=======================================================\e[0m"
echo -e "\e[32m¡INSTALACIÓN COMPLETADA EXITOSAMENTE EN WSL!\e[0m"
echo -e "\e[33mPor favor escribe 'zsh' o abre una nueva pestaña para disfrutar de tu entorno.\e[0m"
echo -e "\e[32m=======================================================\e[0m"

# Benchmark opcional de inicio
echo "Benchmark de inicio de shell:"
time zsh -i -c exit || true

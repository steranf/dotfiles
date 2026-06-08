#!/bin/bash
set -euo pipefail
trap 'echo -e "\e[31m[ERROR] Script falló en la línea $LINENO\e[0m"' ERR

echo -e "\e[36mIniciando instalación del entorno en WSL (AlmaLinux 9)...\e[0m"

# Obtener directorio del repositorio
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Detectar arquitectura
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    OMP_ARCH="amd64"
    EZA_ARCH="x86_64"
    LAZYGIT_ARCH="x86_64"
    FASTFETCH_ARCH="amd64"
elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    OMP_ARCH="arm64"
    EZA_ARCH="aarch64"
    LAZYGIT_ARCH="arm64"
    FASTFETCH_ARCH="aarch64"
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
cd /tmp

# Oh My Posh
echo "Descargando Oh My Posh (latest)..."
wget --https-only -qO oh-my-posh "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-${OMP_ARCH}" || { echo "Descarga falló"; exit 1; }
file oh-my-posh | grep -q 'ELF' || { echo "oh-my-posh no es un ejecutable válido (posible 404)"; exit 1; }
sudo mv oh-my-posh /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Eza
echo "Descargando Eza (latest)..."
wget --https-only -qO eza.tar.gz "https://github.com/eza-community/eza/releases/latest/download/eza_${EZA_ARCH}-unknown-linux-gnu.tar.gz" || { echo "Descarga falló"; exit 1; }
file eza.tar.gz | grep -q 'gzip' || { echo "eza.tar.gz no es un tar.gz válido (posible 404)"; exit 1; }
tar xzf eza.tar.gz
sudo mv eza /usr/local/bin/eza
sudo chmod +x /usr/local/bin/eza

# LazyGit
echo "Descargando LazyGit (latest)..."
# LazyGit release naming is tricky via latest/download directly due to version in filename, so we fetch the tag first via API.
LAZY_URL=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Eo "https://github.com/jesseduffield/lazygit/releases/download/[^\"]+Linux_${LAZYGIT_ARCH}.tar.gz")
if [ -z "$LAZY_URL" ]; then echo "No se pudo obtener URL de LazyGit"; exit 1; fi
wget --https-only -qO lazygit.tar.gz "$LAZY_URL" || { echo "Descarga falló"; exit 1; }
file lazygit.tar.gz | grep -q 'gzip' || { echo "lazygit.tar.gz no es un tar.gz válido (posible 404)"; exit 1; }
tar xzf lazygit.tar.gz lazygit
sudo mv lazygit /usr/local/bin/lazygit
sudo chmod +x /usr/local/bin/lazygit

# Fastfetch
echo "Descargando Fastfetch (latest)..."
FASTFETCH_URL=$(curl -s "https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest" | grep -Eo "https://github.com/fastfetch-cli/fastfetch/releases/download/[^\"]+linux-${FASTFETCH_ARCH}.tar.gz")
if [ -z "$FASTFETCH_URL" ]; then echo "No se pudo obtener URL de Fastfetch"; exit 1; fi
wget --https-only -qO fastfetch.tar.gz "$FASTFETCH_URL" || { echo "Descarga falló"; exit 1; }
file fastfetch.tar.gz | grep -q 'gzip' || { echo "fastfetch.tar.gz no es un tar.gz válido (posible 404)"; exit 1; }
tar xzf fastfetch.tar.gz
# Extracting exact bin path
FF_DIR=$(tar -tzf fastfetch.tar.gz | head -1 | cut -f1 -d"/")
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
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
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
time zsh -i -c exit

#!/bin/bash
set -e

echo -e "\e[36mIniciando instalación del entorno en WSL (AlmaLinux 9)...\e[0m"

# 1. Instalar paquetes base (requiere sudo)
echo -e "\n\e[33m[1/7] Instalando Zsh, EPEL y utilidades...\e[0m"
sudo dnf install -y epel-release zsh git curl wget unzip tar util-linux-user jq

# 2. Instalar herramientas de EPEL (FZF, Zoxide)
echo -e "\n\e[33m[2/7] Instalando FZF y Zoxide...\e[0m"
sudo dnf install -y fzf zoxide

# 3. Instalar Oh My Posh, Eza, LazyGit y Fastfetch (Descarga Segura)
echo -e "\n\e[33m[3/7] Instalando Oh My Posh, Eza, LazyGit y Fastfetch...\e[0m"
cd /tmp

# Oh My Posh
wget -qO oh-my-posh https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64
sudo mv oh-my-posh /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Eza
wget -qO eza.tar.gz https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz
tar xzf eza.tar.gz
sudo mv eza /usr/local/bin/eza
sudo chmod +x /usr/local/bin/eza

# LazyGit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
if [ -n "$LAZYGIT_VERSION" ]; then
    wget -qO lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xzf lazygit.tar.gz lazygit
    sudo mv lazygit /usr/local/bin/lazygit
    sudo chmod +x /usr/local/bin/lazygit
fi

# Fastfetch
wget -qO fastfetch.tar.gz https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.tar.gz
tar xzf fastfetch.tar.gz
sudo mv fastfetch-linux-amd64/usr/bin/fastfetch /usr/local/bin/fastfetch
sudo chmod +x /usr/local/bin/fastfetch

# 4. Cambiar shell predeterminado
echo -e "\n\e[33m[4/7] Configurando Zsh como shell por defecto...\e[0m"
sudo usermod -s /bin/zsh $USER

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
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
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

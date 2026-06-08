#!/bin/bash
set -e

echo -e "\e[36mIniciando instalación del entorno en WSL (AlmaLinux 9)...\e[0m"

# 1. Instalar paquetes base (requiere sudo)
echo -e "\n\e[33m[1/6] Instalando Zsh, EPEL y utilidades...\e[0m"
sudo dnf install -y epel-release zsh git curl unzip tar util-linux-user

# 2. Instalar herramientas de EPEL (FZF, Zoxide)
echo -e "\n\e[33m[2/6] Instalando FZF y Zoxide...\e[0m"
sudo dnf install -y fzf zoxide

# 3. Instalar Oh My Posh y Eza (binarios)
echo -e "\n\e[33m[3/6] Instalando Oh My Posh y Eza...\e[0m"
sudo sh -c 'curl -s https://ohmyposh.dev/install.sh | bash -s'
sudo sh -c 'curl -L https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz | tar xz -C /usr/local/bin; chmod +x /usr/local/bin/eza'

# 4. Cambiar shell predeterminado
echo -e "\n\e[33m[4/6] Configurando Zsh como shell por defecto...\e[0m"
sudo usermod -s /bin/zsh $USER

# 5. Instalar Oh My Zsh y Plugins
echo -e "\n\e[33m[5/6] Instalando Oh My Zsh y plugins...\e[0m"
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
echo -e "\n\e[33m[6/6] Restaurando perfil .zshrc...\e[0m"
# Obtener la ruta del directorio actual donde está el script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cp "$DIR/linux/.zshrc" "$HOME/.zshrc"

echo -e "\n\e[32m=======================================================\e[0m"
echo -e "\e[32m¡INSTALACIÓN COMPLETADA EXITOSAMENTE EN WSL!\e[0m"
echo -e "\e[33mPor favor escribe 'zsh' o abre una nueva pestaña para disfrutar de tu entorno.\e[0m"
echo -e "\e[32m=======================================================\e[0m"

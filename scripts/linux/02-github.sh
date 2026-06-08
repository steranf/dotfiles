#!/bin/bash
set -euo pipefail
trap 'echo -e "\e[31m[ERROR] Script falló en la línea $LINENO\e[0m"' ERR

source "$(dirname "$0")/env.sh"

echo -e "\n\e[33m[*] Instalando utilidades desde GitHub releases...\e[0m"
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
FF_DIR="fastfetch-linux-${FASTFETCH_ARCH}"
sudo mv "${FF_DIR}/usr/bin/fastfetch" /usr/local/bin/fastfetch
sudo chmod +x /usr/local/bin/fastfetch

# Neovim
echo "Descargando Neovim (${NVIM_VERSION})..."
wget --https-only -qO nvim.tar.gz "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-${NVIM_ARCH}.tar.gz" || { echo "Descarga falló"; exit 1; }
file nvim.tar.gz | grep -q 'gzip' || { echo "nvim.tar.gz no es un tar.gz válido"; exit 1; }
verify_sha256 nvim.tar.gz "$NVIM_SHA256"
tar xzf nvim.tar.gz
sudo cp -r nvim-linux-${NVIM_ARCH}/* /usr/local/

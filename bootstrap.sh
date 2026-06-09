#!/bin/bash
# bootstrap.sh — Zero-to-hero en un solo comando.
# Uso normal  : curl -fsSL https://raw.githubusercontent.com/steranf/dotfiles/main/bootstrap.sh | bash
# Modo silente: curl -fsSL ...bootstrap.sh | bash -s -- --all
# Directorio  : curl -fsSL ...bootstrap.sh | bash -s -- --dir ~/mis-dotfiles

set -euo pipefail
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# --- Colores ---
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
CYAN='\e[36m'
MAGENTA='\e[35m'
NC='\e[0m'

# --- Defaults ---
REPO_URL="https://github.com/steranf/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
PASSTHROUGH_ARGS=""

# --- Argumentos (compatibles con pipe: bash -s -- --flag) ---
while [[ $# -gt 0 ]]; do
    case "$1" in
    --dir)
        DOTFILES_DIR="$2"
        shift 2
        ;;
    --all)
        PASSTHROUGH_ARGS="--all"
        shift
        ;;
    -h | --help)
        echo "Uso: curl -fsSL URL | bash -s -- [--dir PATH] [--all]"
        echo "  --dir PATH  Directorio de destino (default: ~/dotfiles)"
        echo "  --all       Modo desatendido: salta el menú y lo instala todo"
        exit 0
        ;;
    *)
        echo -e "${RED}[ERROR] Opción desconocida: $1${NC}" >&2
        exit 1
        ;;
    esac
done

# --- Cabecera ---
echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${MAGENTA}   TERMINAL NIVEL DIOS — BOOTSTRAP        ${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""

# --- Avisos de entorno ---
if [ "$(id -u)" -eq 0 ]; then
    echo -e "${YELLOW}[!] Ejecutando como root. Se recomienda un usuario normal con sudo.${NC}"
fi
if [ -n "${WSL_DISTRO_NAME:-}" ]; then
    echo -e "${CYAN}[i] WSL detectado: ${WSL_DISTRO_NAME}${NC}"
fi
echo ""

# --- 1. Detectar gestor de paquetes ---
if command -v dnf >/dev/null 2>&1; then
    PKG_MGR="dnf"
    PKG_INSTALL="sudo dnf install -y"
elif command -v apt-get >/dev/null 2>&1; then
    PKG_MGR="apt-get"
    PKG_INSTALL="sudo apt-get install -y"
else
    echo -e "${RED}[ERROR] No se encontró gestor de paquetes compatible (dnf / apt-get).${NC}" >&2
    exit 1
fi
echo -e "${GREEN}[✓] Gestor de paquetes: ${PKG_MGR}${NC}"

# --- 2. Instalar git si no está presente ---
if ! command -v git >/dev/null 2>&1; then
    echo -e "${YELLOW}[*] Instalando git...${NC}"
    $PKG_INSTALL git
fi
echo -e "${GREEN}[✓] git $(git --version | awk '{print $3}')${NC}"

# --- 3. Clonar o actualizar el repositorio ---
if [ -d "${DOTFILES_DIR}/.git" ]; then
    echo -e "${YELLOW}[*] Dotfiles ya existen en ${DOTFILES_DIR} — actualizando...${NC}"
    git -C "$DOTFILES_DIR" pull --ff-only
else
    echo -e "${YELLOW}[*] Clonando dotfiles en ${DOTFILES_DIR}...${NC}"
    git clone "$REPO_URL" "$DOTFILES_DIR"
fi
echo -e "${GREEN}[✓] Repositorio listo en ${DOTFILES_DIR}${NC}"
echo ""

# --- 4. Lanzar instalador ---
# Redirigir stdin desde /dev/tty para que el menú interactivo funcione
# incluso cuando este script se ejecuta mediante pipe (curl | bash).
echo -e "${CYAN}Lanzando instalador...${NC}"
echo ""
if [ -n "$PASSTHROUGH_ARGS" ]; then
    bash "${DOTFILES_DIR}/install.sh" $PASSTHROUGH_ARGS
else
    bash "${DOTFILES_DIR}/install.sh" </dev/tty
fi

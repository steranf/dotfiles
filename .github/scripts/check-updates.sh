#!/bin/bash
# Verifica nuevas releases de las herramientas pinadas y actualiza env.sh.
# Ejecutado por .github/workflows/update-versions.yml (también funciona localmente).
set -euo pipefail

ENV_FILE="scripts/linux/env.sh"
CHANGED=false

# --- Helpers ---

gh_latest() {
    local tag
    tag=$(gh api "repos/$1/releases/latest" --jq '.tag_name' 2>/dev/null) || true
    printf '%s' "$tag"
}

sha256_of_url() {
    curl -fsSL "$1" | sha256sum | awk '{print $1}'
}

current_var() {
    grep "^export $1=" "$ENV_FILE" | grep -oP '(?<=")[^"]+'
}

set_var() {
    local key="$1" val
    # Escapa caracteres especiales del delimitador y replacement de sed
    val=$(printf '%s' "$2" | sed 's/[\\|&]/\\&/g')
    sed -i "s|^export ${key}=.*|export ${key}=\"${val}\"|" "$ENV_FILE"
}

bump() {
    local name="$1" latest_stored="$2" url_amd64="$3" url_arm64="$4"
    local current

    if [ -z "$latest_stored" ]; then
        echo "  [!] $name: no se pudo obtener la versión desde la API, omitiendo."
        return 0
    fi

    current=$(current_var "${name}_VERSION")

    if [ "$current" = "$latest_stored" ]; then
        echo "  ✓  $name ${current}"
        return 0
    fi

    echo "  ↑  $name: ${current} → ${latest_stored}"
    echo "     Descargando amd64 para SHA256..."
    local sha_amd64; sha_amd64=$(sha256_of_url "$url_amd64")
    echo "     Descargando arm64 para SHA256..."
    local sha_arm64; sha_arm64=$(sha256_of_url "$url_arm64")

    set_var "${name}_VERSION"      "$latest_stored"
    set_var "${name}_SHA256_AMD64" "$sha_amd64"
    set_var "${name}_SHA256_ARM64" "$sha_arm64"
    CHANGED=true
}

# --- Verificación por herramienta ---
echo ""
echo "Verificando versiones de herramientas pinadas..."
echo ""

# Oh My Posh  — tag con v  (v25.0.0), almacenado con v
tag=$(gh_latest "JanDeDobbeleer/oh-my-posh")
bump "OMP" "$tag" \
    "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/${tag}/posh-linux-amd64" \
    "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/${tag}/posh-linux-arm64"

# Eza  — tag con v  (v0.20.2), almacenado con v
tag=$(gh_latest "eza-community/eza")
bump "EZA" "$tag" \
    "https://github.com/eza-community/eza/releases/download/${tag}/eza_x86_64-unknown-linux-gnu.tar.gz" \
    "https://github.com/eza-community/eza/releases/download/${tag}/eza_aarch64-unknown-linux-gnu.tar.gz"

# LazyGit  — tag con v  (v0.48.0), almacenado SIN v  (0.48.0)
tag=$(gh_latest "jesseduffield/lazygit")
tag_nv="${tag#v}"
bump "LAZYGIT" "$tag_nv" \
    "https://github.com/jesseduffield/lazygit/releases/download/${tag}/lazygit_${tag_nv}_Linux_x86_64.tar.gz" \
    "https://github.com/jesseduffield/lazygit/releases/download/${tag}/lazygit_${tag_nv}_Linux_arm64.tar.gz"

# Fastfetch  — tag SIN v  (2.38.0), almacenado sin v
tag=$(gh_latest "fastfetch-cli/fastfetch")
bump "FASTFETCH" "$tag" \
    "https://github.com/fastfetch-cli/fastfetch/releases/download/${tag}/fastfetch-linux-amd64.tar.gz" \
    "https://github.com/fastfetch-cli/fastfetch/releases/download/${tag}/fastfetch-linux-aarch64.tar.gz"

# Neovim  — tag con v  (v0.12.2), almacenado con v
tag=$(gh_latest "neovim/neovim")
bump "NVIM" "$tag" \
    "https://github.com/neovim/neovim/releases/download/${tag}/nvim-linux-x86_64.tar.gz" \
    "https://github.com/neovim/neovim/releases/download/${tag}/nvim-linux-arm64.tar.gz"

# NVM  — script shell: una sola URL, un solo SHA256, variable NVM_INSTALL_VERSION
tag=$(gh_latest "nvm-sh/nvm")
if [ -z "$tag" ]; then
    echo "  [!] NVM: no se pudo obtener la versión desde la API, omitiendo."
else
    current=$(current_var "NVM_INSTALL_VERSION")
    if [ "$current" = "$tag" ]; then
        echo "  ✓  NVM ${current}"
    else
        echo "  ↑  NVM: ${current} → ${tag}"
        echo "     Descargando install.sh para SHA256..."
        sha=$(sha256_of_url "https://raw.githubusercontent.com/nvm-sh/nvm/${tag}/install.sh")
        set_var "NVM_INSTALL_VERSION" "$tag"
        set_var "NVM_SHA256"          "$sha"
        CHANGED=true
    fi
fi

# --- Resultado ---
echo ""
if [ "$CHANGED" = "true" ]; then
    echo "Actualizaciones aplicadas en ${ENV_FILE}."
    echo "updates_found=true" >> "${GITHUB_OUTPUT:-/dev/null}"
else
    echo "Todas las herramientas están al día."
    echo "updates_found=false" >> "${GITHUB_OUTPUT:-/dev/null}"
fi

#!/bin/bash
# env.sh - Variables globales para instaladores de Linux

# Directorio raíz del repositorio (resolviendo desde scripts/linux)
export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." &>/dev/null && pwd)"

# --- Versiones y checksums (actualizados automáticamente por update-versions.yml) ---
export OMP_VERSION="v31.9.1"
export OMP_SHA256_AMD64="574074a4e84797180e0bda0d133da5f01fbda89ecdb450134c7e566b9a389212"
export OMP_SHA256_ARM64="a04e7aed0d233ac861161c0f3d4d70912b0747764fd5b10f6bd19c0b6510eb49"

export EZA_VERSION="v0.23.5"
export EZA_SHA256_AMD64="35c70c5c43c29108075e58b893234c67ef585f0b53a7eaf8e9e7d4eec9f339b4"
export EZA_SHA256_ARM64="40b87ae8628aa2ff0f0d2dc24ab52f689631366385c3da630bae745671fd71ec"

export LAZYGIT_VERSION="0.66.2"
export LAZYGIT_SHA256_AMD64="158efc9ddfa1241fab5fb3526bb442c8dc6c4b1904d73213b9e4e93e03c52034"
export LAZYGIT_SHA256_ARM64="79a3161eeb642f0473e23db6341f7baabd4a5933e921a9c1167c5d5c765c41a4"

export FASTFETCH_VERSION="2.70.0"
export FASTFETCH_SHA256_AMD64="945b941b2a85e8de88b4c89714ad18ee6a7a129bb3c544bb448e9e0e027c226a"
export FASTFETCH_SHA256_ARM64="fff4a127e4d76242e3bdac2a12430fc252fd6086d3eb30aee0382c3b0fece478"

export NVIM_VERSION="v0.12.6"
export NVIM_SHA256_AMD64="474430d53e6264f6d6dd18db42d6dc9df3a1b56ca9e88a325bbf860e1a811d87"
export NVIM_SHA256_ARM64="8f1f64a0bdb97247034038c3823c6cbad5bdf9ecd5751b85494b71c3ee04c815"

export ZSH_AUTOSUGGESTIONS_VERSION="v0.7.1"
export ZSH_SYNTAX_HIGHLIGHTING_VERSION="0.8.0"
export ZSH_OMZ_COMMIT="630a7c04c309a53f15e6a433c859867db17cc90e"

export NVM_INSTALL_VERSION="v0.40.8"
export NVM_SHA256="48a0eee9a60e07422dce0eb5774754c83889570ca1ee2566c516acbe8af03a9e"

# --- Detección de arquitectura ---
export ARCH
ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
    export OMP_ARCH="amd64" EZA_ARCH="x86_64" LAZYGIT_ARCH="x86_64"
    export FASTFETCH_ARCH="amd64" NVIM_ARCH="x86_64"
    export OMP_SHA256="$OMP_SHA256_AMD64"
    export EZA_SHA256="$EZA_SHA256_AMD64"
    export LAZYGIT_SHA256="$LAZYGIT_SHA256_AMD64"
    export FASTFETCH_SHA256="$FASTFETCH_SHA256_AMD64"
    export NVIM_SHA256="$NVIM_SHA256_AMD64"
elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    export OMP_ARCH="arm64" EZA_ARCH="aarch64" LAZYGIT_ARCH="arm64"
    export FASTFETCH_ARCH="aarch64" NVIM_ARCH="arm64"
    export OMP_SHA256="$OMP_SHA256_ARM64"
    export EZA_SHA256="$EZA_SHA256_ARM64"
    export LAZYGIT_SHA256="$LAZYGIT_SHA256_ARM64"
    export FASTFETCH_SHA256="$FASTFETCH_SHA256_ARM64"
    export NVIM_SHA256="$NVIM_SHA256_ARM64"
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
export -f verify_sha256

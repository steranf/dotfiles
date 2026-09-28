#!/bin/bash
# env.sh - Variables globales para instaladores de Linux

# Directorio raíz del repositorio (resolviendo desde scripts/linux)
export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." &>/dev/null && pwd)"

# --- Versiones y checksums (actualizados automáticamente por update-versions.yml) ---
export OMP_VERSION="v31.4.0"
export OMP_SHA256_AMD64="28ba5d5ec77fbcd6d2681674f6dd92760e07c5f4eb58927b6f9b03d1dd039fd4"
export OMP_SHA256_ARM64="dcc5ea2c9c79eda9c89f4790404a84df3f4d0401eefdd949ff91ff91723e5367"

export EZA_VERSION="v0.23.5"
export EZA_SHA256_AMD64="35c70c5c43c29108075e58b893234c67ef585f0b53a7eaf8e9e7d4eec9f339b4"
export EZA_SHA256_ARM64="40b87ae8628aa2ff0f0d2dc24ab52f689631366385c3da630bae745671fd71ec"

export LAZYGIT_VERSION="0.65.1"
export LAZYGIT_SHA256_AMD64="02beacbcda0fa342e50ae3480ba8147307353af3fb28e1d5f790e02329c201a6"
export LAZYGIT_SHA256_ARM64="49abecdf6adf4f2dfdb11bf7b9bfada267ea523612ed809d1c6d87f6c04000a7"

export FASTFETCH_VERSION="2.69.0"
export FASTFETCH_SHA256_AMD64="9fe880a34de3fec88e57a69230c02fd7be0846db3f3ea9f88f2b74489a79ff55"
export FASTFETCH_SHA256_ARM64="843a0d4e3d604efc7cce18df1efcc09b00a1960cfea9949118b50bf999694027"

export NVIM_VERSION="v0.12.5"
export NVIM_SHA256_AMD64="bce0f56eda1f1b1db6eee8f4133d7a38813ea07933837dd1777411ca384c6875"
export NVIM_SHA256_ARM64="1aa5ca085249580ae0f91eb14f27ec0919773ff2d99a163d03f3d6c21ac29725"

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

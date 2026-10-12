#!/bin/bash
# env.sh - Variables globales para instaladores de Linux

# Directorio raíz del repositorio (resolviendo desde scripts/linux)
export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." &>/dev/null && pwd)"

# --- Versiones y checksums (actualizados automáticamente por update-versions.yml) ---
export OMP_VERSION="v31.8.0"
export OMP_SHA256_AMD64="c0e1c088d2b366a60e5f4047a5eb02cf6f10b03989191bbc564d733aafba307f"
export OMP_SHA256_ARM64="c7ee6d1075b625a4f151bf177defbaed55995b2fcd98e410c7990d2394c3fd80"

export EZA_VERSION="v0.23.5"
export EZA_SHA256_AMD64="35c70c5c43c29108075e58b893234c67ef585f0b53a7eaf8e9e7d4eec9f339b4"
export EZA_SHA256_ARM64="40b87ae8628aa2ff0f0d2dc24ab52f689631366385c3da630bae745671fd71ec"

export LAZYGIT_VERSION="0.66.1"
export LAZYGIT_SHA256_AMD64="7b3f30c2c06a42cf575280f907e58d7ea08411408b6b62bc926bc91cbc6c3f46"
export LAZYGIT_SHA256_ARM64="add91327af13343f37d2d610512d0982ef5c75da5cc962b5159748adc8a11a86"

export FASTFETCH_VERSION="2.69.0"
export FASTFETCH_SHA256_AMD64="9fe880a34de3fec88e57a69230c02fd7be0846db3f3ea9f88f2b74489a79ff55"
export FASTFETCH_SHA256_ARM64="843a0d4e3d604efc7cce18df1efcc09b00a1960cfea9949118b50bf999694027"

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

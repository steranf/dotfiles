#!/bin/bash
# env.sh - Variables globales para instaladores de Linux

# Directorio raíz del repositorio (resolviendo desde scripts/linux)
export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." &>/dev/null && pwd)"

# --- Versiones y checksums (actualizados automáticamente por update-versions.yml) ---
export OMP_VERSION="v31.1.3"
export OMP_SHA256_AMD64="c9c2f59618ff72ca1acc38e1cd87aa3198311bc5d4814e793f525dd1dfb522b5"
export OMP_SHA256_ARM64="1f80cf4d12aa54e01b0edfecf5d4041187abdb7d58e0afcb8748158cbe1ced5c"

export EZA_VERSION="v0.23.5"
export EZA_SHA256_AMD64="35c70c5c43c29108075e58b893234c67ef585f0b53a7eaf8e9e7d4eec9f339b4"
export EZA_SHA256_ARM64="40b87ae8628aa2ff0f0d2dc24ab52f689631366385c3da630bae745671fd71ec"

export LAZYGIT_VERSION="0.65.0"
export LAZYGIT_SHA256_AMD64="44d8e7dd1484b4a66e191bd4ab25a71e8b4b3a65ab122f838e65677ef58c5506"
export LAZYGIT_SHA256_ARM64="d954a09c128bd37b2bd0d254308474e87de3729cfe0e37f5b46a49357a4fe257"

export FASTFETCH_VERSION="2.68.1"
export FASTFETCH_SHA256_AMD64="0c51ef6fa3e976eb5038fe0afda38629d3ca07947740bb0e3354c7c4f1238c0c"
export FASTFETCH_SHA256_ARM64="d3369aa9c1bc77fd8bd7ba3be2ae2cdcece4a137620c48a9de58026779fdb7d4"

export NVIM_VERSION="v0.12.5"
export NVIM_SHA256_AMD64="bce0f56eda1f1b1db6eee8f4133d7a38813ea07933837dd1777411ca384c6875"
export NVIM_SHA256_ARM64="1aa5ca085249580ae0f91eb14f27ec0919773ff2d99a163d03f3d6c21ac29725"

export ZSH_AUTOSUGGESTIONS_VERSION="v0.7.1"
export ZSH_SYNTAX_HIGHLIGHTING_VERSION="0.8.0"
export ZSH_OMZ_COMMIT="630a7c04c309a53f15e6a433c859867db17cc90e"

export NVM_INSTALL_VERSION="v0.40.7"
export NVM_SHA256="066ce4eaf4d78eaa6410433bc9ba58faaba646157cbbed6109153e6c24c5f8a5"

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

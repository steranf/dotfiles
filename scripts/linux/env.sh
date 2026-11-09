#!/bin/bash
# env.sh - Variables globales para instaladores de Linux

# Directorio raíz del repositorio (resolviendo desde scripts/linux)
export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." &>/dev/null && pwd)"

# --- Versiones y checksums (actualizados automáticamente por update-versions.yml) ---
export OMP_VERSION="v32.0.0"
export OMP_SHA256_AMD64="55f9b15e49827bf2d79bdafde28e93808b6f84be7677db8e3b2196772b081a26"
export OMP_SHA256_ARM64="081cef86e1b8a1a0b90b70d7b1ae1737bfc89702f2bcc079aef389e080d51004"

export EZA_VERSION="v0.23.5"
export EZA_SHA256_AMD64="35c70c5c43c29108075e58b893234c67ef585f0b53a7eaf8e9e7d4eec9f339b4"
export EZA_SHA256_ARM64="40b87ae8628aa2ff0f0d2dc24ab52f689631366385c3da630bae745671fd71ec"

export LAZYGIT_VERSION="0.66.3"
export LAZYGIT_SHA256_AMD64="0a23f429a95f0d09db298b3c291536d818de066aa5a85c255806f0490ff6656b"
export LAZYGIT_SHA256_ARM64="ac0b48237f3d0283813e7154ec063237e519532feb0470c0881a1793ee78fd42"

export FASTFETCH_VERSION="2.71.0"
export FASTFETCH_SHA256_AMD64="abf5c99a3702cce8d3c7fa2cccd3ac205076ae0f2e45bced24a42a68821702d6"
export FASTFETCH_SHA256_ARM64="458248f2b3abab9c5e0a5b9df12cdcd1a966b355ddd5f3244a5eb47d17d33412"

export NVIM_VERSION="v0.12.6"
export NVIM_SHA256_AMD64="474430d53e6264f6d6dd18db42d6dc9df3a1b56ca9e88a325bbf860e1a811d87"
export NVIM_SHA256_ARM64="8f1f64a0bdb97247034038c3823c6cbad5bdf9ecd5751b85494b71c3ee04c815"

export ZSH_AUTOSUGGESTIONS_VERSION="v0.7.1"
export ZSH_SYNTAX_HIGHLIGHTING_VERSION="0.8.0"
export ZSH_OMZ_COMMIT="630a7c04c309a53f15e6a433c859867db17cc90e"

export NVM_INSTALL_VERSION="v0.41.0"
export NVM_SHA256="045932fe05f0d4247c946f2ec0ec4026dbfd8ce88a5f67ea28d8ea833227f48b"

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

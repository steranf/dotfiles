#!/bin/bash
# env.sh - Variables globales para instaladores de Linux

# Directorio raíz del repositorio (resolviendo desde scripts/linux)
export DIR
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." &> /dev/null && pwd )"

# --- Versiones y checksums (actualizados automáticamente por update-versions.yml) ---
export OMP_VERSION="v25.0.0"
export OMP_SHA256_AMD64="61b79c4ea5ab40927875eea2797ef74a2e7ed8d7cf1e2ab74b70c7bf8bab9074"
export OMP_SHA256_ARM64="dc60d5b5c3eeae998aa3cc9dd5d31f3e892f7a8abed86e843a839479db6f946c"

export EZA_VERSION="v0.20.2"
export EZA_SHA256_AMD64="a926f4fdc50e85d218d6076b5bd7536f6560d0f4ce5e899c48d9d77c8d83d188"
export EZA_SHA256_ARM64="720b00b9f1244253600aecbc3377d5e5df886a6d0301d8a3c3ee917961586718"

export LAZYGIT_VERSION="0.48.0"
export LAZYGIT_SHA256_AMD64="291722c643a10805de3bd7b58f51d5275878269aeadb046709708f8683f558d7"
export LAZYGIT_SHA256_ARM64="37150ec77bd42d92b7dc96f05fca5f1cd310551936e32556011ac145ccd9d62b"

export FASTFETCH_VERSION="2.38.0"
export FASTFETCH_SHA256_AMD64="f61abf31129d0b932f47d40f2956df27d174b1f9cc775432bed11bdfbfb76aee"
export FASTFETCH_SHA256_ARM64="d8067104d7764802209bf760cfc0e72f3e98d37a4c3c2e0700f33f69d2a7547e"

export NVIM_VERSION="v0.12.2"
export NVIM_SHA256_AMD64="31cf85945cb600d96cdf69f88bc68bec814acbff50863c5546adef3a1bcef260"
export NVIM_SHA256_ARM64="f697d4e4582b6e4b5c3c26e76e06ce26efa08ba1768e03fd2733fcc422bb0490"

export ZSH_AUTOSUGGESTIONS_VERSION="v0.7.1"
export ZSH_SYNTAX_HIGHLIGHTING_VERSION="0.8.0"

# --- Detección de arquitectura ---
export ARCH
ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
    export OMP_ARCH="amd64"      EZA_ARCH="x86_64"  LAZYGIT_ARCH="x86_64"
    export FASTFETCH_ARCH="amd64" NVIM_ARCH="x86_64"
    export OMP_SHA256="$OMP_SHA256_AMD64"
    export EZA_SHA256="$EZA_SHA256_AMD64"
    export LAZYGIT_SHA256="$LAZYGIT_SHA256_AMD64"
    export FASTFETCH_SHA256="$FASTFETCH_SHA256_AMD64"
    export NVIM_SHA256="$NVIM_SHA256_AMD64"
elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    export OMP_ARCH="arm64"       EZA_ARCH="aarch64" LAZYGIT_ARCH="arm64"
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

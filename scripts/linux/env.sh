#!/bin/bash
# env.sh - Variables globales para instaladores de Linux

# Directorio raíz del repositorio (resolviendo desde scripts/linux)
export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." &>/dev/null && pwd)"

# --- Versiones y checksums (actualizados automáticamente por update-versions.yml) ---
export OMP_VERSION="v29.14.0"
export OMP_SHA256_AMD64="7f345282675ab5e93edea15975642b55f3639ce5e0f0f39dfdb9fecb4c025e02"
export OMP_SHA256_ARM64="96cbdfe6892c8d955e5aef5f64322dd0947db1d3328c99873e8d0a6d2914c395"

export EZA_VERSION="v0.23.4"
export EZA_SHA256_AMD64="0c38665440226cd8bef5d1d4f3bc6ff77c927fb0d68b752739105db7ab5b358d"
export EZA_SHA256_ARM64="366e8430225f9955c3dc659b452150c169894833ccfef455e01765e265a3edda"

export LAZYGIT_VERSION="0.62.2"
export LAZYGIT_SHA256_AMD64="8b9a4c2d0969cbea92b45c956dd2a44e1ba76900c9df49f1c60984045ce77984"
export LAZYGIT_SHA256_ARM64="9ab63dd75a7e9711c4c68a37d77f4334b8099a5d6a3f8fbe8f4e2768b159c9e9"

export FASTFETCH_VERSION="2.64.2"
export FASTFETCH_SHA256_AMD64="5dc341ec4853ddeb0c0efa62e033fed57b0a00f7d805ebb6d354241ca244aba5"
export FASTFETCH_SHA256_ARM64="f69dc4779dc65f48fa0c2d54d45ad7abbe5fcdf9b979c7104018b965400bcca7"

export NVIM_VERSION="v0.12.2"
export NVIM_SHA256_AMD64="31cf85945cb600d96cdf69f88bc68bec814acbff50863c5546adef3a1bcef260"
export NVIM_SHA256_ARM64="f697d4e4582b6e4b5c3c26e76e06ce26efa08ba1768e03fd2733fcc422bb0490"

export ZSH_AUTOSUGGESTIONS_VERSION="v0.7.1"
export ZSH_SYNTAX_HIGHLIGHTING_VERSION="0.8.0"
export ZSH_OMZ_COMMIT="630a7c04c309a53f15e6a433c859867db17cc90e"

export NVM_INSTALL_VERSION="v0.40.5"
export NVM_SHA256="582070e4c44452c1d8d68e16fc786c2216ecba6bc6bf18dc280a03fdba6ed1a9"

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

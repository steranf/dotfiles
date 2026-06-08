#!/bin/bash
# Script de Auditoría Post-Instalación

echo -e "\e[36m====================================================\e[0m"
echo -e "\e[36m   AUDITORÍA DE ENTORNO: TERMINAL NIVEL DIOS        \e[0m"
echo -e "\e[36m====================================================\e[0m"

# Función para verificar dependencias
check_tool() {
    local tool=$1
    local name=$2
    local version_cmd=$3

    # Verifica si el comando existe
    if command -v "$tool" >/dev/null 2>&1; then
        if [ -n "$version_cmd" ]; then
            # Obtener versión silenciando posibles errores
            local version=$(eval "$version_cmd" 2>/dev/null | head -n 1 | awk '{$1=$1;print}')
            echo -e "\e[32m[✓] $name\e[0m - Encontrado ($version)"
        else
            echo -e "\e[32m[✓] $name\e[0m - Encontrado"
        fi
        return 0
    else
        echo -e "\e[31m[x] $name\e[0m - NO ENCONTRADO"
        return 1
    fi
}

declare -i errors=0

echo -e "\n\e[33m--- Herramientas Core ---\e[0m"
check_tool "zsh" "Zsh Shell" "zsh --version | awk '{print \$2}'" || errors+=1
check_tool "pwsh.exe" "PowerShell (Windows)" "pwsh.exe --version | sed 's/PowerShell //'" || check_tool "pwsh" "PowerShell (Linux)" "pwsh --version | sed 's/PowerShell //'" || echo -e "\e[33m[!] PowerShell no detectado en el PATH de WSL\e[0m"

echo -e "\n\e[33m--- Utilidades de Terminal ---\e[0m"
check_tool "oh-my-posh" "Oh My Posh" "oh-my-posh --version" || errors+=1
check_tool "fastfetch" "Fastfetch" "fastfetch --version | awk '{print \$2}'" || errors+=1
check_tool "lazygit" "LazyGit" "lazygit --version | awk '{print \$6}' | tr -d 'v,' " || errors+=1
check_tool "fzf" "FZF (Buscador)" "fzf --version | awk '{print \$1}'" || errors+=1
check_tool "zoxide" "Zoxide" "zoxide --version | awk '{print \$2}'" || errors+=1
check_tool "bat" "Bat (o Batcat)" "bat --version | awk '{print \$2}'" || check_tool "batcat" "Bat (o Batcat)" "batcat --version | awk '{print \$2}'" || errors+=1
check_tool "eza" "Eza (Listados)" "eza --version | grep -Eo 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1" || errors+=1

echo -e "\n\e[36m====================================================\e[0m"
if [ $errors -eq 0 ]; then
    echo -e "\e[32mResultado: Excelente. Todas las herramientas están instaladas y funcionando.\e[0m"
else
    echo -e "\e[31mResultado: Se encontraron $errors herramienta(s) faltantes. Revisa tu instalación.\e[0m"
    exit 1
fi
echo -e "\e[36m====================================================\e[0m"

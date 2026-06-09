#!/bin/bash
# Script de Auditoría Post-Instalación

echo -e "\e[36m====================================================\e[0m"
echo -e "\e[36m   AUDITORÍA DE ENTORNO: TERMINAL NIVEL DIOS        \e[0m"
echo -e "\e[36m====================================================\e[0m"

# Función para verificar dependencias
check_tool() {
    local tool=$1
    local name=$2
    local version=""

    # Verifica si el comando existe
    if command -v "$tool" >/dev/null 2>&1; then
        case "$tool" in
        "zsh") version=$(zsh --version 2>/dev/null | awk '{print $2}') ;;
        "pwsh.exe") version=$(pwsh.exe --version 2>/dev/null | sed 's/PowerShell //') ;;
        "pwsh") version=$(pwsh --version 2>/dev/null | sed 's/PowerShell //') ;;
        "oh-my-posh") version=$(oh-my-posh --version 2>/dev/null) ;;
        "fastfetch") version=$(fastfetch --version 2>/dev/null | awk '{print $2}') ;;
        "lazygit") version=$(lazygit --version 2>/dev/null | awk '{print $6}' | tr -d 'v,') ;;
        "fzf") version=$(fzf --version 2>/dev/null | awk '{print $1}') ;;
        "zoxide") version=$(zoxide --version 2>/dev/null | awk '{print $2}') ;;
        "bat" | "batcat") version=$($tool --version 2>/dev/null | awk '{print $2}') ;;
        "eza") version=$(eza --version 2>/dev/null | grep -Eo 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1) ;;
        "nvim") version=$(nvim --version 2>/dev/null | head -1 | awk '{print $2}') ;;
        "rg") version=$(rg --version 2>/dev/null | head -1 | awk '{print $2}') ;;
        "fd" | "fdfind") version=$($tool --version 2>/dev/null | awk '{print $NF}') ;;
        esac

        if [ -n "$version" ]; then
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
check_tool "zsh" "Zsh Shell" || errors+=1
check_tool "pwsh.exe" "PowerShell (Windows)" || check_tool "pwsh" "PowerShell (Linux)" || echo -e "\e[33m[!] PowerShell no detectado en el PATH de WSL\e[0m"

echo -e "\n\e[33m--- Oh My Zsh ---\e[0m"

if [ -d "$HOME/.oh-my-zsh" ]; then
    omz_commit=$(git -C "$HOME/.oh-my-zsh" rev-parse --short HEAD 2>/dev/null || echo "desconocido")
    echo -e "\e[32m[✓] Oh My Zsh\e[0m - Encontrado (commit ${omz_commit})"
else
    echo -e "\e[31m[x] Oh My Zsh\e[0m - NO ENCONTRADO (~/.oh-my-zsh ausente)"
    errors+=1
fi

for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    plugin_dir="$HOME/.oh-my-zsh/custom/plugins/$plugin"
    if [ -d "$plugin_dir" ]; then
        echo -e "\e[32m[✓] Plugin: $plugin\e[0m - Encontrado"
    else
        echo -e "\e[31m[x] Plugin: $plugin\e[0m - NO ENCONTRADO ($plugin_dir ausente)"
        errors+=1
    fi
done

echo -e "\n\e[33m--- Utilidades de Terminal ---\e[0m"
check_tool "oh-my-posh" "Oh My Posh" || errors+=1
check_tool "fastfetch" "Fastfetch" || errors+=1
check_tool "lazygit" "LazyGit" || errors+=1
check_tool "fzf" "FZF (Buscador)" || errors+=1
check_tool "zoxide" "Zoxide" || errors+=1
check_tool "bat" "Bat (o Batcat)" || check_tool "batcat" "Bat (o Batcat)" || errors+=1
check_tool "eza" "Eza (Listados)" || errors+=1
check_tool "nvim" "Neovim" || errors+=1
check_tool "rg" "Ripgrep" || errors+=1
check_tool "fd" "Fd" || check_tool "fdfind" "Fd" || errors+=1

echo -e "\n\e[33m--- Gestores de Versiones ---\e[0m"

if [ -s "$HOME/.nvm/nvm.sh" ]; then
    # shellcheck disable=SC1091
    . "$HOME/.nvm/nvm.sh"
    nvm_ver=$(nvm --version 2>/dev/null)
    echo -e "\e[32m[✓] NVM (Node Version Manager)\e[0m - Encontrado ($nvm_ver)"
else
    echo -e "\e[31m[x] NVM (Node Version Manager)\e[0m - NO ENCONTRADO (~/.nvm/nvm.sh ausente)"
    errors+=1
fi

if [ -x "$HOME/.pyenv/bin/pyenv" ]; then
    pyenv_ver=$("$HOME/.pyenv/bin/pyenv" --version 2>/dev/null | awk '{print $2}')
    echo -e "\e[32m[✓] Pyenv\e[0m - Encontrado ($pyenv_ver)"
else
    echo -e "\e[31m[x] Pyenv\e[0m - NO ENCONTRADO (~/.pyenv/bin/pyenv ausente)"
    errors+=1
fi

echo -e "\n\e[36m====================================================\e[0m"
if [ $errors -eq 0 ]; then
    echo -e "\e[32mResultado: Excelente. Todas las herramientas están instaladas y funcionando.\e[0m"
else
    echo -e "\e[31mResultado: Se encontraron $errors herramienta(s) faltantes. Revisa tu instalación.\e[0m"
    exit 1
fi
echo -e "\e[36m====================================================\e[0m"

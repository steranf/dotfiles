#!/bin/bash
# Actualiza Oh My Zsh, plugins de Zsh y los dotfiles desde el repositorio.
# Para actualizar herramientas de GitHub Releases, edita las versiones en
# install.sh y ejecuta la opción [3] del instalador interactivo.
set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ENV_FILE="$DIR/scripts/linux/env.sh"

echo -e "\e[36m==========================================\e[0m"
echo -e "\e[35m   TERMINAL NIVEL DIOS - ACTUALIZADOR     \e[0m"
echo -e "\e[36m==========================================\e[0m"

echo -e "\n\e[33m[*] Actualizando Oh My Zsh...\e[0m"
if [ -d "$HOME/.oh-my-zsh" ]; then
    prev_commit=$(git -C "$HOME/.oh-my-zsh" rev-parse HEAD)
    git -C "$HOME/.oh-my-zsh" pull --ff-only
    new_commit=$(git -C "$HOME/.oh-my-zsh" rev-parse HEAD)
    echo -e "\e[32m[✓] Oh My Zsh actualizado.\e[0m"
    if [ "$prev_commit" != "$new_commit" ]; then
        sed -i "s|^export ZSH_OMZ_COMMIT=.*|export ZSH_OMZ_COMMIT=\"${new_commit}\"|" "$ENV_FILE"
        echo -e "\e[32m[✓] ZSH_OMZ_COMMIT: ${prev_commit:0:8} → ${new_commit:0:8}\e[0m"
    fi
else
    echo -e "\e[33m[!] Oh My Zsh no encontrado, omitiendo.\e[0m"
fi

echo -e "\n\e[33m[*] Actualizando plugins de Zsh...\e[0m"
for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    plugin_dir="$HOME/.oh-my-zsh/custom/plugins/$plugin"
    if [ -d "$plugin_dir" ]; then
        echo "  Actualizando $plugin..."
        git -C "$plugin_dir" pull --ff-only && echo -e "  \e[32m[✓] $plugin actualizado.\e[0m"
    else
        echo -e "  \e[33m[!] $plugin no encontrado en $plugin_dir\e[0m"
    fi
done

echo -e "\n\e[33m[*] Actualizando dotfiles desde el repositorio...\e[0m"
git -C "$DIR" pull --ff-only && echo -e "\e[32m[✓] Dotfiles actualizados.\e[0m"

echo -e "\n\e[32m==========================================\e[0m"
echo -e "\e[32m¡Actualización completa!\e[0m"
echo -e "\e[33mPara actualizar herramientas de GitHub Releases,\e[0m"
echo -e "\e[33medita las versiones en install.sh y ejecuta la opción [3].\e[0m"
echo -e "\e[32m==========================================\e[0m"

#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
OS="$(uname -s)"

function run_all {
    if [ "$OS" = "Darwin" ]; then
        bash "$DIR/scripts/macos/01-core.sh"
        bash "$DIR/scripts/macos/03-shell.sh"
        bash "$DIR/scripts/macos/04-neovim.sh"
        bash "$DIR/scripts/macos/05-dev.sh"
        echo -e "\n\e[32m=======================================================\e[0m"
        echo -e "\e[32m¡INSTALACIÓN COMPLETADA EN MACOS!\e[0m"
        echo -e "\e[33mAbre una nueva pestaña de terminal para disfrutar de tu entorno.\e[0m"
        echo -e "\e[32m=======================================================\e[0m"
    else
        bash "$DIR/scripts/linux/01-core.sh"
        bash "$DIR/scripts/linux/02-github.sh"
        bash "$DIR/scripts/linux/03-shell.sh"
        bash "$DIR/scripts/linux/04-neovim.sh"
        bash "$DIR/scripts/linux/05-dev.sh"
        echo -e "\n\e[32m=======================================================\e[0m"
        echo -e "\e[32m¡INSTALACIÓN COMPLETADA EXITOSAMENTE EN WSL!\e[0m"
        echo -e "\e[33mPor favor escribe 'zsh' o abre una nueva pestaña para disfrutar de tu entorno.\e[0m"
        echo -e "\e[32m=======================================================\e[0m"
    fi
}

if [[ "${1:-}" == "--all" || "${1:-}" == "-a" ]]; then
    run_all
    exit 0
fi

if [ "$OS" = "Darwin" ]; then
    while true; do
        clear
        echo -e "\e[36m==========================================\e[0m"
        echo -e "\e[35m   TERMINAL NIVEL DIOS - INSTALADOR (MACOS)\e[0m"
        echo -e "\e[36m==========================================\e[0m"
        echo " [1] Instalación Completa (Modo Dios)"
        echo " [2] Instalar Herramientas (Homebrew)"
        echo " [3] Configurar Oh My Zsh, Git y Temas"
        echo " [4] Configurar Neovim (LazyVim)"
        echo " [5] Instalar NVM y Pyenv"
        echo ""
        echo -e " \e[33m[R] Revertir (Restaurar configuraciones originales)\e[0m"
        echo -e " \e[31m[Q] Salir\e[0m"
        echo -e "\e[36m==========================================\e[0m"

        read -r -p "Seleccione una opción: " opt

        case "$opt" in
        1)
            (run_all) || echo -e "\e[31m[Error] La instalación falló. Revisa los mensajes de arriba.\e[0m"
            read -r -p "Presione Enter para continuar..."
            break
            ;;
        2)
            (bash "$DIR/scripts/macos/01-core.sh") || echo -e "\e[31m[Error] Falló. Regresando al menú...\e[0m"
            read -r -p "Presione Enter para continuar..."
            ;;
        3)
            (bash "$DIR/scripts/macos/03-shell.sh") || echo -e "\e[31m[Error] Falló. Regresando al menú...\e[0m"
            read -r -p "Presione Enter para continuar..."
            ;;
        4)
            (bash "$DIR/scripts/macos/04-neovim.sh") || echo -e "\e[31m[Error] Falló. Regresando al menú...\e[0m"
            read -r -p "Presione Enter para continuar..."
            ;;
        5)
            (bash "$DIR/scripts/macos/05-dev.sh") || echo -e "\e[31m[Error] Falló. Regresando al menú...\e[0m"
            read -r -p "Presione Enter para continuar..."
            ;;
        [rR])
            (bash "$DIR/scripts/macos/99-restore.sh") || echo -e "\e[31m[Error] Falló. Regresando al menú...\e[0m"
            read -r -p "Presione Enter para continuar..."
            ;;
        [qQ]) exit 0 ;;
        *)
            echo -e "\e[31mOpción inválida.\e[0m"
            sleep 1
            ;;
        esac
    done
else
    while true; do
        clear
        echo -e "\e[36m==========================================\e[0m"
        echo -e "\e[35m   TERMINAL NIVEL DIOS - INSTALADOR (LINUX)\e[0m"
        echo -e "\e[36m==========================================\e[0m"
        echo " [1] Instalación Completa (Modo Dios)"
        echo " [2] Instalar Utilidades Base (DNF/APT)"
        echo " [3] Instalar Herramientas Modernas (GitHub Releases)"
        echo " [4] Configurar Oh My Zsh, Git y Temas"
        echo " [5] Configurar Neovim (LazyVim)"
        echo " [6] Instalar NVM y Pyenv"
        echo ""
        echo -e " \e[33m[R] Revertir (Restaurar bash y copias de seguridad)\e[0m"
        echo -e " \e[31m[Q] Salir\e[0m"
        echo -e "\e[36m==========================================\e[0m"

        read -r -p "Seleccione una opción: " opt

        case "$opt" in
        1)
            (run_all) || echo -e "\e[31m[Error] La instalación falló. Revisa los mensajes de arriba.\e[0m"
            read -r -p "Presione Enter para continuar..."
            break
            ;;
        2)
            (bash "$DIR/scripts/linux/01-core.sh") || echo -e "\e[31m[Error] Falló. Regresando al menú...\e[0m"
            read -r -p "Presione Enter para continuar..."
            ;;
        3)
            (bash "$DIR/scripts/linux/02-github.sh") || echo -e "\e[31m[Error] Falló. Regresando al menú...\e[0m"
            read -r -p "Presione Enter para continuar..."
            ;;
        4)
            (bash "$DIR/scripts/linux/03-shell.sh") || echo -e "\e[31m[Error] Falló. Regresando al menú...\e[0m"
            read -r -p "Presione Enter para continuar..."
            ;;
        5)
            (bash "$DIR/scripts/linux/04-neovim.sh") || echo -e "\e[31m[Error] Falló. Regresando al menú...\e[0m"
            read -r -p "Presione Enter para continuar..."
            ;;
        6)
            (bash "$DIR/scripts/linux/05-dev.sh") || echo -e "\e[31m[Error] Falló. Regresando al menú...\e[0m"
            read -r -p "Presione Enter para continuar..."
            ;;
        [rR])
            (bash "$DIR/scripts/linux/99-restore.sh") || echo -e "\e[31m[Error] Falló. Regresando al menú...\e[0m"
            read -r -p "Presione Enter para continuar..."
            ;;
        [qQ]) exit 0 ;;
        *)
            echo -e "\e[31mOpción inválida.\e[0m"
            sleep 1
            ;;
        esac
    done
fi

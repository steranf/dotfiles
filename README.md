# 🚀 Mis Dotfiles (Terminal Nivel Dios)

Este repositorio contiene la configuración centralizada de mi entorno de desarrollo, abarcando tanto Windows (PowerShell) como Windows Subsystem for Linux (WSL2 con AlmaLinux).

Está diseñado para transformar una computadora en blanco en un entorno de desarrollo profesional con iconos, autocompletado avanzado, y temas visuales unificados en menos de 2 minutos.

## 🛠️ Herramientas Incluidas
- **Windows Terminal & PowerShell 7**: Instalación automatizada desde cero.
- **WSL & AlmaLinux 9**: Descarga e instalación silenciosa del motor de Linux y la distribución.
- **Oh My Posh**: Prompt visual con el tema *Catppuccin Mocha* para Windows y Linux.
- **Eza / Terminal-Icons**: Reemplazos modernos de `ls` para incluir iconos según el tipo de archivo.
- **Fzf**: Buscador interactivo difuso para navegar instantáneamente por el historial (`Ctrl+R`) y archivos (`Ctrl+T`).
- **Zoxide**: Navegación inteligente de directorios (reemplazo de `cd`).
- **Zsh & Oh My Zsh**: Motor de terminal para Linux con plugins de autocompletado y resaltado de sintaxis.

---

## 💻 Instalación en Windows
Si tienes una PC nueva o acabas de formatear:
1. Asegúrate de tener instalado **Git** (es lo único necesario para descargar esto).
2. Abre la terminal por defecto de Windows (PowerShell clásico) y clona este repositorio:
   ```bash
   git clone https://github.com/steranf/dotfiles.git D:\dotfiles
   ```
3. Ejecuta el instalador:
   ```powershell
   cd D:\dotfiles
   .\install.ps1
   ```

---

## 🐧 Instalación en Linux (WSL2)
Una vez configurado Windows, si tienes una máquina de WSL instalada:
1. Abre tu terminal de Linux.
2. Entra a la carpeta clonada (WSL puede acceder a los discos de Windows):
   ```bash
   cd /mnt/d/dotfiles
   ```
3. Ejecuta el instalador para Linux:
   ```bash
   bash install.sh
   ```
4. Reinicia tu terminal o escribe `zsh`.

---

## 📚 Manuales de Uso
Dentro de la carpeta `docs/` encontrarás manuales detallados de cómo sacar provecho a los atajos de teclado y funcionalidades tanto en Windows como en AlmaLinux.

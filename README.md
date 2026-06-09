# 🚀 Mis Dotfiles (Terminal Nivel Dios)

Este repositorio contiene un entorno de desarrollo de **Nivel Ingeniería (Infraestructura como Código)**. Está diseñado para transformar una computadora en blanco en un entorno profesional en un proceso automatizado y reproducible (tarda entre 10 a 20 minutos dependiendo de tu conexión).

> [!IMPORTANT]
> **Plataformas Soportadas:** Oficialmente diseñado para **Windows 11** y **WSL2 con AlmaLinux 9**. Otros sistemas como Ubuntu o Debian requerirán adaptación del script de instalación de Linux (`install.sh`) ya que utiliza `dnf`.

## 🛠️ Herramientas Incluidas
- **Windows Terminal & PowerShell 7**: Instalación automatizada desde cero.
- **WSL & AlmaLinux 9**: Descarga e instalación silenciosa del motor de Linux y la distribución.
- **Oh My Posh**: Prompt visual con el tema *Catppuccin Mocha* para Windows y Linux (Cargado localmente para cero latencia).
- **Neovim (LazyVim)**: Editor de texto de alto rendimiento con configuración LazyVim lista para usar (descargado desde GitHub Releases a versión fija).
- **Eza / Terminal-Icons**: Reemplazos modernos de `ls` para incluir iconos según el tipo de archivo.
- **Fzf**: Buscador interactivo difuso para navegar instantáneamente por el historial (`Ctrl+R`) y archivos (`Ctrl+T`).
- **Zoxide**: Un reemplazo más inteligente para `cd` que aprende tus directorios frecuentes.
- **Fastfetch**: Muestra un resumen visual de la información de tu sistema cada vez que abres la terminal.
- **LazyGit**: Interfaz de usuario gráfica en la terminal para manejar Git de forma ultra rápida (usa el comando `lg`).
- **Ripgrep / Fd**: Búsqueda ultra-rápida de texto en archivos (`rg`) y de archivos por nombre (`fd`), integrados con Neovim.
- **NVM (Node Version Manager)**: Gestión de versiones de Node.js sin conflictos de permisos.
- **Pyenv**: Gestión de versiones de Python sin conflictos con el sistema.
- **Alias de Productividad**: Atajos preconfigurados como `gs` (git status), `ga` (git add), `gcm` (git commit) y `gl` (git log).
- **Zsh & Oh My Zsh**: Motor de terminal para Linux con plugins de autocompletado y resaltado de sintaxis (versiones fijas).
- **Herramientas de Infraestructura**: `bat` (cat con sintaxis), alias como `ports` para revisar conexiones, y detección dinámica de arquitectura (x86_64 / ARM).
- **Scripts de Auditoría**: Incluye `verify.sh` y `verify.ps1` para validar post-instalación que todas las herramientas existan y funcionen.
- **Integración Continua (CI)**: Pipeline automatizado con GitHub Actions que usa `ShellCheck` y `PSScriptAnalyzer` para asegurar código de alta calidad en cada actualización.

---

## 📦 Release Estable

[![GitHub release](https://img.shields.io/github/v/release/steranf/dotfiles?label=release&color=brightgreen)](https://github.com/steranf/dotfiles/releases/tag/v1.0.0)

> Última versión estable: **[v1.0.0](https://github.com/steranf/dotfiles/releases/tag/v1.0.0)**

---

## ⚡ Instalación Rápida (Bootstrap)

> Solo necesitas una terminal abierta. El bootstrap instala `git` si no está presente, clona el repo y lanza el instalador interactivo.

**Linux / WSL2 (AlmaLinux 9, Ubuntu, Debian):**
```bash
curl -fsSL https://raw.githubusercontent.com/steranf/dotfiles/v1.0.0/bootstrap.sh | bash
```

**Windows — Abre PowerShell como Administrador:**
```powershell
irm https://raw.githubusercontent.com/steranf/dotfiles/v1.0.0/bootstrap.ps1 | iex
```

**Modo totalmente desatendido** (sin menú, instala todo automáticamente):
```bash
# Linux
curl -fsSL https://raw.githubusercontent.com/steranf/dotfiles/v1.0.0/bootstrap.sh | bash -s -- --all
# Windows
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/steranf/dotfiles/v1.0.0/bootstrap.ps1))) -All
```

---

## ⚠️ Nota Importante sobre WSL y las Fuentes
Para que los iconos de Oh My Posh y Eza funcionen correctamente dentro de tu distribución Linux en WSL, **debes asegurarte de que tu Windows Terminal esté usando la fuente "JetBrainsMono Nerd Font"** (la cual el script `install.ps1` instalará automáticamente en Windows). De lo contrario, podrías ver "cuadritos" en lugar de iconos.

## 💻 Instalación Manual en Windows
Si prefieres clonar manualmente antes de ejecutar:
1. Abre PowerShell clásico y clona el repositorio:
   ```powershell
   git clone https://github.com/steranf/dotfiles.git D:\dotfiles
   cd D:\dotfiles
   .\install.ps1
   ```

---

## 🐧 Instalación Manual en Linux (WSL2)
Si el repo ya está clonado en Windows y quieres ejecutarlo desde WSL:
```bash
cd /mnt/d/dotfiles
bash install.sh
```
Reinicia tu terminal o escribe `zsh` al finalizar.

---

## 📚 Referencia Rápida de Atajos

| Atajo / Comando | Acción |
|---|---|
| `Ctrl+R` | Búsqueda en historial con FZF |
| `Ctrl+T` | Búsqueda de archivos con FZF |
| `z <nombre>` | Navegar a directorio frecuente (Zoxide) |
| `lg` | Abrir LazyGit (TUI de Git) |
| `gs` / `ga` / `gcm` | `git status` / `git add` / `git commit -m` |
| `ll` / `la` | Listado detallado con iconos (Eza) |
| `c <archivo>` | Ver archivo con sintaxis coloreada (Bat) |
| `ports` | Ver puertos en escucha |
| `nvim` | Abrir editor (LazyVim) |

## 📄 Licencia

MIT — consulta [LICENSE](LICENSE) para más detalles.

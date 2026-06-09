# Terminal Nivel Dios

> De una terminal en blanco a un entorno de desarrollo profesional en un solo comando.

[![CI](https://github.com/steranf/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/steranf/dotfiles/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/steranf/dotfiles?label=release&color=brightgreen)](https://github.com/steranf/dotfiles/releases/latest)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Dotfiles con instalador automatizado para **Windows 11 + WSL2 (AlmaLinux 9)**. Pensado para developers que quieren un entorno reproducible, bonito y seguro sin configurar nada a mano.

---

## ⚡ Un solo comando para empezar

**Linux / WSL2:**
```bash
curl -fsSL https://raw.githubusercontent.com/steranf/dotfiles/v1.0.1/bootstrap.sh | bash
```

**Windows — PowerShell como Administrador:**
```powershell
irm https://raw.githubusercontent.com/steranf/dotfiles/v1.0.1/bootstrap.ps1 | iex
```

El bootstrap instala `git` si no está presente, clona el repo y lanza el instalador. Desde cero hasta entorno completo en ~15 minutos.

> **Modo desatendido** (sin menú, instala todo en silencio):
> ```bash
> curl -fsSL https://raw.githubusercontent.com/steranf/dotfiles/v1.0.1/bootstrap.sh | bash -s -- --all
> ```

---

## 🛠️ Qué incluye

| Herramienta | Para qué sirve |
|---|---|
| **Oh My Posh** · tema Catppuccin Mocha | Prompt visual para PowerShell y Zsh |
| **Neovim + LazyVim** | Editor moderno listo para usar |
| **Eza + Terminal-Icons** | `ls` con iconos y colores |
| **FZF** | Búsqueda difusa en historial (`Ctrl+R`) y archivos (`Ctrl+T`) |
| **Zoxide** | `cd` inteligente que aprende tus rutas frecuentes (`z nombre`) |
| **LazyGit** | TUI de Git, abre con `lg` |
| **Fastfetch** | Info del sistema al abrir terminal |
| **Bat** | `cat` con resaltado de sintaxis (`c archivo`) |
| **Ripgrep + Fd** | Búsqueda de texto y archivos a velocidad nativa, integrados con Neovim |
| **NVM + Pyenv** | Gestión de versiones de Node.js y Python sin conflictos |
| **Zsh + Oh My Zsh** | Shell con autocompletado y resaltado de sintaxis |

---

## 🔒 Seguridad

- **SHA256 pinado** para los 5 binarios descargados de GitHub Releases
- **NVM** verificado con SHA256 antes de ejecutarse
- **PATH hardening** en scripts de descarga (`/usr/local/sbin:...`)
- `chown root:root` en todos los binarios instalados en `/usr/local/bin`
- **Supply chain warning** automático en PRs de actualización de versiones
- CI con ShellCheck + PSScriptAnalyzer en cada push

---

## 📦 Instalación manual

**Windows:**
```powershell
git clone https://github.com/steranf/dotfiles.git D:\dotfiles
cd D:\dotfiles
.\install.ps1
```

**Linux / WSL2:**
```bash
git clone https://github.com/steranf/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

Ambos instaladores muestran un **menú interactivo** para instalar componentes individualmente o todo de una vez.

---

## ⌨️ Atajos de teclado

| Atajo / Comando | Acción |
|---|---|
| `Ctrl+R` | Búsqueda en historial (FZF) |
| `Ctrl+T` | Búsqueda de archivos (FZF) |
| `z <nombre>` | Navegar a directorio frecuente (Zoxide) |
| `lg` | LazyGit |
| `gs` / `ga` / `gcm` | `git status` / `git add` / `git commit -m` |
| `ll` / `la` | Listado con iconos (Eza) |
| `c <archivo>` | Ver con sintaxis coloreada (Bat) |
| `ports` | Puertos en escucha |
| `nvim` | Abrir Neovim (LazyVim) |

---

## ⚠️ Plataformas soportadas

| Plataforma | Estado |
|---|---|
| Windows 11 + WSL2 (AlmaLinux 9) | ✅ Oficial |
| Ubuntu / Debian en WSL2 | ⚠️ Binarios OK · paquetes base requieren adaptar `01-core.sh` |
| Linux nativo x86_64 / ARM64 | ⚠️ Binarios OK · paquetes base requieren adaptar `01-core.sh` |

> Para que los iconos se vean correctamente en WSL, configura **JetBrainsMono Nerd Font** en Windows Terminal (el instalador de Windows la instala automáticamente).

---

## 📄 Licencia

MIT — consulta [LICENSE](LICENSE) para más detalles.

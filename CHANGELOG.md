# Changelog

Todos los cambios notables de este proyecto están documentados en este archivo.
Formato basado en [Keep a Changelog](https://keepachangelog.com/es/1.0.0/).

---

## [Unreleased]

### Added
- `update.ps1` para Windows: actualiza Oh My Posh (winget), módulos PS (Terminal-Icons, PSFzf) y dotfiles (`git pull`)
- `SECURITY.md` con política de reporte de vulnerabilidades y tiempos de respuesta
- Screenshots en README: prompt Zsh + Fastfetch, Neovim/LazyVim y LazyGit TUI
- `check-updates.sh` ahora detecta y actualiza `NVM_INSTALL_VERSION` + `NVM_SHA256` automáticamente
- `verify.sh` incluye nueva sección *Oh My Zsh* que verifica `~/.oh-my-zsh` y los plugins `zsh-autosuggestions` y `zsh-syntax-highlighting`
- `update.ps1` cubierto por PSScriptAnalyzer en CI

### Fixed
- `scripts/windows/02-terminal.ps1`: el backup del perfil de PowerShell ya no sobreescribe el `.bak` existente al re-ejecutar el script

### Changed
- `update.sh` refresca `ZSH_OMZ_COMMIT` en `env.sh` después de hacer pull de OMZ, manteniendo sincronía entre el entorno local y las instalaciones futuras

---

## [1.0.1] — 2026-06-08

### Added
- Soporte `apt-get` / `apt` en `scripts/linux/01-core.sh` para Ubuntu y Debian en WSL2
- PSScriptAnalyzer en CI cubre ahora también los scripts de `scripts/windows/`

### Changed
- `actions/checkout` actualizado de v4.2.2 a v6.0.3 (Node.js 24) en todos los workflows
- README reescrito para distribución pública: one-liners de bootstrap, tabla de herramientas, atajos de teclado y plataformas soportadas

---

## [1.0.0] — 2026-06-08

Primera versión pública.

### Added
- Instaladores modulares con menú interactivo: `install.sh` (Linux/WSL2) e `install.ps1` (Windows)
- Arquitectura modular física inspirada en holman/dotfiles: `scripts/linux/` y `scripts/windows/`
- Modo headless `--all` / `-All` para instalación desatendida
- Función de rollback/restore (`99-restore.sh` / `99-restore.ps1`)
- Bootstrap zero-to-hero: `bootstrap.sh` y `bootstrap.ps1` instalan `git`, clonan el repo y lanzan el instalador
- Auto-detección semanal de actualizaciones de herramientas vía `check-updates.sh` y workflow de GitHub Actions
- SHA256 checksums fijados para los 5 binarios descargados de GitHub Releases (OMP, Eza, LazyGit, Fastfetch, Neovim)
- NVM v0.40.5 verificado con SHA256 antes de ejecutarse; Pyenv v2.7.1
- `.wslconfig` interactivo con detección de hardware (RAM y CPU) y valores recomendados
- `verify.sh` y `verify.ps1`: auditoría post-instalación con exit code 1 si alguna herramienta falta
- CI con ShellCheck (scripts Bash) y PSScriptAnalyzer (scripts PowerShell) en cada push
- Tema Catppuccin Mocha para Oh My Posh, compartido entre PowerShell y Zsh
- Configuración de LazyVim lista para usar (`nvim/`)
- `LICENSE` MIT

### Security
- PATH hardening en scripts de descarga (`/usr/local/sbin:...`)
- `chown root:root` en todos los binarios instalados en `/usr/local/bin`
- NVM descargado a fichero temporal y SHA256 verificado antes de ejecutarse
- Validación de input con regex antes de escribir `.wslconfig`
- Supply chain warning automático en PRs de actualización de versiones
- Eliminado blob binario de 614 KB del historial de git con `git filter-repo`

[Unreleased]: https://github.com/steranf/dotfiles/compare/v1.0.1...HEAD
[1.0.1]: https://github.com/steranf/dotfiles/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/steranf/dotfiles/releases/tag/v1.0.0

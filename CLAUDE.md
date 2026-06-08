# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Linting (mirrors CI)

```bash
# Bash scripts (requires shellcheck)
shellcheck install.sh verify.sh

# PowerShell scripts (requires pwsh + PSScriptAnalyzer)
pwsh -Command "Invoke-ScriptAnalyzer -Path .\install.ps1 -Severity Error"
pwsh -Command "Invoke-ScriptAnalyzer -Path .\windows\Microsoft.PowerShell_profile.ps1 -Severity Error"
```

## Architecture

This repo automates a full terminal environment on **Windows 11 + WSL2 (AlmaLinux 9)**. Installation is two-phase:

1. **`install.ps1`** (run on Windows) — installs packages via `winget`, sets up PowerShell 7, Windows Terminal, fonts, and copies config files to their system locations.
2. **`install.sh`** (run inside WSL) — installs packages via `dnf`, downloads binary tools from GitHub Releases at pinned versions, sets Zsh as the default shell, installs Oh My Zsh + plugins, and copies config files.

Both scripts copy the OMP theme from `themes/catppuccin_mocha.omp.json` to `~/.config/omp/` so that both shells (PowerShell and Zsh) load it from a local path, avoiding network latency at startup.

### Config files and their destinations

| Source | Destination |
|---|---|
| `linux/.zshrc` | `~/.zshrc` |
| `windows/Microsoft.PowerShell_profile.ps1` | `$PROFILE` (PowerShell) |
| `windows/settings.json` | Windows Terminal LocalState dir |
| `themes/catppuccin_mocha.omp.json` | `~/.config/omp/` (both platforms) |

Both installers create a `.bak` backup before overwriting any existing config.

### Pinned tool versions (in `install.sh`)

Versions are frozen as variables at the top of `install.sh` (e.g. `OMP_VERSION`, `EZA_VERSION`) to ensure reproducible installs. When updating a tool, change its version variable and verify the new download URL resolves correctly. Each download is validated with `file` to confirm it's a real binary/archive and not an HTML 404 page.

### Verification scripts

`verify.sh` and `verify.ps1` are post-install audits that check each tool is on `$PATH` and print its version. They exit with code 1 if any tool is missing. Run them after any change to the install scripts to confirm the end state is correct.

### Architecture detection (Linux)

`install.sh` maps `uname -m` output to per-tool arch strings (`amd64`/`arm64`, `x86_64`/`aarch64`) because different GitHub release assets use different naming conventions per project.

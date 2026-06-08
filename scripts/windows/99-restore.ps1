# 99-restore.ps1 - Restaurar copias de seguridad de Windows

$ErrorActionPreference = 'Stop'

Write-Host "`n[*] Revirtiendo configuraciones a su estado original..." -ForegroundColor Magenta

# Restaurar perfil de PowerShell
if (Test-Path "$PROFILE.bak") {
    Copy-Item "$PROFILE.bak" $PROFILE -Force
    Write-Host "[OK] Perfil de PowerShell restaurado." -ForegroundColor Green
}

# Restaurar Windows Terminal
$wtLocalStateDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
if (Test-Path "$wtLocalStateDir\settings.json.bak") {
    Copy-Item "$wtLocalStateDir\settings.json.bak" "$wtLocalStateDir\settings.json" -Force
    Write-Host "[OK] Configuración de Windows Terminal restaurada." -ForegroundColor Green
}

# Restaurar Neovim
$nvimDest = "$env:LOCALAPPDATA\nvim"
if (Test-Path "$nvimDest.bak") {
    Remove-Item $nvimDest -Recurse -Force -ErrorAction SilentlyContinue
    Move-Item "$nvimDest.bak" $nvimDest -Force
    Write-Host "[OK] Configuración de Neovim restaurada." -ForegroundColor Green
}

# Restaurar .wslconfig
if (Test-Path "$env:USERPROFILE\.wslconfig.bak") {
    Copy-Item "$env:USERPROFILE\.wslconfig.bak" "$env:USERPROFILE\.wslconfig" -Force
    Write-Host "[OK] Archivo .wslconfig restaurado." -ForegroundColor Green
}

Write-Host "`nLa desinstalación lógica ha concluido. Los paquetes de Winget no fueron removidos para no afectar otros flujos." -ForegroundColor Yellow

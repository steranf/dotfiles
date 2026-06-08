# install.ps1 - Menú Maestro de Instalación (Windows)
$ErrorActionPreference = 'Stop'

param (
    [switch]$All
)

function Invoke-FullInstall {
    & "$PSScriptRoot\scripts\windows\01-core.ps1"
    & "$PSScriptRoot\scripts\windows\02-terminal.ps1"
    & "$PSScriptRoot\scripts\windows\03-neovim.ps1"
    & "$PSScriptRoot\scripts\windows\04-wsl.ps1" -Headless
}

if ($All) {
    Write-Host "Iniciando instalación completa (Modo Desatendido)..." -ForegroundColor Cyan
    Invoke-FullInstall
    Write-Host "`n=======================================================" -ForegroundColor Cyan
    Write-Host "¡INSTALACIÓN COMPLETADA EXITOSAMENTE!" -ForegroundColor Green
    exit
}

while ($true) {
    Clear-Host
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "   TERMINAL NIVEL DIOS - INSTALADOR" -ForegroundColor Magenta
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host " [1] Instalación Completa (Modo Dios)"
    Write-Host " [2] Instalar Software Base (Winget, Módulos)"
    Write-Host " [3] Configurar PowerShell, Terminal y Fuentes"
    Write-Host " [4] Configurar Neovim (LazyVim)"
    Write-Host " [5] Configurar recursos de WSL2"
    Write-Host ""
    Write-Host " [R] Revertir (Archivos .bak)" -ForegroundColor Yellow
    Write-Host " [Q] Salir" -ForegroundColor Red
    Write-Host "==========================================" -ForegroundColor Cyan
    
    $opt = Read-Host "Seleccione una opción"

    switch ($opt.ToUpper()) {
        "1" { Invoke-FullInstall; Pause; break }
        "2" { & "$PSScriptRoot\scripts\windows\01-core.ps1"; Pause }
        "3" { & "$PSScriptRoot\scripts\windows\02-terminal.ps1"; Pause }
        "4" { & "$PSScriptRoot\scripts\windows\03-neovim.ps1"; Pause }
        "5" { & "$PSScriptRoot\scripts\windows\04-wsl.ps1"; Pause }
        "R" { & "$PSScriptRoot\scripts\windows\99-restore.ps1"; Pause }
        "Q" { exit }
        default { Write-Host "Opción inválida." -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
}

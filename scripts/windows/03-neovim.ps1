# 03-neovim.ps1 - Sincronización de LazyVim

$ErrorActionPreference = 'Stop'
$dotfilesDir = Resolve-Path "$PSScriptRoot\..\.." | Select-Object -ExpandProperty Path

Write-Host "`n[*] Restaurando configuración de Neovim (LazyVim)..." -ForegroundColor Cyan
$nvimDest = "$env:LOCALAPPDATA\nvim"
$nvimSource = "$dotfilesDir\nvim"

if (Test-Path -Path $nvimSource) {
    if (Test-Path -Path $nvimDest) {
        Write-Host "Realizando backup de configuración local de Neovim..." -ForegroundColor Yellow
        Move-Item -Path $nvimDest -Destination "$nvimDest.bak" -Force
    }
    Copy-Item -Path $nvimSource -Destination $nvimDest -Recurse -Force
    Write-Host "Configuración de Neovim (LazyVim) restaurada desde dotfiles." -ForegroundColor Green
} else {
    Write-Host "[ADVERTENCIA] No se encontró el directorio nvim en el repositorio." -ForegroundColor Yellow
}

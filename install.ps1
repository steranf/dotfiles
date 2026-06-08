# Script de Auto-Instalación de Dotfiles (Windows)
# Ejecutar este script desde la raíz del repositorio dotfiles

Write-Host "Iniciando instalación del entorno de la Terminal Nivel Dios..." -ForegroundColor Cyan

$dotfilesDir = $PSScriptRoot

# 1. Instalar dependencias con Winget
Write-Host "`n[1/5] Instalando paquetes (Oh My Posh, fzf)..." -ForegroundColor Yellow
winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements
winget install junegunn.fzf -s winget --accept-package-agreements --accept-source-agreements

# 2. Instalar Módulos de PowerShell
Write-Host "`n[2/5] Instalando Módulos de PowerShell (Terminal-Icons, PSFzf)..." -ForegroundColor Yellow
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name Terminal-Icons -Force -AllowClobber -ErrorAction Stop
Install-Module -Name PSFzf -Force -AllowClobber -ErrorAction Stop

# 3. Configurar Perfil de PowerShell
Write-Host "`n[3/5] Restaurando perfil de PowerShell..." -ForegroundColor Yellow
if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}
Copy-Item -Path "$dotfilesDir\windows\Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force
Write-Host "Perfil de PowerShell copiado con éxito." -ForegroundColor Green

# 4. Configurar Windows Terminal
Write-Host "`n[4/5] Restaurando configuración de Windows Terminal y fondo de pantalla..." -ForegroundColor Yellow
$wtLocalStateDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
if (Test-Path -Path $wtLocalStateDir) {
    Copy-Item -Path "$dotfilesDir\windows\settings.json" -Destination "$wtLocalStateDir\settings.json" -Force
    Copy-Item -Path "$dotfilesDir\assets\cyberpunk_terminal_bg.png" -Destination "$wtLocalStateDir\cyberpunk_terminal_bg.png" -Force
    Write-Host "Windows Terminal configurado con éxito." -ForegroundColor Green
} else {
    Write-Host "No se encontró Windows Terminal instalado. Por favor instálalo desde la Microsoft Store." -ForegroundColor Red
}

# 5. Instalar Fuentes
Write-Host "`n[5/5] Instalando la fuente JetBrains Mono Nerd Font..." -ForegroundColor Yellow
# Oh My Posh puede instalar las fuentes automáticamente
oh-my-posh font install JetBrainsMono --headless
Write-Host "Fuentes instaladas." -ForegroundColor Green

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host "¡INSTALACIÓN COMPLETADA EXITOSAMENTE!" -ForegroundColor Green
Write-Host "Para los cambios de Linux (WSL), recuerda copiar el archivo .zshrc a tu ruta ~/" -ForegroundColor Yellow
Write-Host "=======================================================" -ForegroundColor Cyan

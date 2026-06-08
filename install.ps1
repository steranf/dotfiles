# Script de Auto-Instalación de Dotfiles (Windows)
# Ejecutar este script desde la raíz del repositorio dotfiles

Write-Host "Iniciando instalación del entorno de la Terminal Nivel Dios..." -ForegroundColor Cyan

$dotfilesDir = $PSScriptRoot

# 1. Instalar Software Base (Terminal, PowerShell 7, WSL, AlmaLinux)
Write-Host "`n[1/6] Instalando Software Base (Terminal, PowerShell 7, WSL, AlmaLinux 9)..." -ForegroundColor Yellow
winget install Microsoft.WindowsTerminal -s winget --accept-package-agreements --accept-source-agreements
winget install Microsoft.PowerShell -s winget --accept-package-agreements --accept-source-agreements
Write-Host "Instalando motor de WSL..." -ForegroundColor Cyan
wsl --install --no-distribution
Write-Host "Instalando AlmaLinux 9 desde la Microsoft Store..." -ForegroundColor Cyan
winget install 9P5RWLM70SN9 -s msstore --accept-package-agreements --accept-source-agreements

# 2. Instalar dependencias con Winget (Oh My Posh, fzf, fastfetch, lazygit)
Write-Host "`n[2/7] Instalando utilidades (Oh My Posh, fzf, fastfetch, lazygit)..." -ForegroundColor Yellow
winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements
winget install junegunn.fzf -s winget --accept-package-agreements --accept-source-agreements
winget install fastfetch-cli.fastfetch -s winget --accept-package-agreements --accept-source-agreements
winget install jesseduffield.lazygit -s winget --accept-package-agreements --accept-source-agreements

# 3. Instalar Módulos de PowerShell
Write-Host "`n[3/7] Instalando Módulos de PowerShell (Terminal-Icons, PSFzf)..." -ForegroundColor Yellow
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name Terminal-Icons -Force -AllowClobber -ErrorAction SilentlyContinue
Install-Module -Name PSFzf -Force -AllowClobber -ErrorAction SilentlyContinue

# 4. Configurar Perfil de PowerShell (Con Backup)
Write-Host "`n[4/7] Restaurando perfil de PowerShell..." -ForegroundColor Yellow
if (Test-Path -Path $PROFILE) {
    Copy-Item -Path $PROFILE -Destination "$PROFILE.bak" -Force
} else {
    $null = New-Item -ItemType File -Path $PROFILE -Force
}
Copy-Item -Path "$dotfilesDir\windows\Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force
Write-Host "Perfil de PowerShell copiado con éxito." -ForegroundColor Green

# 5. Configurar Windows Terminal (Con Backup)
Write-Host "`n[5/7] Restaurando configuración de Windows Terminal y fondo de pantalla..." -ForegroundColor Yellow
$wtLocalStateDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
if (Test-Path -Path $wtLocalStateDir) {
    if (Test-Path "$wtLocalStateDir\settings.json") {
        Copy-Item -Path "$wtLocalStateDir\settings.json" -Destination "$wtLocalStateDir\settings.json.bak" -Force
    }
    Copy-Item -Path "$dotfilesDir\windows\settings.json" -Destination "$wtLocalStateDir\settings.json" -Force
    Copy-Item -Path "$dotfilesDir\assets\cyberpunk_terminal_bg.png" -Destination "$wtLocalStateDir\cyberpunk_terminal_bg.png" -Force
    Write-Host "Windows Terminal configurado con éxito." -ForegroundColor Green
} else {
    Write-Host "Aviso: No se encontró la ruta de Windows Terminal. Tal vez necesites abrir la app una vez primero." -ForegroundColor Red
}

# 6. Instalar Fuentes
Write-Host "`n[6/7] Instalando la fuente JetBrains Mono Nerd Font..." -ForegroundColor Yellow
oh-my-posh font install JetBrainsMono --headless
Write-Host "Fuentes instaladas." -ForegroundColor Green

# 7. Copiar Tema de Oh My Posh localmente
Write-Host "`n[7/7] Instalando tema local de Oh My Posh..." -ForegroundColor Yellow
$ompConfigDir = "$HOME\.config\omp"
if (!(Test-Path -Path $ompConfigDir)) {
    $null = New-Item -ItemType Directory -Path $ompConfigDir -Force
}
Copy-Item -Path "$dotfilesDir\themes\catppuccin_mocha.omp.json" -Destination "$ompConfigDir\catppuccin_mocha.omp.json" -Force
Write-Host "Tema local instalado." -ForegroundColor Green

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host "¡INSTALACIÓN COMPLETADA EXITOSAMENTE!" -ForegroundColor Green
Write-Host "NOTA: Si es la primera vez que instalas WSL, es posible que debas REINICIAR TU PC." -ForegroundColor Yellow
Write-Host "Para finalizar el entorno de Linux, abre AlmaLinux 9 y ejecuta bash install.sh" -ForegroundColor Yellow
Write-Host "=======================================================" -ForegroundColor Cyan

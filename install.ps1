# Script de Auto-Instalación de Dotfiles (Windows)
# Ejecutar este script desde la raíz del repositorio dotfiles

$ErrorActionPreference = 'Stop'

Write-Host "Iniciando instalación del entorno de la Terminal Nivel Dios..." -ForegroundColor Cyan

$dotfilesDir = $PSScriptRoot

function Install-WingetPackage {
    param (
        [Parameter(Mandatory=$true)][string]$PackageId,
        [string]$Source = "winget"
    )
    Write-Host "Instalando $PackageId..." -ForegroundColor Cyan
    winget install --id $PackageId -s $Source --accept-package-agreements --accept-source-agreements --silent
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335189 -and $LASTEXITCODE -ne 2316632065) {
        Write-Host "[ERROR] Falló la instalación de $PackageId. Exit Code: $LASTEXITCODE" -ForegroundColor Red
        exit $LASTEXITCODE
    }
}

# 1. Instalar Software Base (Terminal, PowerShell 7, WSL, AlmaLinux)
Write-Host "`n[1/6] Instalando Software Base (Terminal, PowerShell 7, WSL, AlmaLinux 9)..." -ForegroundColor Yellow
$packages = @(
    "Microsoft.WindowsTerminal",
    "Microsoft.PowerShell",
    "9P5RWLM70SN9",
    "JanDeDobbeleer.OhMyPosh",
    "junegunn.fzf",
    "Fastfetch-cli.Fastfetch",
    "jesseduffield.lazygit",
    "sharkdp.bat",
    "Neovim.Neovim",
    "BurntSushi.ripgrep.MSVC",
    "sharkdp.fd"
)

foreach ($pkg in $packages) {
    if ($pkg -eq "9P5RWLM70SN9") {
        Install-WingetPackage -PackageId $pkg -Source msstore
    } else {
        Install-WingetPackage -PackageId $pkg
    }
}

Write-Host "Instalando motor de WSL..." -ForegroundColor Cyan
wsl --install --no-distribution

# 2. Instalar Módulos de PowerShell
Write-Host "`n[2/6] Instalando Módulos de PowerShell (Terminal-Icons, PSFzf)..." -ForegroundColor Yellow
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name Terminal-Icons -Force -AllowClobber -ErrorAction SilentlyContinue
Install-Module -Name PSFzf -Force -AllowClobber -ErrorAction SilentlyContinue

# 3. Configurar Perfil de PowerShell (Con Backup)
Write-Host "`n[3/6] Restaurando perfil de PowerShell..." -ForegroundColor Yellow
if (Test-Path -Path $PROFILE) {
    Copy-Item -Path $PROFILE -Destination "$PROFILE.bak" -Force
} else {
    $null = New-Item -ItemType File -Path $PROFILE -Force
}
Copy-Item -Path "$dotfilesDir\windows\Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force
Write-Host "Perfil de PowerShell copiado con éxito." -ForegroundColor Green

# 4. Configurar Neovim (LazyVim)
Write-Host "`n[4/6] Restaurando configuración de Neovim (LazyVim)..." -ForegroundColor Cyan
$nvimDest = "$env:LOCALAPPDATA\nvim"
$nvimSource = "$dotfilesDir\nvim"
if (Test-Path -Path $nvimSource) {
    if (Test-Path -Path $nvimDest) {
        Write-Host "Realizando backup de configuración local de Neovim..." -ForegroundColor Yellow
        Move-Item -Path $nvimDest -Destination "$nvimDest.bak" -Force
    }
    Copy-Item -Path $nvimSource -Destination $nvimDest -Recurse -Force
    Write-Host "Configuración de Neovim (LazyVim) restaurada desde dotfiles." -ForegroundColor Green
}

# 5. Configurar Windows Terminal (Con Backup)
Write-Host "`n[5/6] Restaurando configuración de Windows Terminal y fondo de pantalla..." -ForegroundColor Yellow
$wtLocalStateDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
if (Test-Path -Path $wtLocalStateDir) {
    if (Test-Path "$wtLocalStateDir\settings.json") {
        Copy-Item -Path "$wtLocalStateDir\settings.json" -Destination "$wtLocalStateDir\settings.json.bak" -Force
    }
    Copy-Item -Path "$dotfilesDir\windows\settings.json" -Destination "$wtLocalStateDir\settings.json" -Force
    try {
        Copy-Item -Path "$dotfilesDir\assets\cyberpunk_terminal_bg.png" -Destination "$wtLocalStateDir\cyberpunk_terminal_bg.png" -Force -ErrorAction Stop
    } catch {
        Write-Host "Aviso: El fondo de pantalla está en uso por Windows Terminal y no se pudo sobreescribir." -ForegroundColor Yellow
    }
    Write-Host "Windows Terminal configurado con éxito." -ForegroundColor Green
}

# 6. Instalar Fuentes y Temas
Write-Host "`n[6/6] Instalando fuentes y configurando temas..." -ForegroundColor Yellow
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

Write-Host "`nBenchmark de inicio del entorno de PowerShell:" -ForegroundColor Magenta
Measure-Command { pwsh -NoProfile -Command exit } | Select-Object TotalMilliseconds

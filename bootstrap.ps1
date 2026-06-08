# bootstrap.ps1 — Zero-to-hero en un solo comando para Windows.
# Uso: irm https://raw.githubusercontent.com/steranf/dotfiles/main/bootstrap.ps1 | iex
# Modo silente: & ([scriptblock]::Create((irm URL))) -All

param([switch]$All)

$ErrorActionPreference = 'Stop'

$RepoUrl = "https://github.com/steranf/dotfiles.git"

# Directorio destino: D:\dotfiles si D: existe, si no ~/dotfiles
$DotfilesDir = if (Test-Path "D:\") { "D:\dotfiles" } else { "$env:USERPROFILE\dotfiles" }

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   TERMINAL NIVEL DIOS — BOOTSTRAP (WIN)  " -ForegroundColor Magenta
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# --- 1. Verificar winget ---
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "[ERROR] winget no encontrado. Instálalo desde https://aka.ms/getwinget" -ForegroundColor Red
    exit 1
}
Write-Host "[✓] winget disponible." -ForegroundColor Green

# --- 2. Instalar git si no está presente ---
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[*] Instalando Git via winget..." -ForegroundColor Yellow
    winget install --id Git.Git -s winget `
        --accept-package-agreements --accept-source-agreements --silent
    # Refrescar PATH en la sesión actual
    $env:PATH = [Environment]::GetEnvironmentVariable("PATH","Machine") + ";" +
                [Environment]::GetEnvironmentVariable("PATH","User")
}
Write-Host "[✓] git $(git --version)" -ForegroundColor Green

# --- 3. Clonar o actualizar el repositorio ---
if (Test-Path (Join-Path $DotfilesDir ".git")) {
    Write-Host "[*] Dotfiles ya existen en $DotfilesDir — actualizando..." -ForegroundColor Yellow
    git -C $DotfilesDir pull --ff-only
} else {
    Write-Host "[*] Clonando dotfiles en $DotfilesDir..." -ForegroundColor Yellow
    git clone $RepoUrl $DotfilesDir
}
Write-Host "[✓] Repositorio listo en $DotfilesDir" -ForegroundColor Green
Write-Host ""

# --- 4. Lanzar instalador ---
Write-Host "Lanzando instalador..." -ForegroundColor Cyan
Write-Host ""
if ($All) {
    & "$DotfilesDir\install.ps1" -All
} else {
    & "$DotfilesDir\install.ps1"
}

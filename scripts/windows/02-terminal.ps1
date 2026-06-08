# 02-terminal.ps1 - Perfil de PowerShell, Windows Terminal y Fuentes

$ErrorActionPreference = 'Stop'
$dotfilesDir = Resolve-Path "$PSScriptRoot\..\.." | Select-Object -ExpandProperty Path

Write-Host "`n[*] Restaurando perfil de PowerShell..." -ForegroundColor Yellow
if (Test-Path -Path $PROFILE) {
    Copy-Item -Path $PROFILE -Destination "$PROFILE.bak" -Force
} else {
    $null = New-Item -ItemType File -Path $PROFILE -Force
}
Copy-Item -Path "$dotfilesDir\windows\Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force
Write-Host "Perfil de PowerShell copiado con éxito." -ForegroundColor Green

Write-Host "`n[*] Instalando fuentes y configurando temas..." -ForegroundColor Yellow
oh-my-posh font install JetBrainsMono --headless
Write-Host "Fuentes instaladas." -ForegroundColor Green

$ompConfigDir = "$HOME\.config\omp"
if (!(Test-Path -Path $ompConfigDir)) {
    $null = New-Item -ItemType Directory -Path $ompConfigDir -Force
}
Copy-Item -Path "$dotfilesDir\themes\catppuccin_mocha.omp.json" -Destination "$ompConfigDir\catppuccin_mocha.omp.json" -Force
Write-Host "Tema local instalado." -ForegroundColor Green

Write-Host "`n[*] Restaurando configuración de Windows Terminal y fondo de pantalla..." -ForegroundColor Yellow
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

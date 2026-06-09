# update.ps1 - Actualiza Oh My Posh, módulos de PowerShell y los dotfiles.
# Para actualizar el resto de paquetes winget, usa install.ps1 opción [2].
$ErrorActionPreference = 'Stop'

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "   TERMINAL NIVEL DIOS - ACTUALIZADOR" -ForegroundColor Magenta
Write-Host "==========================================" -ForegroundColor Cyan

Write-Host "`n[*] Actualizando Oh My Posh..." -ForegroundColor Yellow
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    winget upgrade JanDeDobbeleer.OhMyPosh --silent --accept-package-agreements --accept-source-agreements
    # -1978335189 = sin actualizaciones disponibles (ya en la última versión)
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[✓] Oh My Posh actualizado." -ForegroundColor Green
    } elseif ($LASTEXITCODE -eq -1978335189) {
        Write-Host "[✓] Oh My Posh ya está en la última versión." -ForegroundColor Green
    } else {
        Write-Host "[!] Winget devolvió código $LASTEXITCODE al actualizar Oh My Posh." -ForegroundColor Yellow
    }
} else {
    Write-Host "[!] Oh My Posh no encontrado, omitiendo." -ForegroundColor Yellow
}

Write-Host "`n[*] Actualizando módulos de PowerShell..." -ForegroundColor Yellow
foreach ($module in @('Terminal-Icons', 'PSFzf')) {
    if (Get-Module -ListAvailable -Name $module) {
        Write-Host "  Actualizando $module..." -ForegroundColor Cyan
        Update-Module -Name $module -Force -ErrorAction SilentlyContinue
        Write-Host "  [✓] $module actualizado." -ForegroundColor Green
    } else {
        Write-Host "  [!] $module no instalado, omitiendo." -ForegroundColor Yellow
    }
}

Write-Host "`n[*] Actualizando dotfiles desde el repositorio..." -ForegroundColor Yellow
git -C $PSScriptRoot pull --ff-only
if ($LASTEXITCODE -eq 0) {
    Write-Host "[✓] Dotfiles actualizados." -ForegroundColor Green
} else {
    Write-Host "[!] No se pudo hacer pull (¿cambios locales sin commitear?)." -ForegroundColor Yellow
}

Write-Host "`n==========================================" -ForegroundColor Green
Write-Host "¡Actualización completa!" -ForegroundColor Green
Write-Host "Para actualizar el resto de paquetes winget," -ForegroundColor Yellow
Write-Host "ejecuta install.ps1 y selecciona la opción [2]." -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Green

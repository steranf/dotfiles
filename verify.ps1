# Script de Auditoría Post-Instalación (Windows)
$ErrorActionPreference = 'SilentlyContinue'

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "   AUDITORÍA DE ENTORNO: TERMINAL NIVEL DIOS        " -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

$errors = 0

function Test-Tool {
    param(
        [string]$ToolCommand,
        [string]$ToolName,
        [scriptblock]$VersionScript
    )

    if (Get-Command $ToolCommand -ErrorAction SilentlyContinue) {
        if ($VersionScript) {
            $version = Invoke-Command $VersionScript
            Write-Host "[✓] $ToolName " -NoNewline -ForegroundColor Green
            Write-Host "- Encontrado ($version)" -ForegroundColor White
        } else {
            Write-Host "[✓] $ToolName " -NoNewline -ForegroundColor Green
            Write-Host "- Encontrado" -ForegroundColor White
        }
    } else {
        Write-Host "[x] $ToolName " -NoNewline -ForegroundColor Red
        Write-Host "- NO ENCONTRADO" -ForegroundColor White
        $script:errors++
    }
}

Write-Host "`n--- Herramientas Core ---" -ForegroundColor Yellow
Test-Tool "pwsh" "PowerShell 7" { (pwsh -Version) -replace 'PowerShell ', '' }
Test-Tool "wsl" "WSL" { (wsl --version)[0] -replace 'WSL version: ', '' -replace 'Versión de WSL: ', '' }

Write-Host "`n--- Utilidades de Terminal ---" -ForegroundColor Yellow
Test-Tool "oh-my-posh" "Oh My Posh" { oh-my-posh --version }
Test-Tool "fastfetch" "Fastfetch" { (fastfetch --version).Split(' ')[1] }
Test-Tool "lazygit" "LazyGit" { (lazygit --version).Split(' ')[5] -replace 'v', '' -replace ',', '' }
Test-Tool "fzf" "FZF (Buscador)" { (fzf --version).Split(' ')[0] }
Test-Tool "bat" "Bat" { (bat --version).Split(' ')[1] }
Test-Tool "nvim" "Neovim" { (nvim --version).Split(' ')[1] }
Test-Tool "rg" "Ripgrep" { (rg --version).Split(' ')[1] }
Test-Tool "fd" "Fd" { (fd --version).Split(' ')[1] }

Write-Host "`n====================================================" -ForegroundColor Cyan
if ($errors -eq 0) {
    Write-Host "Resultado: Excelente. Todas las herramientas están instaladas y funcionando en Windows." -ForegroundColor Green
} else {
    Write-Host "Resultado: Se encontraron $errors herramienta(s) faltantes. Revisa tu instalación de Winget." -ForegroundColor Red
}
Write-Host "====================================================" -ForegroundColor Cyan

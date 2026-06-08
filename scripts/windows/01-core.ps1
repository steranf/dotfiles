# 01-core.ps1 - Software Base y Herramientas (Winget)

$ErrorActionPreference = 'Stop'

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

Write-Host "`n[*] Instalando Software Base (Terminal, PowerShell 7, WSL, AlmaLinux 9, Herramientas CLI)..." -ForegroundColor Yellow
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

Write-Host "`n[*] Instalando Módulos de PowerShell (Terminal-Icons, PSFzf)..." -ForegroundColor Yellow
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name Terminal-Icons -Force -AllowClobber -ErrorAction SilentlyContinue
Install-Module -Name PSFzf -Force -AllowClobber -ErrorAction SilentlyContinue

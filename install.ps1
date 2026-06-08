param(
    [switch]$All
)

$ErrorActionPreference = 'Stop'
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

function Install-SoftwareBase {
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
}

function Install-PSModules {
    Write-Host "`n[*] Instalando Módulos de PowerShell (Terminal-Icons, PSFzf)..." -ForegroundColor Yellow
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
    Install-Module -Name Terminal-Icons -Force -AllowClobber -ErrorAction SilentlyContinue
    Install-Module -Name PSFzf -Force -AllowClobber -ErrorAction SilentlyContinue
}

function Configure-PSProfile {
    Write-Host "`n[*] Restaurando perfil de PowerShell..." -ForegroundColor Yellow
    if (Test-Path -Path $PROFILE) {
        Copy-Item -Path $PROFILE -Destination "$PROFILE.bak" -Force
    } else {
        $null = New-Item -ItemType File -Path $PROFILE -Force
    }
    Copy-Item -Path "$dotfilesDir\windows\Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force
    Write-Host "Perfil de PowerShell copiado con éxito." -ForegroundColor Green
}

function Configure-Neovim {
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
    }
}

function Configure-WindowsTerminal {
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
}

function Install-FontsAndThemes {
    Write-Host "`n[*] Instalando fuentes y configurando temas..." -ForegroundColor Yellow
    oh-my-posh font install JetBrainsMono --headless
    Write-Host "Fuentes instaladas." -ForegroundColor Green

    $ompConfigDir = "$HOME\.config\omp"
    if (!(Test-Path -Path $ompConfigDir)) {
        $null = New-Item -ItemType Directory -Path $ompConfigDir -Force
    }
    Copy-Item -Path "$dotfilesDir\themes\catppuccin_mocha.omp.json" -Destination "$ompConfigDir\catppuccin_mocha.omp.json" -Force
    Write-Host "Tema local instalado." -ForegroundColor Green
}

function Configure-WSL {
    Write-Host "`n[*] Configurando .wslconfig para WSL2..." -ForegroundColor Yellow
    $totalRAMBytes = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
    $totalRAMGB    = [math]::Floor($totalRAMBytes / 1GB)
    $totalCores    = (Get-CimInstance Win32_Processor | Measure-Object -Property NumberOfLogicalProcessors -Sum).Sum
    $recRAM        = [math]::Max(4, [math]::Floor($totalRAMGB / 2))
    $recCPU        = [math]::Max(2, [math]::Floor($totalCores / 2))

    Write-Host ""
    Write-Host "  Hardware detectado : ${totalRAMGB}GB RAM  ·  ${totalCores} nucleos logicos" -ForegroundColor Cyan
    Write-Host "  Recomendacion      : ${recRAM}GB memoria  ·  ${recCPU} procesadores"        -ForegroundColor Green
    Write-Host ""

    $choice = Read-Host "  Aceptar recomendacion? [S/n]"
    if ($choice -eq 'n' -or $choice -eq 'N') {
        $wslRAM = Read-Host "  Memoria para WSL2 (ej: 8GB)"
        $wslCPU = Read-Host "  Procesadores (ej: 4)"
    } else {
        $wslRAM = "${recRAM}GB"
        $wslCPU = "$recCPU"
    }

    if (Test-Path "$env:USERPROFILE\.wslconfig") {
        Copy-Item "$env:USERPROFILE\.wslconfig" "$env:USERPROFILE\.wslconfig.bak" -Force
    }
    @"
[wsl2]
memory=$wslRAM
processors=$wslCPU
swap=2GB
"@ | Out-File "$env:USERPROFILE\.wslconfig" -Encoding utf8 -Force
    Write-Host "WSL2 configurado: $wslRAM RAM  ·  $wslCPU procesadores." -ForegroundColor Green
    Write-Host "Ejecuta 'wsl --shutdown' para aplicar los cambios." -ForegroundColor Yellow
}

function Restore-Backups {
    Write-Host "`n[*] Revirtiendo configuraciones a su estado original..." -ForegroundColor Magenta

    # Restaurar perfil de PowerShell
    if (Test-Path "$PROFILE.bak") {
        Copy-Item "$PROFILE.bak" $PROFILE -Force
        Write-Host "[OK] Perfil de PowerShell restaurado." -ForegroundColor Green
    }

    # Restaurar Windows Terminal
    $wtLocalStateDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
    if (Test-Path "$wtLocalStateDir\settings.json.bak") {
        Copy-Item "$wtLocalStateDir\settings.json.bak" "$wtLocalStateDir\settings.json" -Force
        Write-Host "[OK] Configuración de Windows Terminal restaurada." -ForegroundColor Green
    }

    # Restaurar Neovim
    $nvimDest = "$env:LOCALAPPDATA\nvim"
    if (Test-Path "$nvimDest.bak") {
        Remove-Item $nvimDest -Recurse -Force -ErrorAction SilentlyContinue
        Move-Item "$nvimDest.bak" $nvimDest -Force
        Write-Host "[OK] Configuración de Neovim restaurada." -ForegroundColor Green
    }

    # Restaurar .wslconfig
    if (Test-Path "$env:USERPROFILE\.wslconfig.bak") {
        Copy-Item "$env:USERPROFILE\.wslconfig.bak" "$env:USERPROFILE\.wslconfig" -Force
        Write-Host "[OK] Archivo .wslconfig restaurado." -ForegroundColor Green
    }

    Write-Host "`nLa desinstalación lógica ha concluido. Los paquetes de Winget no fueron removidos para no afectar otros flujos." -ForegroundColor Yellow
}

function Run-All {
    Install-SoftwareBase
    Install-PSModules
    Configure-PSProfile
    Configure-Neovim
    Configure-WindowsTerminal
    Install-FontsAndThemes
    Configure-WSL
}

if ($All) {
    Write-Host "Iniciando instalación completa (Modo Desatendido)..." -ForegroundColor Cyan
    Run-All
    Write-Host "`n=======================================================" -ForegroundColor Cyan
    Write-Host "¡INSTALACIÓN COMPLETADA EXITOSAMENTE!" -ForegroundColor Green
    exit
}

# --- Menú Interactivo ---
while ($true) {
    Clear-Host
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "   TERMINAL NIVEL DIOS - INSTALADOR       " -ForegroundColor Magenta
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "[1] Instalación Completa (Modo Dios)"
    Write-Host "[2] Instalar Software Base y Herramientas (Winget)"
    Write-Host "[3] Configurar Perfil de PowerShell y Temas"
    Write-Host "[4] Configurar Neovim (LazyVim)"
    Write-Host "[5] Configurar Windows Terminal"
    Write-Host "[6] Configurar Memoria de WSL2 (.wslconfig)"
    Write-Host ""
    Write-Host "[R] Revertir (Restaurar copias de seguridad)" -ForegroundColor Yellow
    Write-Host "[Q] Salir" -ForegroundColor Red
    Write-Host "==========================================" -ForegroundColor Cyan

    $opt = Read-Host "Seleccione una opción"

    switch ($opt.ToUpper()) {
        "1" { Run-All; Pause; break }
        "2" { Install-SoftwareBase; Install-PSModules; Pause }
        "3" { Configure-PSProfile; Install-FontsAndThemes; Pause }
        "4" { Configure-Neovim; Pause }
        "5" { Configure-WindowsTerminal; Pause }
        "6" { Configure-WSL; Pause }
        "R" { Restore-Backups; Pause }
        "Q" { exit }
        default { Write-Host "Opción inválida." -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
}

# 04-wsl.ps1 - Configuración de recursos para WSL2

param(
    [switch]$Headless
)

$ErrorActionPreference = 'Stop'

Write-Host "`n[*] Configurando .wslconfig para WSL2..." -ForegroundColor Yellow
$totalRAMBytes = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
$totalRAMGB    = [math]::Floor($totalRAMBytes / 1GB)
$totalCores    = (Get-CimInstance Win32_Processor | Measure-Object -Property NumberOfLogicalProcessors -Sum).Sum
$recRAM        = [math]::Max(4, [math]::Floor($totalRAMGB / 2))
$recCPU        = [math]::Max(2, [math]::Floor($totalCores / 2))

if (-not $Headless) {
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

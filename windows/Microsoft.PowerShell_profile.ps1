# =====================================================================================
# Configuración del Perfil de PowerShell 7
# =====================================================================================

# 1. Autocompletado Predictivo (PSReadLine)
# Activa las sugerencias de autocompletado en línea basadas en tu historial de comandos.
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView
# Color gris oscuro para el texto sugerido
Set-PSReadLineOption -Colors @{ InlinePrediction = "$([char]27)[38;5;238m" }

# 2. Prompt Visual Avanzado (Oh My Posh)
# Tema elegido: Catppuccin Mocha (Carga Local y Segura)
$ompConfig = "$HOME\.config\omp\catppuccin_mocha.omp.json"
if (Test-Path $ompConfig) {
    oh-my-posh init pwsh --config $ompConfig | Invoke-Expression
}

# 3. Terminal-Icons (El 'ls' más hermoso)
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module -Name Terminal-Icons
}

# 4. Buscador de Historial (FZF)
if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module -Name PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# 5. Editor y variables de entorno
$env:EDITOR="nvim"

# 6. Alias de Productividad (Git y otros)
function gs { git status }
function ga { git add $args }
function gcm { git commit -m $args }
function gl { git log --oneline --graph --decorate -n 15 }
function lg { lazygit }
function ports { Get-NetTCPConnection -State Listen | Select-Object LocalPort, @{N='Process';E={(Get-Process -Id $_.OwningProcess).Name}} }

# 7. Información del Sistema (Fastfetch)
if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    fastfetch
}

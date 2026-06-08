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
# Tema elegido: Catppuccin Mocha
oh-my-posh init pwsh --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/catppuccin_mocha.omp.json" | Invoke-Expression

# 3. Terminal-Icons (El 'ls' más hermoso)
Import-Module -Name Terminal-Icons

# 4. Buscador de Historial (FZF)
Import-Module -Name PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

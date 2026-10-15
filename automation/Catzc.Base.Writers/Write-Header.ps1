<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Writers/Write-Header.ps1
    kind: public-function
    module: Catzc.Base.Writers
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Writes a header with optional message in a chosen style.
.DESCRIPTION
    A rainbow colour gradients only the rule lines; the titled line keeps the profile's base colour.
.PARAMETER Message
    The text to display. If omitted, writes a single separator line.
.PARAMETER Style
    Visual style: Curved, Stars, or Heavy. Defaults to Curved.
.PARAMETER Width
    Total width of the separator lines. Defaults to 78.
.PARAMETER ForegroundColor
    Omit it and the output renders in the terminal default; a rainbow value gives a per-character gradient rule.
.EXAMPLE
    Write-Header 'Deployment starting'
.EXAMPLE
    Write-Header 'Build' -Style Stars -ForegroundColor Yellow
.EXAMPLE
    Write-Header 'PASSED' -ForegroundColor rainbow
.EXAMPLE
    Write-Header 'PASSED' -ForegroundColor green-rainbow
#>
function Write-Header {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string] $Message,

        [ValidateSet('Curved', 'Stars', 'Heavy')]
        [string] $Style = 'Curved',

        [int] $Width = 78,

        [object] $ForegroundColor
    )

    $color = Resolve-WriterColor -ForegroundColor $ForegroundColor -Bound:$PSBoundParameters.ContainsKey('ForegroundColor')

    $segments = switch ($Style) {
        'Curved' {
            $inner = $Width - 2
            $top = "╭$('─' * $inner)╮"
            $bottom = "╰$('─' * $inner)╯"
            if ($Message) {
                $maxMsg = $inner - 2
                $msg = if ($Message.Length -le $maxMsg) {
                    "│ $($Message.PadRight($maxMsg)) │"
                }
                else {
                    "│ $Message"
                }
                @(@{ Text = $top; Rule = $true }, @{ Text = $msg; Rule = $false }, @{ Text = $bottom; Rule = $true })
            }
            else {
                @(@{ Text = $top; Rule = $true })
            }
        }
        'Stars' {
            $separator = '*' * $Width
            $maxMsg = $Width - 4  # "* " + message + " *"
            if ($Message) {
                $msg = if ($Message.Length -le $maxMsg) {
                    "* $($Message.PadRight($maxMsg)) *"
                }
                else {
                    "* $Message"
                }
                @(@{ Text = $separator; Rule = $true }, @{ Text = $msg; Rule = $false }, @{ Text = $separator; Rule = $true })
            }
            else {
                @(@{ Text = $separator; Rule = $true })
            }
        }
        'Heavy' {
            $inner = $Width - 2
            $top = "╔$('═' * $inner)╗"
            $bottom = "╚$('═' * $inner)╝"
            if ($Message) {
                $maxMsg = $inner - 2
                $msg = if ($Message.Length -le $maxMsg) {
                    "║ $($Message.PadRight($maxMsg)) ║"
                }
                else {
                    "║ $Message"
                }
                @(@{ Text = $top; Rule = $true }, @{ Text = $msg; Rule = $false }, @{ Text = $bottom; Rule = $true })
            }
            else {
                @(@{ Text = $top; Rule = $true })
            }
        }
    }

    Write-FramedLine -Segment $segments -Color $color
}

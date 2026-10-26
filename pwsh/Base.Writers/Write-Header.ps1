<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-writers/Write-Header.ps1.md"
  header: "generated"
---
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

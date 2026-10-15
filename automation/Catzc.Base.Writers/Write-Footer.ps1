<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Writers/Write-Footer.ps1
    kind: public-function
    module: Catzc.Base.Writers
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Writes a closing footer line in a chosen style.
.DESCRIPTION
    Use the Style of the Write-Header it closes so the glyphs match; a rainbow colour draws a gradient rule.
.PARAMETER Style
    Visual style: Curved, Stars, or Heavy. Defaults to Curved.
.PARAMETER Width
    Total width of the line. Defaults to 78.
.PARAMETER ForegroundColor
    Omit it and the rule renders in the terminal default; a rainbow value gives a per-character gradient.
.EXAMPLE
    Write-Header 'Deploying'
    Deploy-App
    Write-Footer
.EXAMPLE
    Write-Footer -ForegroundColor rainbow
#>
function Write-Footer {
    [CmdletBinding()]
    param(
        [ValidateSet('Curved', 'Stars', 'Heavy')]
        [string] $Style = 'Curved',

        [int] $Width = 78,

        [object] $ForegroundColor
    )

    $color = Resolve-WriterColor -ForegroundColor $ForegroundColor -Bound:$PSBoundParameters.ContainsKey('ForegroundColor')

    $line = switch ($Style) {
        'Curved' {
            $inner = $Width - 2; "╰$('─' * $inner)╯"
        }
        'Stars' {
            '*' * $Width
        }
        'Heavy' {
            $inner = $Width - 2; "╚$('═' * $inner)╝"
        }
    }

    Write-FramedLine -Segment @(@{ Text = $line; Rule = $true }) -Color $color
}

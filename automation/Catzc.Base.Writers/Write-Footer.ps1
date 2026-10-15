<#
.SYNOPSIS
    Writes a closing footer line in a chosen style.
.DESCRIPTION
    Pairs with Write-Header to visually close a section.
    [comment:1](/docs/references/automation/catzc-base-writers/Write-Footer.ps1.md#comment1)
.PARAMETER Style
    Visual style: Curved, Stars, or Heavy. Defaults to Curved.
.PARAMETER Width
    Total width of the line. Defaults to 78.
.PARAMETER ForegroundColor
    Colour for the output: a [System.ConsoleColor] (or its name), a 'rainbow' / '<base>-rainbow' bareword, or a...
    [comment:2](/docs/references/automation/catzc-base-writers/Write-Footer.ps1.md#comment2)
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

<#
.SYNOPSIS
    Writes a closing footer line in a chosen style.
.DESCRIPTION
    Pairs with Write-Header to visually close a section.
    Renders a single closing line matching the header style:
      Curved:  ╰──────────────╯
      Stars:   ****************
      Heavy:   ╚══════════════╝

    -ForegroundColor takes either a [System.ConsoleColor] (or its string name) or a
    [Catzc.Base.Writers.RainbowColor] profile, which renders the closing rule as a per-character gradient.
.PARAMETER Style
    Visual style: Curved, Stars, or Heavy. Defaults to Curved.
.PARAMETER Width
    Total width of the line. Defaults to 78.
.PARAMETER ForegroundColor
    Colour for the output: a [System.ConsoleColor] (or its name), or a [Catzc.Base.Writers.RainbowColor]
    profile for a gradient rule. No colour by default (renders as terminal default).
.EXAMPLE
    Write-Header 'Deploying'
    Deploy-App
    Write-Footer
.EXAMPLE
    Write-Footer -ForegroundColor ([Catzc.Base.Writers.RainbowColor]::new('Green'))
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

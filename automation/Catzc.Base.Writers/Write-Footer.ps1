<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Writers/Write-Footer.ps1
    kind: public-function
    module: Catzc.Base.Writers
    visibility: public
  config:
    synopsis: Writes a closing footer line in a chosen style.
    description: |-
      Pairs with Write-Header to visually close a section.
      Renders a single closing line matching the header style:
        Curved:  ╰──────────────╯
        Stars:   ****************
        Heavy:   ╚══════════════╝

      -ForegroundColor takes either a [System.ConsoleColor] (or its string name), a 'rainbow' / '<base>-rainbow'
      bareword, or a [Catzc.Base.Writers.RainbowColor] profile — the last three render the closing rule as a
      per-character gradient.
    parameters:
      Style: 'Visual style: Curved, Stars, or Heavy. Defaults to Curved.'
      Width: Total width of the line. Defaults to 78.
      ForegroundColor: |-
        Colour for the output: a [System.ConsoleColor] (or its name), a 'rainbow' / '<base>-rainbow' bareword, or a
        [Catzc.Base.Writers.RainbowColor] profile — the last three give a gradient rule. No colour by default
        (renders as terminal default).
    examples:
      - |-
        Write-Header 'Deploying'
        Deploy-App
        Write-Footer
      - Write-Footer -ForegroundColor rainbow
---
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

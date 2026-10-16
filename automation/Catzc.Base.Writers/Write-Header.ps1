<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Writers/Write-Header.ps1
    name: write-header
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Writers
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Writers/tests/Write-Header.Tests.ps1
  config:
    synopsis: Writes a header with optional message in a chosen style.
    description: |-
      Styles (with message / without message):

        Curved (default):
          ╭──────────────╮       ╭──────────────╮
          │ Message      │
          ╰──────────────╯

        Stars:
          ****************       ****************
          * Message
          ****************

      -ForegroundColor takes either a [System.ConsoleColor] (or its string name) — one colour for the whole
      header — or a [Catzc.Base.Writers.RainbowColor] profile, which renders the horizontal rule lines as a
      per-character gradient while the titled line keeps the profile's base colour. The gradient is also
      reachable as a bareword: 'rainbow' (anchored on the ring head, a full chromatic walk) or '<base>-rainbow'
      (e.g. 'green-rainbow', the RainbowColor.ToString form). A profile passed to any plain [ConsoleColor] sink
      side-grades to its base, so the same value works everywhere.
    parameters:
      Message: The text to display. If omitted, writes a single separator line.
      Style: 'Visual style: Curved, Stars, or Heavy. Defaults to Curved.'
      Width: Total width of the separator lines. Defaults to 78.
      ForegroundColor: |-
        Colour for the output: a [System.ConsoleColor] (or its name), a 'rainbow' / '<base>-rainbow' bareword, or a
        [Catzc.Base.Writers.RainbowColor] profile — the last three give a gradient rule. No colour by default
        (renders as terminal default).
    examples:
      - Write-Header 'Deployment starting'
      - Write-Header 'Build' -Style Stars -ForegroundColor Yellow
      - Write-Header 'PASSED' -ForegroundColor rainbow
      - Write-Header 'PASSED' -ForegroundColor green-rainbow
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

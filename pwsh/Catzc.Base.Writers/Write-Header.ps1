<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Writers/Write-Header.ps1
    name: write-header
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Writers
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Writers/tests/Write-Header.Tests.ps1
    docs: "[Write-Header.ps1.md](docs/references/pwsh/catzc-base-writers/Write-Header.ps1.md)"
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

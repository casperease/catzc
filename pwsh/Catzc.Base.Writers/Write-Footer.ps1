<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Writers/Write-Footer.ps1
    name: write-footer
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
    test: pwsh/Catzc.Base.Writers/tests/Write-Footer.Tests.ps1
    docs: "[Write-Footer.ps1.md](docs/references/pwsh/catzc-base-writers/Write-Footer.ps1.md)"
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

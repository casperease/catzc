<#
---
catzc:
  immutable:
    with_body_sha: "36c57a2ddd2f"
  edges:
    test: pwsh/Catzc.Base.Files/tests/Get-InputStamp.Tests.ps1
    docs: "[Get-InputStamp.ps1.md](docs/references/pwsh/catzc-base-files/Get-InputStamp.ps1.md)"
    cites:
      - ADR-PRIN-ONELIVE
---
#>

function Get-InputStamp {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path,

        [string] $Filter = '*',

        [string[]] $Exclude = @(),

        [string] $Root = (Get-RepositoryRoot),

        [string] $Salt = ''
    )

    [Catzc.Base.Files.InputStamp]::Compute($Path, $Filter, $Exclude, $Root, $Salt)
}

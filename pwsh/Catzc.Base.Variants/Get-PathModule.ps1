<#
---
catzc:
  immutable:
    with_body_sha: "1bc0674ce148"
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
    docs: "[Get-PathModule.ps1.md](docs/references/pwsh/catzc-base-variants/Get-PathModule.ps1.md)"
    cites:
      - DDR-TRACK-ONETECHSTACK
---
#>

function Get-PathModule {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.PathModule])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Path
    )

    $module = (Get-Config -Config module-types).Resolve($Path)
    if ($module) {
        $module
    }
}

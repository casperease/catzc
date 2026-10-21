<#
---
catzc:
  immutable:
    with_body_sha: "5572da33bc67"
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Test-IsGuid.Tests.ps1
    docs: "[Test-IsGuid.ps1.md](docs/references/pwsh/catzc-base-asserts/Test-IsGuid.ps1.md)"
---
#>

function Test-IsGuid {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $ObjectGuid
    )

    [guid]::TryParse($ObjectGuid, [ref][guid]::Empty)
}

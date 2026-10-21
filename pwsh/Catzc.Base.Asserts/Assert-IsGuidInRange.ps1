<#
---
catzc:
  immutable:
    with_body_sha: "42ec386b0253"
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Assert-IsGuidInRange.Tests.ps1
    docs: "[Assert-IsGuidInRange.ps1.md](docs/references/pwsh/catzc-base-asserts/Assert-IsGuidInRange.ps1.md)"
---
#>

function Assert-IsGuidInRange {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $ObjectGuid,
        [Parameter(Mandatory)]
        [string] $From,
        [Parameter(Mandatory)]
        [string] $To
    )

    if (-not (Test-IsGuidInRange $ObjectGuid -From $From -To $To)) {
        throw "'$ObjectGuid' is not in the GUID range '$From'..'$To'"
    }
}

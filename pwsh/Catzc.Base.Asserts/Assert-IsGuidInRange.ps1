<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-asserts/Assert-IsGuidInRange.ps1.md"
  warning: "Generated Header"
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

<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Assert-IsGuidInRange.ps1
    kind: assert-function
    module: Catzc.Base.Asserts
    visibility: public
  config:
    synopsis: Asserts that a GUID lies inside an inclusive GUID range.
    description: The throwing form of Test-IsGuidInRange, which defines the ordering.
    parameters:
      ObjectGuid: The GUID to check.
      From: The first GUID of the range (inclusive).
      To: The last GUID of the range (inclusive).
    examples:
      - Assert-IsGuidInRange $budget -From $exemption.range.from -To $exemption.range.to
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

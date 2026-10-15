<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Assert-IsGuidInRange.ps1
    kind: function
    module: Catzc.Base.Asserts
    visibility: public
---
#>

<#
.SYNOPSIS
    Asserts that a GUID lies inside an inclusive GUID range.
.DESCRIPTION
    The throwing form of Test-IsGuidInRange, which defines the ordering.
.PARAMETER ObjectGuid
    The GUID to check.
.PARAMETER From
    The first GUID of the range (inclusive).
.PARAMETER To
    The last GUID of the range (inclusive).
.EXAMPLE
    Assert-IsGuidInRange $budget -From $exemption.range.from -To $exemption.range.to
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

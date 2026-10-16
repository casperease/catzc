<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Asserts/Assert-IsGuidInRange.ps1
    name: assert-is-guid-in-range
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
    visibility: public
  edges:
    test: automation/Catzc.Base.Asserts/tests/Assert-IsGuidInRange.Tests.ps1
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

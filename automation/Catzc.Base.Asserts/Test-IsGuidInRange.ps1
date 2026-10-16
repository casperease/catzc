<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Test-IsGuidInRange.ps1
    kind: function
    subkind: gate
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder-module
    bundle: minimal
    visibility: public
    relatives:
      test: automation/Catzc.Base.Asserts/tests/Test-IsGuidInRange.Tests.ps1
  config:
    synopsis: Tests whether a GUID lies inside an inclusive GUID range.
    description: |-
      Orders GUIDs by their 128 bits as written — the canonical lowercase hyphenated form, compared ordinally — which
      is how a reader sees a range in config, whatever case or braces the inputs use. A non-GUID input, or a range
      whose From is after its To, is a caller error and throws.
    parameters:
      ObjectGuid: The GUID to test.
      From: The first GUID of the range (inclusive).
      To: The last GUID of the range (inclusive).
    examples:
      - Test-IsGuidInRange $budget -From $exemption.range.from -To $exemption.range.to
---
#>

function Test-IsGuidInRange {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $ObjectGuid,
        [Parameter(Mandatory)]
        [string] $From,
        [Parameter(Mandatory)]
        [string] $To
    )

    Assert-IsGuid $ObjectGuid
    Assert-IsGuid $From
    Assert-IsGuid $To
    $value = ([guid]$ObjectGuid).ToString('D')
    $first = ([guid]$From).ToString('D')
    $last = ([guid]$To).ToString('D')
    if ([string]::CompareOrdinal($first, $last) -gt 0) {
        throw "GUID range is reversed: From '$first' is after To '$last'"
    }

    [string]::CompareOrdinal($value, $first) -ge 0 -and [string]::CompareOrdinal($value, $last) -le 0
}

<#
.SYNOPSIS
    Tests whether a GUID lies inside an inclusive GUID range.
.DESCRIPTION
    Orders GUIDs by their 128 bits as written — the canonical lowercase hyphenated form, compared ordinally — which
    is how a reader sees a range in config, whatever case or braces the inputs use. A non-GUID input, or a range
    whose From is after its To, is a caller error and throws.
.PARAMETER ObjectGuid
    The GUID to test.
.PARAMETER From
    The first GUID of the range (inclusive).
.PARAMETER To
    The last GUID of the range (inclusive).
.EXAMPLE
    Test-IsGuidInRange $budget -From $exemption.range.from -To $exemption.range.to
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

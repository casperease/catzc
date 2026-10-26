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

<#
.SYNOPSIS
    Asserts that a string is a valid GUID.
.PARAMETER ObjectGuid
    The string to validate as a GUID.
.EXAMPLE
    Assert-IsGuid 'a55e0700-a000-601d-0000-000000000000'
#>
function Assert-IsGuid {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $ObjectGuid
    )

    if (-not (Test-IsGuid $ObjectGuid)) {
        throw "'$ObjectGuid' is not a valid GUID"
    }
}

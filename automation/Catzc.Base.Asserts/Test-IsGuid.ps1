<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Test-IsGuid.ps1
    kind: function
    module: Catzc.Base.Asserts
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Tests whether a string is a valid GUID.
.PARAMETER ObjectGuid
    The string to validate as a GUID.
.EXAMPLE
    Test-IsGuid '15000000-1700-a000-601d-000000000000'
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

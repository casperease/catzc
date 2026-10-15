<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Assert-IsGuid.ps1
    kind: assert-function
    module: Catzc.Base.Asserts
    visibility: public
  config:
    synopsis: Asserts that a string is a valid GUID.
    parameters:
      ObjectGuid: The string to validate as a GUID.
    examples:
      - Assert-IsGuid 'a55e0700-a000-601d-0000-000000000000'
---
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

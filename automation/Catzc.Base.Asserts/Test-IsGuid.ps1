<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Test-IsGuid.ps1
    kind: gate-function
    module: Catzc.Base.Asserts
    visibility: public
    relatives:
      test: automation/Catzc.Base.Asserts/tests/Test-IsGuid.Tests.ps1
  config:
    synopsis: Tests whether a string is a valid GUID.
    parameters:
      ObjectGuid: The string to validate as a GUID.
    examples:
      - Test-IsGuid '15000000-1700-a000-601d-000000000000'
---
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

<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Assert-TypeIs.ps1
    kind: assert-function
    language: powershell
    track: automation
    module: Catzc.Base.Asserts
    visibility: public
    relatives:
      test: automation/Catzc.Base.Asserts/tests/Assert-TypeIs.Tests.ps1
  config:
    synopsis: Asserts that an object is a specific .NET type.
    parameters:
      Object: The object whose type to check.
      TypeFullName: The expected full type name (e.g. 'System.String').
    examples:
      - Assert-TypeIs $value 'System.Int32'
---
#>

function Assert-TypeIs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Object,

        [Parameter(Mandatory, Position = 1)]
        [string] $TypeFullName
    )

    if ($Object.GetType().FullName -ne $TypeFullName) {
        throw "Object is not a $TypeFullName (actual: $($Object.GetType().FullName))"
    }
}

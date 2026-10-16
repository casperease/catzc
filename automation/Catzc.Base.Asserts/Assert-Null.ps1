<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Asserts/Assert-Null.ps1
    name: assert-null
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
    visibility: public
  edges:
    test: automation/Catzc.Base.Asserts/tests/Assert-Null.Tests.ps1
  config:
    synopsis: Asserts that a value is $null.
    parameters:
      Value: The value to test. Must be exactly $null.
      ErrorText: Custom error message. Defaults to file and line info.
    examples:
      - Assert-Null $result
---
#>

function Assert-Null {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [object] $Value,

        [string] $ErrorText
    )

    if ($null -ne $Value) {
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            "Assertion failed: expected `$null — {0}, line {1}" -f $MyInvocation.ScriptName, $MyInvocation.ScriptLineNumber
        }
        throw $message
    }
}

<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Assert-NotNullOrWhitespace.ps1
    kind: assert-function
    module: Catzc.Base.Asserts
    visibility: public
    relatives:
      test: automation/Catzc.Base.Asserts/tests/Assert-NotNullOrWhitespace.Tests.ps1
  config:
    synopsis: Asserts that a value is not null, empty, or whitespace.
    parameters:
      Value: The value to test. Evaluated via [string]::IsNullOrWhiteSpace().
      ErrorText: Custom error message. Defaults to file and line info.
    examples:
      - Assert-NotNullOrWhitespace $name
---
#>

function Assert-NotNullOrWhitespace {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [object] $Value,

        [string] $ErrorText
    )

    if (-not (Test-NotNullOrWhitespace $Value)) {
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            'Assertion failed: value was null or whitespace — {0}, line {1}' -f $MyInvocation.ScriptName, $MyInvocation.ScriptLineNumber
        }
        throw $message
    }
}

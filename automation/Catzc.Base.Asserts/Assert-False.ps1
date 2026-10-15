<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Assert-False.ps1
    kind: assert-function
    module: Catzc.Base.Asserts
    visibility: public
    relatives:
      test: automation/Catzc.Base.Asserts/tests/Assert-False.Tests.ps1
  config:
    synopsis: Asserts that a value is boolean $false.
    parameters:
      Value: The value to test. Must be exactly [bool] $false.
      ErrorText: Custom error message. Defaults to file and line info.
    examples:
      - Assert-False $result
      - Assert-False ($x -eq 1) -ErrorText 'x should not equal 1'
---
#>

function Assert-False {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [object] $Value,

        [string] $ErrorText
    )

    if (-not (($Value -is [bool]) -and (-not $Value))) {
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            "Assertion failed: expected `$false — {0}, line {1}" -f $MyInvocation.ScriptName, $MyInvocation.ScriptLineNumber
        }
        throw $message
    }
}

<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Assert-NotNull.ps1
    kind: assert-function
    module: Catzc.Base.Asserts
    visibility: public
  config:
    synopsis: Asserts that a value is not $null.
    parameters:
      Value: The value to test. Must not be $null.
      ErrorText: Custom error message. Defaults to file and line info.
    examples:
      - Assert-NotNull $result
      - Assert-NotNull $release -ErrorText 'GitHub API returned null'
---
#>

function Assert-NotNull {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [object] $Value,

        [string] $ErrorText
    )

    if ($null -eq $Value) {
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            'Assertion failed: value was null — {0}, line {1}' -f $MyInvocation.ScriptName, $MyInvocation.ScriptLineNumber
        }
        throw $message
    }
}

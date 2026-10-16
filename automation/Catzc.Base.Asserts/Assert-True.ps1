<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Asserts/Assert-True.ps1
    name: assert-true
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
    test: automation/Catzc.Base.Asserts/tests/Assert-True.Tests.ps1
  config:
    synopsis: Asserts that a value is boolean $true.
    parameters:
      Value: The value to test. Must be exactly [bool] $true.
      ErrorText: Custom error message. Defaults to file and line info.
    examples:
      - Assert-True $result
      - Assert-True ($x -eq 1) -ErrorText 'x must equal 1'
---
#>

function Assert-True {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [object] $Value,

        [string] $ErrorText
    )

    if (-not (($Value -is [bool]) -and $Value)) {
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            "Assertion failed: expected `$true — {0}, line {1}" -f $MyInvocation.ScriptName, $MyInvocation.ScriptLineNumber
        }
        throw $message
    }
}

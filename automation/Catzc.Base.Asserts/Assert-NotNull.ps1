<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Asserts/Assert-NotNull.ps1
    name: assert-not-null
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
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

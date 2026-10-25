<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-asserts/Assert-NotNullOrWhitespace.ps1.md"
  header: "generated"
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

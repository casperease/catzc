<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-asserts/Assert-False.ps1.md"
  warning: "Generated Header"
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

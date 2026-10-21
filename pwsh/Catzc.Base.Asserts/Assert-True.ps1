<#
---
catzc:
  immutable:
    with_body_sha: a1fc6cfab863
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Assert-True.Tests.ps1
    docs: "[Assert-True.ps1.md](docs/references/pwsh/catzc-base-asserts/Assert-True.ps1.md)"
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

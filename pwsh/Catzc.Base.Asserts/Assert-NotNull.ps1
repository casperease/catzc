<#
---
catzc:
  immutable:
    with_body_sha: "74cb06f8499e"
  edges:
    docs: "[Assert-NotNull.ps1.md](docs/references/pwsh/catzc-base-asserts/Assert-NotNull.ps1.md)"
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

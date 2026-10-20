<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Asserts/Assert-False.ps1
    name: assert-false
    filetype: ps1
    role: function
    subkind: assert
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Assert-False.Tests.ps1
    docs: "[Assert-False.ps1.md](docs/references/pwsh/catzc-base-asserts/Assert-False.ps1.md)"
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
